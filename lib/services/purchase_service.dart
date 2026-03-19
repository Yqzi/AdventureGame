import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:Questborne/models/subscription.dart';
import 'package:Questborne/services/subscription_service.dart';

/// Manages Google Play Billing subscriptions.
///
/// Flow:
///  1. User taps "Subscribe" → [buy] launches the Play Store sheet.
///  2. Play Store returns a [PurchaseDetails] via the purchase stream.
///  3. We send the purchase token to the `verify-purchase` Edge Function,
///     which validates it with Google and upserts `user_subscriptions`.
///  4. We call [SubscriptionService.refresh] so the UI updates.
class PurchaseService {
  PurchaseService._();
  static final PurchaseService _instance = PurchaseService._();
  factory PurchaseService() => _instance;

  final InAppPurchase _iap = InAppPurchase.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  bool _initialized = false;

  /// Product details fetched from Play Store.
  /// Keyed by "{subscriptionId}:{basePlanId}" for easy lookup.
  final Map<String, GooglePlayProductDetails> products = {};

  /// The most recent active purchase, used for upgrade/downgrade flows.
  GooglePlayPurchaseDetails? _activePurchase;

  /// Callback invoked when a purchase succeeds or fails.
  /// The page sets this before triggering [buy].
  void Function(SubscriptionTier tier, bool success, String? error)?
  onPurchaseResult;

  // ── Init / dispose ──────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final available = await _iap.isAvailable();
    if (!available) {
      debugPrint('PurchaseService: In-app purchases not available');
      return;
    }

    // Listen for purchase updates (new purchases + pending ones on app start).
    _purchaseSub = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _purchaseSub?.cancel(),
      onError: (e) => debugPrint('PurchaseService stream error: $e'),
    );

    // Fetch product details from the store.
    final subscriptionIds = <String>{};
    for (final tier in SubscriptionTier.values) {
      final subId = tier.playStoreSubscriptionId;
      if (subId != null) subscriptionIds.add(subId);
    }

    final response = await _iap.queryProductDetails(subscriptionIds);
    if (response.error != null) {
      debugPrint('PurchaseService query error: ${response.error}');
    }
    for (final p in response.productDetails) {
      if (p is GooglePlayProductDetails) {
        final idx = p.subscriptionIndex;
        final offerDetails = p.productDetails.subscriptionOfferDetails;
        if (idx != null && offerDetails != null && idx < offerDetails.length) {
          final basePlanId = offerDetails[idx].basePlanId;
          products['${p.id}:$basePlanId'] = p;
        } else {
          products[p.id] = p;
        }
      }
    }

    // Restore previous purchases to capture the active purchase token.
    // This lets us do upgrade/downgrade flows via ChangeSubscriptionParam.
    try {
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint('PurchaseService: restore on init failed: $e');
    }
  }

  void dispose() {
    _purchaseSub?.cancel();
  }

  // ── Buy ──────────────────────────────────────────────────

  /// Starts the Play Store purchase flow for a specific base plan.
  ///
  /// If the user already has an active subscription (different product),
  /// this uses [ChangeSubscriptionParam] to upgrade/downgrade instead
  /// of starting a fresh purchase (which would fail with "already owned").
  ///
  /// Returns `false` if the product or base plan is unavailable.
  bool buyBasePlan(SubscriptionTier tier, String basePlanId) {
    final subId = tier.playStoreSubscriptionId;
    if (subId == null) return false;

    final product = products['$subId:$basePlanId'];
    if (product == null) {
      debugPrint('PurchaseService: $subId:$basePlanId not found');
      return false;
    }

    // If user has an active subscription to a *different* product,
    // treat this as an upgrade/downgrade.
    ChangeSubscriptionParam? changeParam;
    if (_activePurchase != null && _activePurchase!.productID != subId) {
      changeParam = ChangeSubscriptionParam(
        oldPurchaseDetails: _activePurchase!,
        replacementMode: ReplacementMode.withTimeProration,
      );
      debugPrint(
        'PurchaseService: upgrading from ${_activePurchase!.productID} → $subId',
      );
    }

    final param = GooglePlayPurchaseParam(
      productDetails: product,
      offerToken: product.offerToken,
      changeSubscriptionParam: changeParam,
    );
    _iap.buyNonConsumable(purchaseParam: param);
    return true;
  }

  /// Restore previous purchases (e.g. after reinstall).
  Future<void> restore() => _iap.restorePurchases();

  // ── Purchase stream handler ──────────────────────────────

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      debugPrint(
        'PurchaseService: status=${purchase.status} product=${purchase.productID}',
      );

      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Track the active purchase for future upgrade/downgrade flows.
          if (purchase is GooglePlayPurchaseDetails) {
            _activePurchase = purchase;
          }
          // Verify with server for both new and restored purchases.
          // Restored purchases need verification too — they may not have
          // been synced to the server yet (e.g. after reinstall, or if
          // the original verification failed).
          await _verifyAndDeliver(purchase);
          break;
        case PurchaseStatus.error:
          debugPrint(
            'Purchase error: code=${purchase.error?.code} '
            'message=${purchase.error?.message}',
          );
          final tier = _tierFromProductId(purchase.productID);
          onPurchaseResult?.call(
            tier ?? SubscriptionTier.free,
            false,
            purchase.error?.message ?? 'Purchase failed',
          );
          break;
        case PurchaseStatus.canceled:
          final tier = _tierFromProductId(purchase.productID);
          onPurchaseResult?.call(
            tier ?? SubscriptionTier.free,
            false,
            'Purchase cancelled',
          );
          break;
        case PurchaseStatus.pending:
          debugPrint('Purchase pending: ${purchase.productID}');
          break;
      }

      // Complete the purchase so the store doesn't keep retrying.
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  /// Sends the purchase token to the server for verification.
  Future<void> _verifyAndDeliver(PurchaseDetails purchase) async {
    final tier = _tierFromProductId(purchase.productID);

    try {
      final token = Platform.isAndroid
          ? purchase.verificationData.serverVerificationData
          : purchase.verificationData.serverVerificationData;

      await _supabase.functions.invoke(
        'verify-purchase',
        body: {
          'platform': Platform.isAndroid ? 'android' : 'ios',
          'product_id': purchase.productID,
          'purchase_token': token,
        },
      );

      // Refresh local subscription cache from Supabase.
      await SubscriptionService().refresh();
      onPurchaseResult?.call(tier ?? SubscriptionTier.free, true, null);
    } catch (e) {
      debugPrint('verify-purchase failed: $e');
      onPurchaseResult?.call(
        tier ?? SubscriptionTier.free,
        false,
        'Verification failed. If charged, it will resolve shortly.',
      );
    }
  }

  // ── Helpers ──────────────────────────────────────────────

  SubscriptionTier? _tierFromProductId(String productId) {
    for (final tier in SubscriptionTier.values) {
      if (tier.playStoreSubscriptionId == productId) return tier;
    }
    return null;
  }

  /// Returns the store price string for a specific base plan,
  /// or `null` if the product hasn't loaded.
  String? priceForBasePlan(SubscriptionTier tier, String basePlanId) {
    final subId = tier.playStoreSubscriptionId;
    if (subId == null) return null;
    return products['$subId:$basePlanId']?.price;
  }

  /// Returns the store price string for a tier's monthly plan,
  /// or `null` if the product hasn't loaded.
  String? storePriceFor(SubscriptionTier tier) {
    return priceForBasePlan(tier, 'monthly');
  }
}
