import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/blocs/app/app_bloc.dart';
import 'package:tes/blocs/app/app_event.dart';
import 'package:tes/blocs/app/app_state.dart';
import 'package:tes/colors.dart';
import 'package:tes/components/animated_coin_counter.dart';
import 'package:tes/components/loot_notification.dart';
import 'package:tes/components/narrative_skeleton.dart';
import 'package:tes/components/quest_complete_overlay.dart';
import 'package:tes/components/quest_failed_overlay.dart';
import 'package:tes/router.dart';
import 'package:tes/components/stat_bar.dart';
import 'package:tes/components/typewriter_text.dart';
import 'package:tes/models/chat_message.dart';
import 'package:tes/models/item.dart';
import 'package:tes/models/player.dart';
import 'package:tes/models/story_event.dart';
import 'package:tes/models/game_session.dart';
import 'package:tes/services/game_session_repository.dart';
import 'package:uuid/uuid.dart';

class GamePage extends StatefulWidget {
  final Map<String, dynamic> details;
  final bool resume;
  final String? questId;

  const GamePage({
    super.key,
    required this.details,
    this.resume = false,
    this.questId,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final GameSessionRepository _sessionRepo = GameSessionRepository();
  GameBloc? _gameBloc;

  /// Whether auto-scroll-to-bottom is active. Disabled when the user scrolls
  /// up, re-enabled when they scroll back near the bottom.
  bool _autoScroll = true;

  /// Throttle flag so we don't schedule multiple jumpTo calls per frame.
  bool _scrollScheduled = false;

  /// ID of the last streaming message we already did the initial scroll for.
  /// Prevents re-scrolling on every chunk — only scrolls once per new message.
  String? _lastScrolledMsgId;

  /// Currently showing loot notification effects (null = hidden).
  StoryEffects? _pendingEffects;

  /// Whether the AI has signalled quest completion (player hasn't dismissed yet).
  bool _questDone = false;

  /// Whether to show the full quest-complete overlay.
  bool _questCompleted = false;

  /// Whether the AI has signalled quest failure (player hasn't dismissed yet).
  bool _questFailedDone = false;

  /// Whether to show the full quest-failed overlay.
  bool _questFailed = false;

  /// Cumulative reward tracking across the entire quest.
  int _totalGold = 0;
  int _totalXp = 0;
  final List<String> _itemsGained = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gameBloc ??= context.read<GameBloc>();
  }

  @override
  void initState() {
    super.initState();

    // Track whether the user has scrolled away from the bottom.
    _scroll.addListener(_onScroll);

    // Start or resume the quest when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.resume && widget.questId != null) {
        // Try to load saved session
        final session = await _sessionRepo.loadSession(widget.questId!);
        if (session != null && mounted) {
          context.read<GameBloc>().add(
            ResumeQuestEvent(
              questDetails: widget.details,
              conversationHistory: session.conversationHistory,
              lastOptions: session.lastOptions,
            ),
          );
          return;
        }
      }
      // No session to resume — start fresh
      context.read<GameBloc>().add(StartNewQuestEvent(widget.details));
    });
  }

  /// Detect user scroll intention and toggle auto-scroll.
  void _onScroll() {
    if (!_scroll.hasClients) return;
    final pos = _scroll.position;
    // If user is within 80px of the bottom, re-enable auto-scroll.
    _autoScroll = pos.maxScrollExtent - pos.pixels < 80;
  }

  /// Scrolls to the bottom — only when the user hasn't scrolled away.
  /// Uses jumpTo (instant) during streaming to avoid animation pile-up,
  /// and is throttled to once per frame.
  void _scrollToBottom({bool force = false}) {
    if (!_autoScroll && !force) return;
    if (_scrollScheduled) return;
    _scrollScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollScheduled = false;
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  /// Save the current session and pop back to the guild page.
  Future<void> _saveAndPop() async {
    final bloc = context.read<GameBloc>();
    final questId = widget.questId;

    // Only save if we have a questId and actual conversation to save
    if (questId != null && bloc.chatHistory.isNotEmpty) {
      final history = bloc.chatHistory
          .map(
            (m) => {
              'sender': m.sender == MessageSender.player ? 'player' : 'ai',
              'text': m.text,
            },
          )
          .toList();

      // Preserve the last options so resume shows them without re-generating.
      final currentState = bloc.state;
      final lastOptions = currentState is GameLoaded
          ? currentState.options
          : <String>[];

      final session = GameSession(
        questId: questId,
        conversationHistory: history,
        questDetails: widget.details,
        lastOptions: lastOptions,
        savedAt: DateTime.now(),
      );
      await _sessionRepo.saveSession(session);
    }

    if (mounted) Navigator.of(context).pop();
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

  // Show quest details in a bottom sheet
  void _showQuestDetails(BuildContext context) {
    final d = widget.details;
    final npcs = d['keyNPCs'] as List<String>? ?? [];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1411),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD4A843).withAlpha(60)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                d['title'] ?? '',
                style: GoogleFonts.cinzelDecorative(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4A843),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                d['difficulty'] ?? '',
                style: GoogleFonts.crimsonPro(
                  fontSize: 13,
                  color: Colors.redAccent.withAlpha(180),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 14),

              // Description
              if ((d['description'] as String?)?.isNotEmpty == true) ...[
                Text(
                  d['description'],
                  style: GoogleFonts.crimsonPro(
                    fontSize: 15,
                    color: const Color(0xFFE3D5B8).withAlpha(200),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Objective
              _detailRow(
                FontAwesomeIcons.bullseye,
                'Objective',
                d['objective'] ?? '',
              ),
              const SizedBox(height: 10),

              // Location
              _detailRow(
                FontAwesomeIcons.locationDot,
                'Location',
                d['location'] ?? '',
              ),
              const SizedBox(height: 10),

              // Reward
              _detailRow(FontAwesomeIcons.coins, 'Reward', d['reward'] ?? ''),

              // Key NPCs
              if (npcs.isNotEmpty) ...[
                const SizedBox(height: 10),
                _detailRow(
                  FontAwesomeIcons.userGroup,
                  'Key Figures',
                  npcs.join(', '),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FaIcon(icon, size: 13, color: const Color(0xFFD4A843).withAlpha(160)),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label:  ',
                  style: GoogleFonts.cinzel(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE3D5B8),
                    letterSpacing: 0.5,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.crimsonPro(
                    fontSize: 14,
                    color: const Color(0xFFE3D5B8).withAlpha(180),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color.fromARGB(248, 22, 18, 16);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocListener<GameBloc, GameState>(
        listenWhen: (prev, curr) => curr is GameLoaded,
        listener: (context, state) {
          if (state is GameLoaded) {
            // Accumulate rewards from every response
            final fx = state.effects;
            if (fx != null) {
              _totalGold += fx.goldGained;
              _totalXp += fx.xpGained;
              if (fx.itemGainedId != null) {
                final item = allItems.cast<Item?>().firstWhere(
                  (i) => i?.id == fx.itemGainedId,
                  orElse: () => null,
                );
                _itemsGained.add(item?.name ?? fx.itemGainedId!);
              }
            }
            if (hasVisibleEffects(state.effects)) {
              setState(() {
                _pendingEffects = state.effects;
              });
            }
            if (state.effects?.questCompleted == true) {
              setState(() {
                _questDone = true;
              });
            }
            if (state.effects?.questFailed == true) {
              setState(() {
                _questFailedDone = true;
              });
            }
          }
        },
        child: Stack(
          children: [
            Scaffold(
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
                            if (!_questDone)
                              GestureDetector(
                                onTap: () => _saveAndPop(),
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
                            // Title (tap to show quest details)
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _showQuestDetails(context),
                                child: Text(
                                  widget.details['title'],
                                  style: GoogleFonts.epilogue(
                                    color: const Color(0xFFE3D5B8),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    letterSpacing: 1.5,
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(
                                      0xFFE3D5B8,
                                    ).withAlpha(80),
                                    decorationStyle: TextDecorationStyle.dotted,
                                  ),
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
                                      AnimatedCoinCounter(
                                        targetValue: player?.gold ?? 0,
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
                            return prevP?.currentHealth !=
                                    currP?.currentHealth ||
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
                                              margin: const EdgeInsets.only(
                                                right: 6,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.05,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.12),
                                                ),
                                              ),
                                              child: Text(
                                                '${e.icon} ${e.label}',
                                                style: GoogleFonts.epilogue(
                                                  color: const Color(
                                                    0xFFE3D5B8,
                                                  ),
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
                                if (state is GameStreamingNarrative) {
                                  // Scroll once when a new AI message starts.
                                  final msgs = state.messages;
                                  final lastAi = msgs.lastWhere(
                                    (m) => m.sender == MessageSender.ai,
                                    orElse: () => msgs.last,
                                  );
                                  if (_lastScrolledMsgId != lastAi.id) {
                                    _lastScrolledMsgId = lastAi.id;
                                    _autoScroll = true;
                                    _scrollToBottom(force: true);
                                  }
                                } else if (state is GameLoaded) {
                                  // Final scroll when response finishes.
                                  _lastScrolledMsgId = null;
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
                                    (state is GameLoading ||
                                        state is GameInitial)) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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

                                // Only show AI narrative messages
                                final aiMessages = messages
                                    .where((m) => m.sender == MessageSender.ai)
                                    .toList();

                                if (aiMessages.isEmpty) {
                                  return const SizedBox.shrink();
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
                                    itemCount: aiMessages.length * 2 - 1,
                                    itemBuilder: (context, index) {
                                      // Even indices = messages, odd = separators
                                      if (index.isOdd) {
                                        return _buildEventDivider();
                                      }
                                      final msg = aiMessages[index ~/ 2];
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
                              // ── Quest done → show «Quest Complete» button ──
                              if (_questDone && !_questCompleted) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    4,
                                    12,
                                    4,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFD4883A,
                                        ),
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _questCompleted = true;
                                        });
                                      },
                                      child: const Text(
                                        '⚔  QUEST COMPLETE  ⚔',
                                        style: TextStyle(
                                          fontFamily: 'Georgia',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // ── Quest failed → show «Quest Failed» button ──
                              if (_questFailedDone && !_questFailed) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    4,
                                    12,
                                    4,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: redText,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _questFailed = true;
                                        });
                                      },
                                      child: const Text(
                                        '☠  QUEST FAILED  ☠',
                                        style: TextStyle(
                                          fontFamily: 'Georgia',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final options = state is GameLoaded
                                  ? state.options
                                  : <String>[];
                              final isActive =
                                  state is GameLoaded && options.length >= 2;

                              if (!isActive) return const SizedBox.shrink();

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  4,
                                  12,
                                  4,
                                ),
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
                          if (!_questDone && !_questFailedDone)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                              child: GeminiTextField(
                                controller: _controller,
                                onSend: _sendCommand,
                                isEnabled:
                                    !(context.watch<GameBloc>().state
                                            is GameLoading ||
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

            // ── Loot notification overlay ──
            if (_pendingEffects != null)
              LootNotification(
                key: UniqueKey(),
                effects: _pendingEffects!,
                onComplete: () {
                  if (mounted) {
                    setState(() {
                      _pendingEffects = null;
                    });
                  }
                },
              ),

            // ── Quest complete overlay ──
            if (_questCompleted)
              QuestCompleteOverlay(
                questTitle: widget.details['title'] ?? 'Quest',
                totalGold: _totalGold,
                totalXp: _totalXp,
                itemsGained: List.unmodifiable(_itemsGained),
                onReturnToGuild: () {
                  // Delete saved session — quest is done
                  if (widget.questId != null) {
                    _sessionRepo.deleteSession(widget.questId!);
                  }
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRouter.guild, (route) => false);
                },
              ),

            // ── Quest failed overlay ──
            if (_questFailed)
              QuestFailedOverlay(
                questTitle: widget.details['title'] ?? 'Quest',
                onReturnToGuild: () {
                  // Delete saved session — quest failed
                  if (widget.questId != null) {
                    _sessionRepo.deleteSession(widget.questId!);
                  }
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRouter.guild, (route) => false);
                },
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

  // ── Narrative block with drop cap + typewriter effect ──
  Widget _buildNarrativeBlock(ChatMessage msg) {
    final text = msg.text;
    final isAi = msg.sender == MessageSender.ai;

    // Player messages: render immediately, no animation.
    if (!isAi) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          text,
          style: GoogleFonts.crimsonText(
            color: const Color(0xFFE3D5B8),
            fontSize: 16,
            height: 1.7,
            letterSpacing: 0.3,
          ),
        ),
      );
    }

    // AI messages: typewriter reveal with skeleton placeholder.
    // Use MediaQuery for height since this widget lives inside a ListView
    // (unbounded height) where LayoutBuilder can't provide useful constraints.
    final viewportHeight = MediaQuery.of(context).size.height * 0.6;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TypewriterText(
            key: ValueKey(msg.id),
            text: text,
            isComplete: msg.isComplete,
            charDelayMs: 18,
            // No onReveal — we don't scroll per character.
            builder: (context, visibleText) {
              if (visibleText.length > 1) {
                return RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: visibleText[0],
                        style: GoogleFonts.cinzelDecorative(
                          color: const Color(0xFFD4883A),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                      TextSpan(
                        text: visibleText.substring(1),
                        style: GoogleFonts.crimsonText(
                          color: const Color(0xFFE3D5B8),
                          fontSize: 18,
                          height: 1.7,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (visibleText.isNotEmpty) {
                return RichText(
                  text: TextSpan(
                    text: visibleText[0],
                    style: GoogleFonts.cinzelDecorative(
                      color: const Color(0xFFD4883A),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Skeleton shimmer lines below the revealed text while
          // the message is still streaming.
          if (!msg.isComplete)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: NarrativeSkeleton(
                height: (viewportHeight * 0.55).clamp(80, 400),
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
    _scroll.removeListener(_onScroll);
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
