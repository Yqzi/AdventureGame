import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Questborne/models/subscription.dart';

/// Reads and caches the user's subscription from Supabase.
///
/// The canonical source-of-truth is the `user_subscriptions` table, which
/// the Edge Function also reads when enforcing credits.  This service is
/// intentionally thin — purchasing happens via the platform store and a
/// webhook writes to Supabase; we only *read* here.
class SubscriptionService {
  // ── Singleton ────────────────────────────────────────────

  SubscriptionService._();
  static final SubscriptionService _instance = SubscriptionService._();
  factory SubscriptionService() => _instance;

  final SupabaseClient _client = Supabase.instance.client;

  /// In-memory cache so the UI doesn't hit Supabase on every frame.
  UserSubscription _cached = UserSubscription.free();
  bool _loaded = false;

  UserSubscription get current => _cached;
  bool get isLoaded => _loaded;

  /// Fetch the subscription row for the current user.
  ///
  /// Falls back to [UserSubscription.free] when:
  /// - the user is not logged in,
  /// - there is no row yet, or
  /// - the network call fails.
  Future<UserSubscription> fetch() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        _cached = UserSubscription.free();
        _loaded = true;
        return _cached;
      }

      final res = await _client
          .from('user_subscriptions')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (res == null) {
        _cached = UserSubscription.free();
      } else {
        _cached = UserSubscription.fromJson(res);
      }
    } catch (e) {
      debugPrint('SubscriptionService.fetch failed: $e');
      // Keep whatever we had before; don't crash the app.
    }
    _loaded = true;
    return _cached;
  }

  /// Verify the subscription with the server-side Edge Function.
  ///
  /// This calls `check-subscription` which validates expiry and
  /// optionally re-verifies the purchase receipt with Google Play.
  /// Use on app start and after restore purchases.
  Future<UserSubscription> verify({
    String? purchaseToken,
    String? productId,
  }) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        _cached = UserSubscription.free();
        _loaded = true;
        return _cached;
      }

      final body = <String, dynamic>{};
      if (purchaseToken != null && productId != null) {
        body['purchase_token'] = purchaseToken;
        body['product_id'] = productId;
      }

      final response = await _client.functions.invoke(
        'check-subscription',
        body: body.isEmpty ? null : body,
      );

      final data = response.data as Map<String, dynamic>?;
      if (data != null && data['tier'] != null) {
        // Refresh from DB to get the full row after server-side sync.
        return fetch();
      }
    } catch (e) {
      debugPrint('SubscriptionService.verify failed: $e');
    }
    // Fall back to a normal fetch if the Edge Function fails.
    return fetch();
  }

  /// Force-refresh from Supabase (e.g. after a purchase completes).
  Future<UserSubscription> refresh() => fetch();

  /// Clear cached data (e.g. on sign-out).
  void clear() {
    _cached = UserSubscription.free();
    _loaded = false;
  }
}
