import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/blocs/app/app_bloc.dart';
import 'package:tes/blocs/app/app_event.dart';
import 'package:tes/blocs/app/app_state.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/stat_bar.dart';
import 'package:tes/models/chat_message.dart';
import 'package:tes/models/player.dart';
import 'package:uuid/uuid.dart';

class GamePage extends StatefulWidget {
  final Map<String, dynamic> details;

  const GamePage({super.key, required this.details});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  GameBloc? _gameBloc;
  // final List equipment = const []; // Assuming this is for other game logic, keep if needed

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameBloc ??= context.read<GameBloc>();
  }

  @override
  void initState() {
    super.initState();
    // Start the quest immediately when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameBloc>().add(StartNewQuestEvent(widget.details));
    });
  }

  // Function to scroll to the bottom of the chat list
  void _scrollToBottom() {
    // Using addPostFrameCallback to ensure layout is updated before scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Function to send a player command
  void _sendCommand() {
    final command = _controller.text.trim();
    if (command.isNotEmpty) {
      final currentState = context.read<GameBloc>().state;
      // Only allow sending command if the AI is not currently processing or streaming
      if (currentState is! GameLoading &&
          currentState is! GameStreamingNarrative) {
        context.read<GameBloc>().add(PlayerCommandEvent(command));
        _controller.clear(); // Clear input field after sending
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color.fromARGB(248, 22, 18, 16);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            // ═══════════════ TOP PANEL ═══════════════
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 12,
                right: 12,
                bottom: 10,
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 28, 20, 17),
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(60, 255, 180, 100),
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Row 1: Back · Title · Gold
                  Row(
                    children: [
                      // Back
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFFE3D5B8),
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title
                      Expanded(
                        child: Text(
                          widget.details['title'],
                          style: GoogleFonts.epilogue(
                            color: const Color(0xFFE3D5B8),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      // Gold
                      BlocBuilder<GameBloc, GameState>(
                        buildWhen: (prev, curr) {
                          final prevP = _playerFromState(prev);
                          final currP = _playerFromState(curr);
                          return prevP?.gold != currP?.gold;
                        },
                        builder: (context, state) {
                          final player = _playerFromState(state);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.coins,
                                  color: Colors.amber,
                                  size: 13,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${player?.gold ?? 0}',
                                  style: GoogleFonts.epilogue(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Row 2: HP + MP bars
                  BlocBuilder<GameBloc, GameState>(
                    buildWhen: (prev, curr) {
                      final prevP = _playerFromState(prev);
                      final currP = _playerFromState(curr);
                      return prevP?.currentHealth != currP?.currentHealth ||
                          prevP?.currentMana != currP?.currentMana;
                    },
                    builder: (context, state) {
                      final player = _playerFromState(state);
                      if (player == null) return const SizedBox.shrink();

                      return Column(
                        children: [
                          _buildStatRow(
                            'HP',
                            player.currentHealth,
                            player.maxHealth,
                            player.healthConsumed,
                            const Color(0xFFCC3333),
                          ),
                          const SizedBox(height: 4),
                          _buildStatRow(
                            'MP',
                            player.currentMana,
                            player.maxMana,
                            player.manaConsumed,
                            const Color(0xFF3377CC),
                          ),
                          // Status effects
                          if (player.statusEffects.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: player.statusEffects
                                    .map(
                                      (e) => Container(
                                        margin: const EdgeInsets.only(right: 6),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '${e.icon} ${e.label}',
                                          style: GoogleFonts.epilogue(
                                            color: const Color(0xFFE3D5B8),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // ═══════════════ NARRATIVE AREA ═══════════════
            Expanded(
              child: Container(
                color: bgColor,
                child: Column(
                  children: [
                    Expanded(
                      child: BlocConsumer<GameBloc, GameState>(
                        listener: (context, state) {
                          if (state is GameLoaded ||
                              state is GameStreamingNarrative) {
                            _scrollToBottom();
                          }
                        },
                        builder: (context, state) {
                          List<ChatMessage> messages = [];
                          String loadingMessage = 'Loading...';

                          if (state is GameLoading) {
                            loadingMessage = state.message;
                          } else if (state is GameLoaded) {
                            messages = state.messages;
                          } else if (state is GameStreamingNarrative) {
                            messages = state.messages;
                          } else if (state is GameError) {
                            messages.add(
                              ChatMessage(
                                id: const Uuid().v4(),
                                sender: MessageSender.ai,
                                text: 'Error: ${state.message}',
                                timestamp: DateTime.now(),
                                isComplete: true,
                              ),
                            );
                          }

                          if (messages.isEmpty &&
                              (state is GameLoading || state is GameInitial)) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: const Color(
                                        0xFFE3D5B8,
                                      ).withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    loadingMessage,
                                    style: GoogleFonts.epilogue(
                                      color: const Color(
                                        0xFFE3D5B8,
                                      ).withOpacity(0.6),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (messages.isEmpty) {
                            return Center(
                              child: Text(
                                'No narrative yet. Type your action!',
                                style: GoogleFonts.epilogue(
                                  color: Colors.white24,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }

                          // ── Build narrative list with separators ──
                          return ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: const [
                                  Colors.transparent,
                                  Colors.white,
                                  Colors.white,
                                ],
                                stops: const [0.0, 0.08, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: ListView.builder(
                              controller: _scroll,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 32,
                              ),
                              itemCount: messages.length * 2 - 1,
                              itemBuilder: (context, index) {
                                // Even indices = messages, odd = separators
                                if (index.isOdd) {
                                  return _buildEventDivider();
                                }
                                final msg = messages[index ~/ 2];
                                return _buildNarrativeBlock(msg);
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    // ── Choice options ──
                    BlocBuilder<GameBloc, GameState>(
                      buildWhen: (prev, curr) {
                        final prevOpts = prev is GameLoaded
                            ? prev.options
                            : <String>[];
                        final currOpts = curr is GameLoaded
                            ? curr.options
                            : <String>[];
                        return prevOpts != currOpts ||
                            curr is GameStreamingNarrative ||
                            curr is GameLoading;
                      },
                      builder: (context, state) {
                        final options = state is GameLoaded
                            ? state.options
                            : <String>[];
                        final isActive =
                            state is GameLoaded && options.length >= 2;

                        if (!isActive) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildOptionButton(
                                  options[0],
                                  const Color(0xFFD4883A),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildOptionButton(
                                  options[1],
                                  const Color(0xFF7B9EA8),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // ── Text input ──
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                      child: GeminiTextField(
                        controller: _controller,
                        onSend: _sendCommand,
                        isEnabled:
                            !(context.watch<GameBloc>().state is GameLoading ||
                                context.watch<GameBloc>().state
                                    is GameStreamingNarrative),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Clickable option button ──
  Widget _buildOptionButton(String text, Color accent) {
    return GestureDetector(
      onTap: () {
        final currentState = context.read<GameBloc>().state;
        if (currentState is! GameLoading &&
            currentState is! GameStreamingNarrative) {
          context.read<GameBloc>().add(PlayerCommandEvent(text));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: accent.withOpacity(0.3)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.epilogue(
            color: accent,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // ── Compact stat row for HP / MP ──
  Widget _buildStatRow(
    String label,
    int current,
    int max,
    double consumed,
    Color color,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 26,
          child: Text(
            label,
            style: GoogleFonts.epilogue(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: StatBar(consumed: consumed, color: color, height: 5),
        ),
        const SizedBox(width: 6),
        Text(
          '$current/$max',
          style: GoogleFonts.epilogue(
            color: color.withOpacity(0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // ── "── new event ──" separator ──
  Widget _buildEventDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFE3D5B8).withOpacity(0.25),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'new event',
              style: GoogleFonts.epilogue(
                color: const Color(0xFFE3D5B8).withOpacity(0.25),
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFE3D5B8).withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Narrative block with drop cap ──
  Widget _buildNarrativeBlock(ChatMessage msg) {
    final text = msg.text;
    final hasDropCap = text.isNotEmpty && msg.sender == MessageSender.ai;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasDropCap && text.length > 1)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: text[0],
                    style: GoogleFonts.cinzelDecorative(
                      color: const Color(0xFFD4883A),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  TextSpan(
                    text: text.substring(1),
                    style: GoogleFonts.crimsonText(
                      color: const Color(0xFFE3D5B8),
                      fontSize: 18,
                      height: 1.7,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              text,
              style: GoogleFonts.crimsonText(
                color: const Color(0xFFE3D5B8),
                fontSize: 16,
                height: 1.7,
                letterSpacing: 0.3,
              ),
            ),
          // Streaming indicator
          if (!msg.isComplete)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: SizedBox(
                width: 20,
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFFD4883A).withOpacity(0.6),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Helper to extract Player from any GameState.
  Player? _playerFromState(GameState state) {
    if (state is GameLoaded) return state.player;
    if (state is GameStreamingNarrative) return state.player;
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    // Dispatch the dispose event for your Bloc
    _gameBloc?.add(GameDisposeEvent());
    super.dispose();
  }
}

// --- Your GeminiTextField needs a minor modification ---
class GeminiTextField extends StatelessWidget {
  const GeminiTextField({
    super.key,
    required TextEditingController controller,
    this.onSend, // Added onSend callback
    this.isEnabled = true, // Added isEnabled property
  }) : _controller = controller;

  final TextEditingController _controller;
  final VoidCallback?
  onSend; // Callback when send button is pressed or submitted
  final bool isEnabled; // New property to enable/disable input

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      // Prevents interaction when not enabled
      absorbing: !isEnabled,
      child: TextField(
        controller: _controller,
        style: GoogleFonts.epilogue(
          color: isEnabled ? Colors.white : Colors.grey,
        ), // Grey out text if disabled

        onSubmitted: (value) {
          if (isEnabled && value.trim().isNotEmpty) {
            // Only call onSend if enabled
            onSend?.call();
          }
        },

        decoration: InputDecoration(
          hintText: 'Type your action...',
          hintStyle: GoogleFonts.epilogue(
            color: isEnabled ? Colors.white54 : Colors.grey.shade600,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          filled: true,
          fillColor: isEnabled
              ? Colors.black45
              : Colors.black87, // Change fill color if disabled
          suffixIcon: IconButton(
            // Add a send icon
            icon: Icon(
              Icons.send,
              color: isEnabled ? Colors.white : Colors.grey,
            ),
            onPressed: isEnabled ? onSend : null, // Only clickable if enabled
          ),
        ),
        cursorColor: redText,
      ),
    );
  }
}
