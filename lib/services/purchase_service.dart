import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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

  /// Product details fetched from Play Store, keyed by product ID.
  final Map<String, ProductDetails> products = {};

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
    final productIds = <String>{};
    for (final tier in SubscriptionTier.values) {
      productIds.addAll(tier.playStoreProductIds.values);
    }

    final response = await _iap.queryProductDetails(productIds);
    if (response.error != null) {
      debugPrint('PurchaseService query error: ${response.error}');
    }
    for (final p in response.productDetails) {
      products[p.id] = p;
    }
  }

  void dispose() {
    _purchaseSub?.cancel();
  }

  // ── Buy ──────────────────────────────────────────────────

  /// Starts the Play Store purchase flow for a specific [productId].
  ///
  /// Returns `false` if the product is unavailable.
  bool buyProduct(String productId) {
    final product = products[productId];
    if (product == null) {
      debugPrint('PurchaseService: product $productId not found');
      return false;
    }

    final param = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(purchaseParam: param);
    return true;
  }

  /// Starts the Play Store purchase flow for the given [tier] (monthly).
  ///
  /// Returns `false` if the product is unavailable.
  bool buy(SubscriptionTier tier) {
    final productId = tier.playStoreProductId;
    if (productId == null) return false;
    return buyProduct(productId);
  }

  /// Restore previous purchases (e.g. after reinstall).
  Future<void> restore() => _iap.restorePurchases();

  // ── Purchase stream handler ──────────────────────────────

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyAndDeliver(purchase);
          break;
        case PurchaseStatus.error:
          debugPrint('Purchase error: ${purchase.error}');
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
      if (tier.playStoreProductId == productId) return tier;
    }
    return null;
  }

  /// Returns the store price string for a specific product ID,
  /// or `null` if the product hasn't loaded.
  String? storePriceForProduct(String productId) {
    return products[productId]?.price;
  }

  /// Returns the store price string for a tier's monthly product,
  /// or `null` if the product hasn't loaded.
  String? storePriceFor(SubscriptionTier tier) {
    final id = tier.playStoreProductId;
    if (id == null) return null;
    return products[id]?.price;
  }
}
