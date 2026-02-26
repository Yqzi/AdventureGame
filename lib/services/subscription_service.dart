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
      print('SubscriptionService.fetch failed: $e');
      // Keep whatever we had before; don't crash the app.
    }
    _loaded = true;
    return _cached;
  }

  /// Force-refresh from Supabase (e.g. after a purchase completes).
  Future<UserSubscription> refresh() => fetch();

  /// Clear cached data (e.g. on sign-out).
  void clear() {
    _cached = UserSubscription.free();
    _loaded = false;
  }
}
