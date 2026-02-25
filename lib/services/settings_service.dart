import 'package:shared_preferences/shared_preferences.dart';

/// Persists user-configurable settings via SharedPreferences.
class SettingsService {
  static const _keyHateSpeech = 'safety_hateSpeech';
  static const _keyHarassment = 'safety_harassment';
  static const _keyDangerousContent = 'safety_dangerousContent';

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
  // Stored as ints: 2 = medium, 3 = high (default)

  static int _clampLevel(int? v) => (v == null || v < 2 || v > 3) ? 3 : v;

  int get hateSpeechLevel => _clampLevel(_prefs.getInt(_keyHateSpeech));
  set hateSpeechLevel(int v) => _prefs.setInt(_keyHateSpeech, v);

  int get harassmentLevel => _clampLevel(_prefs.getInt(_keyHarassment));
  set harassmentLevel(int v) => _prefs.setInt(_keyHarassment, v);

  int get dangerousContentLevel =>
      _clampLevel(_prefs.getInt(_keyDangerousContent));
  set dangerousContentLevel(int v) => _prefs.setInt(_keyDangerousContent, v);

  /// Human-readable label for a given safety level int.
  static String levelLabel(int level) {
    switch (level) {
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'High';
    }
  }

  /// Description for a given safety level int.
  static String levelDescription(int level) {
    switch (level) {
      case 2:
        return 'Balanced filtering';
      case 3:
        return 'Strict content filtering';
      default:
        return 'Strict content filtering';
    }
  }
}
