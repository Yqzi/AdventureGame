import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
      await Supabase.instance.client.auth.refreshSession();
      // Session is valid — load saved player data from the cloud.
      if (mounted) {
        context.read<GameBloc>().add(LoadPlayerFromCloudEvent());
      }
    } catch (_) {
      if (mounted) setState(() {});
    }
  }

  // ── Auth actions ────────────────────────────────────────────

  Future<void> _handleGoogle() async {
    // If already signed in as guest, link + migrate data to Google account
    if (_auth.isGuest) {
      return _performAuth(() => _auth.linkWithGoogle());
    }
    return _performAuth(() => _auth.signInWithGoogle());
  }

  Future<void> _handleApple() async {
    // TODO: add linkWithApple when Apple Sign-In linking is needed
    return _performAuth(() => _auth.signInWithApple());
  }

  Future<void> _handleGuest() async =>
      _performAuth(() => _auth.signInAsGuest());

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
      }
      if (mounted) setState(() {}); // Refresh to show signed-in UI
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
              Container(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 50,
                  child: MaterialButton(
                    splashColor: Colors.transparent,
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderGrey),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleQuestion,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
            title: 'ENTER',
            color: redText,
            glow: true,
            letterSpacing: 1,
            fontsize: 22,
            icon: Icon(Icons.style, color: Colors.white),
            onpressed: () => _enterGame(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Expanded(
              child: customOutlinedButton(
                title: 'ARCHIVES',
                glow: true,
                letterSpacing: 1,
                fontsize: 16,
                onpressed: () {
                  Navigator.pushReplacementNamed(context, AppRouter.shop);
                },
              ),
            ),
            Expanded(
              child: customOutlinedButton(
                title: 'SETTINGS',
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
        Container(
          decoration: BoxDecoration(
            color: redText.withOpacity(0.2),
            border: Border.all(color: Color(0xFFFF6B00), width: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 9, color: redText),
              SizedBox(width: 6),
              Text(
                'STORY ENGINE ACTIVE',
                style: GoogleFonts.epilogue(
                  fontSize: 11,
                  color: const Color.fromARGB(255, 245, 18, 56),
                  decoration: TextDecoration.none,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        Text(
          "Version 0.0.1 • Shadow-Crest Protocol",
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
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.guild);
    }
  }

  // ── Sign-in buttons (shown when not signed in) ──────────────

  Widget _buildSignInButtons() {
    return Column(
      children: [
        _buildProviderButton(
          label: 'Continue with Google',
          icon: FontAwesomeIcons.google,
          color: Colors.white,
          textColor: Colors.black87,
          onTap: _handleGoogle,
        ),
        const SizedBox(height: 14),
        if (_auth.isAppleSignInAvailable) ...[
          _buildProviderButton(
            label: 'Continue with Apple',
            icon: FontAwesomeIcons.apple,
            color: Colors.white,
            textColor: Colors.black87,
            onTap: _handleApple,
          ),
          const SizedBox(height: 14),
        ],
        Row(
          children: [
            Expanded(
              child: Divider(
                color: borderGrey.withOpacity(0.5),
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: GoogleFonts.epilogue(
                  color: Colors.white30,
                  fontSize: 12,
                  letterSpacing: 2,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: borderGrey.withOpacity(0.5),
                thickness: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildProviderButton(
          label: 'Continue as Guest',
          icon: FontAwesomeIcons.userSecret,
          color: Colors.transparent,
          textColor: Colors.white70,
          borderColor: borderGrey,
          onTap: _handleGuest,
        ),
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
        Text(
          'Guest progress is saved locally.\nSign in to sync across devices.',
          textAlign: TextAlign.center,
          style: GoogleFonts.epilogue(
            color: Colors.white24,
            fontSize: 11,
            letterSpacing: 0.5,
            height: 1.5,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget _buildProviderButton({
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
}
