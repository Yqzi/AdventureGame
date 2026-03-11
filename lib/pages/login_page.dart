import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Questborne/colors.dart';
import 'package:Questborne/router.dart';
import 'package:Questborne/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();

  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (_auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRouter.start);
      });
    }
  }

  // ── Actions ─────────────────────────────────────────────────

  Future<void> _handleGoogle() async {
    await _performAuth(() => _auth.signInWithGoogle());
  }

  Future<void> _handleApple() async {
    await _performAuth(() => _auth.signInWithApple());
  }

  Future<void> _performAuth(Future Function() action) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      await action();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.start);
      }
    } catch (e) {
      setState(
        () => _errorMessage = e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── UI ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(screenHeight),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 60),
                    _buildTitle(),
                    const SizedBox(height: 8),
                    _buildSubtitle(),
                    const SizedBox(height: 56),

                    // ── Sign-in buttons ──
                    _buildProviderButton(
                      label: 'Continue with Google',
                      icon: FontAwesomeIcons.google,
                      color: Colors.white,
                      textColor: Colors.black87,
                      onTap: _handleGoogle,
                    ),
                    const SizedBox(height: 14),

                    // Apple button — only shown on iOS / macOS
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

                    const SizedBox(height: 24),

                    // ── Error ──
                    if (_errorMessage != null) _buildError(),

                    // ── Loading indicator ──
                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: CircularProgressIndicator(
                          color: redText,
                          strokeWidth: 2.5,
                        ),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Background ──────────────────────────────────────────────

  Widget _buildBackground(double screenHeight) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/bg/castle.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
          height: screenHeight,
          width: double.infinity,
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.55)),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(120, 0, 0, 0),
                  Color.fromARGB(220, 0, 0, 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Title / subtitle ────────────────────────────────────────

  Widget _buildTitle() {
    return Text(
      'ENTER THE\nREALM',
      textAlign: TextAlign.center,
      style: GoogleFonts.epilogue(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        height: 0.95,
        color: Colors.white,
        letterSpacing: 2,
        shadows: const [
          Shadow(blurRadius: 20, offset: Offset(0, 4), color: Colors.black87),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Choose how you wish to proceed',
      textAlign: TextAlign.center,
      style: GoogleFonts.epilogue(
        fontSize: 14,
        color: Colors.white54,
        letterSpacing: 1,
      ),
    );
  }

  // ── Provider button ─────────────────────────────────────────

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

  // ── Error message ───────────────────────────────────────────

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.epilogue(
                color: Colors.red.shade400,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
