import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists user-configurable settings via SharedPreferences.
class SettingsService {
  static const _keyHateSpeech = 'safety_hateSpeech';
  static const _keyHarassment = 'safety_harassment';
  static const _keyDangerousContent = 'safety_dangerousContent';
  static const _keyLocale = 'app_locale';

  // ── Singleton ────────────────────────────────────────────────

  SettingsService._();
  static final SettingsService _instance = SettingsService._();
  factory SettingsService() => _instance;

  late final SharedPreferences _prefs;
  bool _initialised = false;

  Future<void> init() async {
    if (_initialised) return;
    _prefs = await SharedPreferences.getInstance();
    _initialised = true;
  }

  // ── Safety thresholds ────────────────────────────────────────
  // Stored as ints: 1 = low (permissive), 2 = medium, 3 = high (strict)

  static int _clampLevel(int? v) => (v == null || v < 1 || v > 3) ? 1 : v;

  int get hateSpeechLevel => _clampLevel(_prefs.getInt(_keyHateSpeech));
  set hateSpeechLevel(int v) => _prefs.setInt(_keyHateSpeech, v);

  int get harassmentLevel => _clampLevel(_prefs.getInt(_keyHarassment));
  set harassmentLevel(int v) => _prefs.setInt(_keyHarassment, v);

  int get dangerousContentLevel =>
      _clampLevel(_prefs.getInt(_keyDangerousContent));
  set dangerousContentLevel(int v) => _prefs.setInt(_keyDangerousContent, v);

  // ── Locale ───────────────────────────────────────────────────
  // null = follow system locale

  /// Returns the user's chosen locale, or null for system default.
  Locale? get locale {
    final code = _prefs.getString(_keyLocale);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  /// Set the locale (pass null to revert to system default).
  set locale(Locale? v) {
    if (v == null) {
      _prefs.remove(_keyLocale);
    } else {
      _prefs.setString(_keyLocale, v.languageCode);
    }
  }

  /// Human-readable label for a given safety level int.
  static String levelLabel(int level) {
    switch (level) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Low';
    }
  }

  /// Description for a given safety level int.
  static String levelDescription(int level) {
    switch (level) {
      case 1:
        return 'Permissive — suited for dark fantasy';
      case 2:
        return 'Balanced filtering';
      case 3:
        return 'Strict content filtering';
      default:
        return 'Permissive — suited for dark fantasy';
    }
  }
}
