import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Questborne/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Questborne/blocs/app/app_bloc.dart';
import 'package:Questborne/blocs/app/app_event.dart';
import 'package:Questborne/components/buttons.dart';
import 'package:Questborne/components/character_name_dialog.dart';
import 'package:Questborne/router.dart';
import 'package:Questborne/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/colors.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _auth = AuthService();

  bool _loading = false;
  bool _sessionReady = false;
  String? _errorMessage;

  bool get _isSignedIn => _auth.isLoggedIn;

  @override
  void initState() {
    super.initState();
    _validateSession();
  }

  /// Try refreshing the session — if the user was deleted on Supabase,
  /// the refresh will fail and we sign out locally to clear the stale token.
  Future<void> _validateSession() async {
    if (!_isSignedIn) return;
    try {
      // Only refresh if the token looks expired
      final session = Supabase.instance.client.auth.currentSession;
      final expiresAt = session?.expiresAt;
      final needsRefresh =
          expiresAt == null ||
          DateTime.fromMillisecondsSinceEpoch(
            expiresAt * 1000,
          ).isBefore(DateTime.now().add(const Duration(seconds: 60)));
      if (needsRefresh) {
        await Supabase.instance.client.auth.refreshSession();
      }
      // Session is valid — load saved player data from the cloud.
      if (mounted) {
        context.read<GameBloc>().add(LoadPlayerFromCloudEvent());
        await context.read<GameBloc>().stream.first;
      }
    } catch (_) {
      // Refresh failed — user will need to sign in again.
      await Supabase.instance.client.auth.signOut();
    }
    if (mounted) setState(() => _sessionReady = true);
  }

  // ── Auth actions ────────────────────────────────────────────

  Future<void> _handleGoogle() async {
    return _performAuth(() => _auth.signInWithGoogle());
  }

  Future<void> _handleApple() async {
    // TODO: add linkWithApple when Apple Sign-In linking is needed
    return _performAuth(() => _auth.signInWithApple());
  }

  Future<void> _performAuth(Future Function() action) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await action();
      // After successful sign-in, load saved player data from the cloud.
      if (mounted) {
        context.read<GameBloc>().add(LoadPlayerFromCloudEvent());
        await context.read<GameBloc>().stream.first;
      }
      if (mounted) setState(() => _sessionReady = true);
    } catch (e) {
      setState(
        () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background
        Stack(
          children: [
            Image.asset(
              'assets/images/bg/castle.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              height: screenHeight,
            ),
            Positioned.fill(
              child: Container(color: Colors.red.withOpacity(0.08)),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(90, 25, 25, 25),
                      Color.fromARGB(100, 10, 10, 10),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(255, 31, 31, 31).withOpacity(0),
                      const Color.fromARGB(255, 24, 24, 24).withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // Content
        Padding(
          padding: const EdgeInsets.only(
            top: 24,
            bottom: 52,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(
                "QUESTBORNE",
                textAlign: TextAlign.center,
                style: GoogleFonts.epilogue(
                  fontSize: 46,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  height: 0.95,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  shadows: const [
                    Shadow(
                      blurRadius: 15,
                      offset: Offset(0, 5),
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
              SizedBox(),

              // ── Show sign-in or game buttons ──
              _isSignedIn ? _buildGameButtons() : _buildSignInButtons(),
            ],
          ),
        ),
      ],
    );
  }

  // ── Game buttons (shown when signed in) ─────────────────────

  Widget _buildGameButtons() {
    return Column(
      spacing: 12,
      children: [
        SizedBox(
          width: double.infinity,
          child: customOutlinedButton(
            title: AppLocalizations.of(context).startEnter,
            color: redText,
            glow: true,
            letterSpacing: 1,
            fontsize: 22,
            icon: Icon(Icons.style, color: Colors.white),
            onpressed: _sessionReady ? () => _enterGame() : null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Expanded(
              child: customOutlinedButton(
                title: AppLocalizations.of(context).startPremium,
                icon: Icon(Icons.diamond_outlined, color: Colors.white),
                glow: true,
                letterSpacing: 1,
                fontsize: 16,
                onpressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRouter.subscription,
                  );
                },
              ),
            ),
            Expanded(
              child: customOutlinedButton(
                title: AppLocalizations.of(context).startSettings,
                icon: Icon(Icons.settings, color: Colors.white),
                glow: true,
                letterSpacing: 1,
                fontsize: 16,
                onpressed: () {
                  Navigator.pushNamed(context, AppRouter.settingsPage);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Text(
          AppLocalizations.of(context).startVersion,
          style: GoogleFonts.epilogue(
            color: Colors.white60,
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  /// Check if the player still has the default name and needs naming.
  bool get _needsCharacterName {
    final bloc = context.read<GameBloc>();
    return bloc.player.name == 'Adventurer';
  }

  /// Show the naming dialog, then navigate into the game.
  Future<void> _enterGame() async {
    if (_needsCharacterName) {
      final name = await CharacterNameDialog.show(context);
      if (name == null || !mounted) return;
      context.read<GameBloc>().add(SetPlayerNameEvent(name));
    }
    if (!mounted) return;
    // Check if character creation is needed.
    final bloc = context.read<GameBloc>();
    if (bloc.player.needsCharacterCreation) {
      Navigator.pushReplacementNamed(context, AppRouter.characterCreation);
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.guild);
    }
  }

  // ── Sign-in buttons (shown when not signed in) ──────────────

  Widget _buildSignInButtons() {
    return Column(
      children: [
        _buildProviderButton(
          label: 'Google',
          color: Colors.white,
          textColor: Colors.black87,
          onTap: _handleGoogle,
        ),
        const SizedBox(height: 14),
        if (_auth.isAppleSignInAvailable) ...[
          _buildProviderButton(
            label: 'Apple',
            color: Colors.white,
            textColor: Colors.black87,
            onTap: _handleApple,
          ),
          const SizedBox(height: 14),
        ],
        const SizedBox(height: 16),
        if (_errorMessage != null) ...[
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _errorMessage!,
                  style: GoogleFonts.epilogue(
                    color: Colors.red.shade400,
                    fontSize: 13,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        if (_loading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: CircularProgressIndicator(color: redText, strokeWidth: 2.5),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProviderButton2({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _loading ? null : onTap,
        icon: FaIcon(
          icon,
          size: 18,
          color: _loading ? textColor.withOpacity(0.4) : textColor,
        ),
        label: Text(
          label,
          style: GoogleFonts.epilogue(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _loading ? textColor.withOpacity(0.4) : textColor,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withOpacity(0.3),
          elevation: color == Colors.transparent ? 0 : 4,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: borderColor != null
                ? BorderSide(color: borderColor)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildProviderButton({
    required String label,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return Center(
      child: ElevatedButton(
        onPressed: _loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.only(right: 24, left: 16, top: 10, bottom: 10),
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/${label.toLowerCase()}.png', height: 32),
            SizedBox(width: 8),
            Text(
              "Continue with $label",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
