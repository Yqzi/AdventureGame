import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Questborne/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:Questborne/blocs/app/app_bloc.dart';
import 'package:Questborne/blocs/app/app_event.dart';
import 'package:Questborne/colors.dart';
import 'package:Questborne/components/top_bar.dart';
import 'package:Questborne/router.dart';
import 'package:Questborne/services/auth_service.dart';
import 'package:Questborne/services/game_session_repository.dart';
import 'package:Questborne/services/settings_service.dart';
import 'package:Questborne/models/subscription.dart';
import 'package:Questborne/services/purchase_service.dart';
import 'package:Questborne/services/subscription_service.dart';
import 'package:Questborne/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _settings = SettingsService();
  final AuthService _auth = AuthService();

  // ── Styling constants ──────────────────────────────────────

  static const _cardColor = Color.fromARGB(255, 30, 18, 14);
  static const _dividerColor = Color.fromARGB(60, 255, 255, 255);
  static const _sectionBg = Color.fromARGB(255, 41, 26, 20);
  static const _creamText = Color(0xFFE3D5B8);

  TextStyle _label({double size = 15, Color color = Colors.white}) =>
      GoogleFonts.epilogue(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
      );

  TextStyle _sublabel() => GoogleFonts.epilogue(
    fontSize: 12,
    color: Colors.white54,
    letterSpacing: 0.3,
  );

  // ─────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final player = context.read<GameBloc>().player;

    return Scaffold(
      backgroundColor: _sectionBg,
      appBar: TopBar(
        title: AppLocalizations.of(context).settingsTitle,
        textStyle: GoogleFonts.epilogue(
          color: _creamText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1.25,
          fontStyle: FontStyle.italic,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: _creamText,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // ── Profile ──────────────────────────────────────
          _sectionHeader(AppLocalizations.of(context).settingsProfile),
          const SizedBox(height: 8),
          _settingsTile(
            icon: Icons.person_outline,
            title: AppLocalizations.of(context).settingsCharacterName,
            subtitle: player.name,
            onTap: () => _showChangeNameDialog(player.name),
          ),
          if (!_auth.isGuest && _auth.currentUser?.email != null) ...[
            _divider(),
            _settingsTile(
              icon: Icons.email_outlined,
              title: AppLocalizations.of(context).settingsEmail,
              subtitle: _auth.currentUser!.email!,
              onTap: () {},
            ),
          ],

          const SizedBox(height: 24),

          // ── AI Safety ────────────────────────────────────
          _sectionHeader(AppLocalizations.of(context).settingsAiSafety),
          const SizedBox(height: 8),
          _safetyTile(
            label: AppLocalizations.of(context).settingsHateSpeech,
            level: _settings.hateSpeechLevel,
            onChanged: (v) {
              setState(() => _settings.hateSpeechLevel = v);
              _reloadAI();
            },
          ),
          _divider(),
          _safetyTile(
            label: AppLocalizations.of(context).settingsHarassment,
            level: _settings.harassmentLevel,
            onChanged: (v) {
              setState(() => _settings.harassmentLevel = v);
              _reloadAI();
            },
          ),
          _divider(),
          _safetyTile(
            label: AppLocalizations.of(context).settingsDangerousContent,
            level: _settings.dangerousContentLevel,
            onChanged: (v) {
              setState(() => _settings.dangerousContentLevel = v);
              _reloadAI();
            },
          ),

          const SizedBox(height: 24),

          // ── General ──────────────────────────────────────
          _sectionHeader(AppLocalizations.of(context).settingsGeneral),
          const SizedBox(height: 8),
          _divider(),
          _settingsTile(
            icon: Icons.workspace_premium_outlined,
            title: AppLocalizations.of(context).settingsPremium,
            subtitle: AppLocalizations.of(context).settingsPremiumSubtitle,
            onTap: () => Navigator.pushNamed(context, AppRouter.subscription),
          ),
          _divider(),
          _settingsTile(
            icon: Icons.restore,
            title: AppLocalizations.of(context).settingsRestoreSubscription,
            subtitle: AppLocalizations.of(context).settingsRestoreSubtitle,
            onTap: () => _restoreSubscription(),
          ),
          _divider(),
          _settingsTile(
            icon: Icons.language,
            title: AppLocalizations.of(context).settingsLanguage,
            subtitle: AppLocalizations.of(context).settingsLanguageSubtitle,
            onTap: () => _showLanguagePicker(),
          ),

          const SizedBox(height: 24),

          // ── Danger zone ──────────────────────────────────
          _sectionHeader(
            AppLocalizations.of(context).settingsAccount,
            color: redText,
          ),
          const SizedBox(height: 8),

          _settingsTile(
            icon: Icons.delete_forever,
            title: AppLocalizations.of(context).settingsDeleteAccount,
            subtitle: AppLocalizations.of(context).settingsDeleteSubtitle,
            onTap: () => _confirmDeleteAccount(),
            iconColor: redText,
            titleColor: redText,
          ),

          const SizedBox(height: 24),

          // ── Legal ────────────────────────────────────────
          _sectionHeader(AppLocalizations.of(context).settingsLegal),
          const SizedBox(height: 8),
          _settingsTile(
            icon: Icons.privacy_tip_outlined,
            title: AppLocalizations.of(context).settingsPrivacyPolicy,
            subtitle: AppLocalizations.of(context).settingsPrivacySubtitle,
            onTap: () => launchUrl(
              Uri.parse(
                'https://yqzi.github.io/AdventureGame/privacy-policy.html',
              ),
              mode: LaunchMode.externalApplication,
            ),
          ),
          _divider(),
          _settingsTile(
            icon: Icons.description_outlined,
            title: AppLocalizations.of(context).settingsTermsOfService,
            subtitle: AppLocalizations.of(context).settingsTermsSubtitle,
            onTap: () => launchUrl(
              Uri.parse('https://yqzi.github.io/AdventureGame/terms.html'),
              mode: LaunchMode.externalApplication,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  UI BUILDING BLOCKS
  // ─────────────────────────────────────────────────────────

  Widget _sectionHeader(String text, {Color color = _creamText}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: GoogleFonts.epilogue(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = _creamText,
    Color titleColor = Colors.white,
  }) {
    return Material(
      color: _cardColor,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        splashColor: Colors.white10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: _label(color: titleColor)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: _sublabel()),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _safetyTile({
    required String label,
    required int level,
    required ValueChanged<int> onChanged,
  }) {
    return Material(
      color: _cardColor,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => _showSafetyPicker(label, level, onChanged),
        splashColor: Colors.white10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.shield_outlined, color: _creamText, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: _label()),
                    const SizedBox(height: 2),
                    Text(
                      SettingsService.levelLabel(level),
                      style: _sublabel().copyWith(color: _levelColor(level)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, thickness: 0.5, color: _dividerColor);

  Color _levelColor(int level) {
    switch (level) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.amber;
      case 3:
        return Colors.greenAccent;
      default:
        return Colors.orange;
    }
  }

  // ─────────────────────────────────────────────────────────
  //  DIALOGS & ACTIONS
  // ─────────────────────────────────────────────────────────

  void _reloadAI() {
    context.read<GameBloc>().aiService.reloadSafetySettings();
  }

  // ── Change name ──────────────────────────────────────────

  Future<void> _showChangeNameDialog(String currentName) async {
    final controller = TextEditingController(text: currentName);

    final newName = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                top: BorderSide(color: borderGrey, width: 0.5),
                left: BorderSide(color: borderGrey, width: 0.5),
                right: BorderSide(color: borderGrey, width: 0.5),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context).settingsChangeName,
                      style: GoogleFonts.epilogue(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _creamText,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context).settingsChangeNameDesc,
                      style: _sublabel(),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      maxLength: 20,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[a-zA-Z\s\-']"),
                        ),
                      ],
                      autofocus: true,
                      style: GoogleFonts.epilogue(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: redText,
                      decoration: InputDecoration(
                        counterStyle: GoogleFonts.epilogue(
                          color: Colors.white30,
                          fontSize: 11,
                        ),
                        filled: true,
                        fillColor: _sectionBg,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: borderGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: redText,
                            width: 1.5,
                          ),
                        ),
                        hintText: AppLocalizations.of(
                          context,
                        ).settingsEnterNewName,
                        hintStyle: GoogleFonts.epilogue(
                          color: Colors.white24,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context).buttonCancel,
                                style: _label(size: 15, color: Colors.white54),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                final name = controller.text.trim();
                                if (name.toLowerCase() == 'adventurer') {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    SnackBar(
                                      backgroundColor: _cardColor,
                                      content: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).settingsNameReserved,
                                        style: GoogleFonts.epilogue(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (name.isNotEmpty) Navigator.pop(ctx, name);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: redText,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                AppLocalizations.of(context).buttonSave,
                                style: _label(size: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (newName != null && newName != currentName && mounted) {
      context.read<GameBloc>().add(SetPlayerNameEvent(newName));
      setState(() {}); // refresh subtitle
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _cardColor,
            content: Text(
              AppLocalizations.of(context).settingsNameChanged(newName),
              style: GoogleFonts.epilogue(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  // ── Safety picker ────────────────────────────────────────

  void _showSafetyPicker(
    String label,
    int current,
    ValueChanged<int> onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(color: borderGrey),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    label,
                    style: GoogleFonts.epilogue(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: _creamText,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppLocalizations.of(context).settingsChooseFilterLevel,
                    style: _sublabel(),
                  ),
                ),
                const SizedBox(height: 12),
                for (int i = 1; i <= 3; i++)
                  _safetyOption(
                    ctx: ctx,
                    level: i,
                    isSelected: i == current,
                    onTap: () {
                      onChanged(i);
                      Navigator.pop(ctx);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _safetyOption({
    required BuildContext ctx,
    required int level,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? redText : Colors.white38,
        size: 20,
      ),
      title: Text(
        SettingsService.levelLabel(level),
        style: _label(color: isSelected ? Colors.white : Colors.white70),
      ),
      subtitle: Text(
        SettingsService.levelDescription(level),
        style: _sublabel(),
      ),
    );
  }

  // ── Language picker ───────────────────────────────────────

  void _showLanguagePicker() {
    final l10n = AppLocalizations.of(context);
    final settings = SettingsService();
    final currentLocale = settings.locale;

    final options = <({Locale? locale, String label})>[
      (locale: null, label: l10n.settingsLanguageSystem),
      (locale: const Locale('en'), label: 'English'),
      (locale: const Locale('fr'), label: 'Français'),
      (locale: const Locale('ru'), label: 'Русский'),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                l10n.settingsLanguage,
                style: GoogleFonts.epilogue(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              for (final opt in options)
                ListTile(
                  title: Text(
                    opt.label,
                    style: GoogleFonts.epilogue(color: Colors.white),
                  ),
                  trailing:
                      (opt.locale == currentLocale ||
                          (opt.locale == null && currentLocale == null))
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                  onTap: () {
                    settings.locale = opt.locale;
                    localeNotifier.value = opt.locale;
                    Navigator.pop(ctx);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ── Restore subscription ─────────────────────────────────

  Future<void> _restoreSubscription() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardColor,
        content: Text(
          AppLocalizations.of(context).settingsCheckingSubscription,
          style: GoogleFonts.epilogue(color: Colors.white),
        ),
      ),
    );

    try {
      final purchaseService = PurchaseService();
      await purchaseService.init();
      await purchaseService.restore();

      // Wait briefly for the purchase stream to deliver restored purchases
      // and for _verifyAndDeliver to call the edge function.
      await Future.delayed(const Duration(seconds: 3));

      // Now fetch the latest subscription state from the server.
      final sub = await SubscriptionService().fetch();

      if (!mounted) return;

      final isActive = sub.effectiveTier != SubscriptionTier.free;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _cardColor,
          content: Text(
            isActive
                ? AppLocalizations.of(
                    context,
                  ).settingsSubscriptionRestored(sub.effectiveTier.label)
                : AppLocalizations.of(context).settingsNoSubscription,
            style: GoogleFonts.epilogue(color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _cardColor,
          content: Text(
            AppLocalizations.of(context).settingsRestoreFailed,
            style: GoogleFonts.epilogue(color: Colors.white),
          ),
        ),
      );
    }
  }

  // ── Delete account ───────────────────────────────────────

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await _showConfirmDialog(
      title: AppLocalizations.of(context).settingsDeleteTitle,
      message: AppLocalizations.of(context).settingsDeleteMessage,
      confirmLabel: AppLocalizations.of(context).settingsDeleteConfirm,
    );
    if (confirmed != true || !mounted) return;

    try {
      // Call the Edge Function which deletes all user data + the auth user
      await Supabase.instance.client.functions.invoke('delete-account');

      // Clear all local state
      GameSessionRepository().clearLocal();
      SubscriptionService().clear();
      await Supabase.instance.client.auth.signOut();

      if (mounted) {
        context.read<GameBloc>().add(ResetPlayerEvent());
      }
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/start', (_) => false);
      }
    } catch (e) {
      // If the edge function fails because the account was already deleted
      // (e.g. deleted via web portal), force a local sign-out so the user
      // isn't stuck in a zombie session.
      final msg = e.toString().toLowerCase();
      final alreadyGone =
          msg.contains('user not found') ||
          msg.contains('not authenticated') ||
          msg.contains('unauthorized') ||
          msg.contains('jwt') ||
          msg.contains('401') ||
          msg.contains('403');

      if (alreadyGone) {
        GameSessionRepository().clearLocal();
        SubscriptionService().clear();
        await Supabase.instance.client.auth.signOut();
        if (mounted) {
          context.read<GameBloc>().add(ResetPlayerEvent());
        }
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/start', (_) => false);
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _cardColor,
            content: Text(
              'Failed to delete account: $e',
              style: GoogleFonts.epilogue(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  // ── Confirmation dialog ──────────────────────────────────

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmLabel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: borderGrey),
        ),
        title: Text(title, style: _label(size: 18, color: _creamText)),
        content: Text(
          message,
          style: GoogleFonts.epilogue(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              AppLocalizations.of(context).buttonCancel,
              style: _label(size: 14, color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel, style: _label(size: 14, color: redText)),
          ),
        ],
      ),
    );
  }
}
