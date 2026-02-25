import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Lightweight wrapper around Supabase Auth for Google, Apple, and guest flows.
class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // ── Session helpers ──────────────────────────────────────────

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  bool get isGuest => currentUser?.isAnonymous ?? false;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // ── Google Sign-In ───────────────────────────────────────────

  /// Sign in with Google via native flow, then exchange the ID token with
  /// Supabase. Returns the [AuthResponse].
  ///
  /// Set your **Web client ID** (from Google Cloud Console → Credentials →
  /// OAuth 2.0) and optionally your iOS client ID below.
  Future<AuthResponse> signInWithGoogle() async {
    // TODO: Replace with your own Web + iOS client IDs from Google Cloud Console.
    const webClientId =
        '272639844844-2c3b93jcf9uatmenmunl90501ngmn67o.apps.googleusercontent.com';
    const iosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';

    final googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in was cancelled.');

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw Exception('Could not retrieve Google ID token.');
    }

    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // ── Apple Sign-In ────────────────────────────────────────────

  /// Sign in with Apple (iOS only). Uses a raw nonce for security.
  Future<AuthResponse> signInWithApple() async {
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw Exception('Could not retrieve Apple ID token.');
    }

    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  /// Whether Apple Sign-In is available (iOS/macOS only).
  bool get isAppleSignInAvailable =>
      !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  // ── Guest (anonymous) ────────────────────────────────────────

  /// Continue without an account. Creates an anonymous Supabase session.
  Future<AuthResponse> signInAsGuest() async {
    return await _client.auth.signInAnonymously();
  }

  // ── Link identity (anonymous → permanent) ────────────────────

  /// Links a Google account to the current anonymous user by:
  /// 1. Reading the anonymous user's data while still in their session
  /// 2. Signing in with Google natively (switches session)
  /// 3. Writing the anonymous data to the Google user's rows
  ///
  /// Returns the new [AuthResponse] for the Google account.
  Future<AuthResponse> linkWithGoogle() async {
    final anonUserId = currentUser?.id;
    if (anonUserId == null) throw Exception('No anonymous session found.');

    // ── Read anonymous data BEFORE switching sessions ──
    // (RLS only allows reading your own rows, so we must do this now)
    final anonSave = await _client
        .from('player_saves')
        .select()
        .eq('user_id', anonUserId)
        .maybeSingle();

    final anonSessions = await _client
        .from('game_sessions')
        .select()
        .eq('user_id', anonUserId);

    // ── Switch session to Google ──
    final response = await signInWithGoogle();
    final newUserId = response.user?.id;

    if (newUserId != null && newUserId != anonUserId) {
      // Migrate data from anonymous user → Google user
      await _migrateData(
        to: newUserId,
        anonSave: anonSave,
        anonSessions: anonSessions as List,
      );
    }

    return response;
  }

  /// Writes previously-read anonymous data to the new user's rows.
  Future<void> _migrateData({
    required String to,
    required Map<String, dynamic>? anonSave,
    required List anonSessions,
  }) async {
    // ── player_saves ──
    if (anonSave != null) {
      final existingSave = await _client
          .from('player_saves')
          .select('user_id')
          .eq('user_id', to)
          .maybeSingle();

      if (existingSave == null) {
        await _client.from('player_saves').upsert({
          'user_id': to,
          'player': anonSave['player'],
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        });
      }
    }

    // ── game_sessions ──
    for (final session in anonSessions) {
      final existing = await _client
          .from('game_sessions')
          .select('id')
          .eq('user_id', to)
          .eq('quest_id', session['quest_id'])
          .maybeSingle();

      if (existing == null) {
        await _client.from('game_sessions').upsert({
          'user_id': to,
          'quest_id': session['quest_id'],
          'session': session['session'],
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }, onConflict: 'user_id, quest_id');
      }
    }
  }

  // ── Sign out ─────────────────────────────────────────────────

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ── Helpers ──────────────────────────────────────────────────

  /// Generates a cryptographically-secure random nonce string.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
