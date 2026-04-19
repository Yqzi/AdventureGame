import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Questborne/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Questborne/colors.dart';

// ── The accent colour used throughout this screen ──
const _accent = redText;

/// A themed full-screen page that asks the player to choose a character name.
///
/// Returns the chosen name as a [String], or `null` if dismissed.
class CharacterNameDialog extends StatefulWidget {
  const CharacterNameDialog({super.key});

  /// Convenience method — shows the dialog and returns the chosen name.
  static Future<String?> show(BuildContext context) {
    return showGeneralDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const CharacterNameDialog(),
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  @override
  State<CharacterNameDialog> createState() => _CharacterNameDialogState();
}

class _CharacterNameDialogState extends State<CharacterNameDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(
        () => _error = AppLocalizations.of(context).nameDialogErrorEmpty,
      );
      return;
    }
    if (name.length < 2) {
      setState(
        () => _error = AppLocalizations.of(context).nameDialogErrorShort,
      );
      return;
    }
    if (name.length > 20) {
      setState(() => _error = AppLocalizations.of(context).nameDialogErrorLong);
      return;
    }
    if (name.toLowerCase() == 'adventurer') {
      setState(
        () => _error = AppLocalizations.of(context).nameDialogErrorReserved,
      );
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundDark,
      body: Column(
        children: [
          // ── Top bar ──
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Decorative icon
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(null),
                    child: const Icon(Icons.close, color: _accent, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context).nameDialogAppTitle,
                    style: GoogleFonts.epilogue(
                      color: _accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const Spacer(),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(null),
                    child: const Icon(Icons.close, color: _accent, size: 24),
                  ),
                ],
              ),
            ),
          ),

          // ── Scrollable content ──
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Hero silhouette area ──
                  SizedBox(
                    height: screenHeight * 0.32,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Dark figure image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/namebg.png',
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.4),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                        // Heavy gradient fade into background
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.0, 0.3, 0.7, 1.0],
                                colors: [
                                  backgroundDark,
                                  backgroundDark.withOpacity(0.3),
                                  backgroundDark.withOpacity(0.6),
                                  backgroundDark,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Horizontal line + icon emblem
                        Positioned(
                          top: 8,
                          left: 40,
                          right: 40,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: _accent.withOpacity(0.3),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: SizedBox(
                                  width: 28,
                                  height: 28,

                                  child: Icon(
                                    Icons.flare,
                                    color: _accent,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: _accent.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Title ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      AppLocalizations.of(context).nameDialogTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.epilogue(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5,
                        height: 1.1,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Subtitle ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      AppLocalizations.of(context).nameDialogSubtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.epilogue(
                        color: _accent.withOpacity(0.75),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                        letterSpacing: 0.3,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Text field with underline ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          maxLength: 20,
                          textCapitalization: TextCapitalization.words,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.epilogue(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                          cursorColor: _accent,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z\s\-']"),
                            ),
                          ],
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(
                              context,
                            ).nameDialogHint,
                            hintStyle: GoogleFonts.epilogue(
                              color: Colors.white.withOpacity(0.15),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                          onChanged: (_) {
                            if (_error != null) setState(() => _error = null);
                          },
                          onSubmitted: (_) => _submit(),
                        ),
                        // Orange underline
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: _error != null
                                ? _accent
                                : _accent.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(1),
                            boxShadow: [
                              BoxShadow(
                                color: _accent.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Error or binding text ──
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.epilogue(
                          color: _accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Bottom "AWAKEN" button ──
          Padding(
            padding: EdgeInsets.fromLTRB(24, 12, 24, bottomPad + 24),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton(
                onPressed: _submit,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _accent.withOpacity(0.6), width: 1.5),
                  backgroundColor: _accent.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context).nameDialogContinue,
                      style: GoogleFonts.epilogue(
                        color: _accent,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
