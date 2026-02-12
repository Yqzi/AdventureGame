import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tes/blocs/app/app_bloc.dart';
import 'package:tes/blocs/app/app_event.dart';
import 'package:tes/blocs/app/app_state.dart';
// import 'package:tes/blocs/app/app_bloc.dart'; // Assuming these are not needed for AI chat logic
// import 'package:tes/blocs/app/app_event.dart';
// import 'package:tes/blocs/app/app_state.dart';
import 'package:tes/colors.dart'; // Make sure this provides borderGrey and redText
import 'package:tes/models/chat_message.dart';
// import 'package:tes/components/buttons.dart'; // Assuming not needed for AI chat logic
// import 'package:tes/components/stat_bar.dart';
// import 'package:tes/components/top_bar.dart';
// import 'package:http/http.dart' as http; // Not needed with Firebase AI SDK
// import 'package:tes/keys/secrets.dart'; // Not needed with Firebase AI SDK for client-side Gemini
import 'package:uuid/uuid.dart'; // For error message IDs if needed

// Your GameBloc and Message Model

class GamePage extends StatefulWidget {
  final Map<String, dynamic> details;

  const GamePage({super.key, required this.details});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  // final List equipment = const []; // Assuming this is for other game logic, keep if needed

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
    // These variables are for your custom UI elements, not directly for the chat integration
    double screenHeight = MediaQuery.of(context).size.height;
    double consumedHealth = 0.0;
    double consumedMana = 0.0;
    int health = 100;
    int mana = 100;
    bool isInCombat = false;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
      },
      child: Scaffold(
        body: Column(
          children: [
            // --- Custom Top Row (Back button, Title, Heart icon) ---
            Padding(
              padding: const EdgeInsets.only(
                top: 32,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Text(
                    'Adventure',
                    style: GoogleFonts.epilogue(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      // Changed to const if content is static
                      children: [
                        Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '5', // Example number, replace with variable if needed
                          style: TextStyle(
                            // Changed to TextStyle if GoogleFonts not required here
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // --- Image placeholder ---
            // If you want an image to appear here, you'd handle it with BlocBuilder
            // For now, it's just a space.
            Container(height: screenHeight / 6),

            // --- Main Chat/Game Area ---
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: const Color.fromARGB(
                  248,
                  22,
                  18,
                  16,
                ), // Your custom background color
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // --- Gemini chat integration (narrative display) ---
                    Expanded(
                      child: BlocConsumer<GameBloc, GameState>(
                        // Use BlocConsumer for listener
                        listener: (context, state) {
                          // Scroll to bottom whenever messages are updated
                          if (state is GameLoaded ||
                              state is GameStreamingNarrative) {
                            _scrollToBottom();
                          }
                        },
                        builder: (context, state) {
                          List<ChatMessage> messages = [];
                          String loadingMessage =
                              "Loading..."; // Default for initial loading

                          if (state is GameLoading) {
                            loadingMessage = state.message;
                          } else if (state is GameLoaded) {
                            messages = state.messages;
                          } else if (state is GameStreamingNarrative) {
                            messages = state.messages;
                          } else if (state is GameError) {
                            // Add the error message to display in the list
                            messages.add(
                              ChatMessage(
                                id: const Uuid()
                                    .v4(), // Unique ID for this temporary error message
                                sender: MessageSender
                                    .ai, // Treat error as an AI message
                                text: "Error: ${state.message}",
                                timestamp: DateTime.now(),
                                isComplete: true,
                              ),
                            );
                          }

                          // Display a central loading indicator if no messages yet
                          if (messages.isEmpty &&
                              (state is GameLoading || state is GameInitial)) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    loadingMessage,
                                    style: GoogleFonts.epilogue(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (messages.isEmpty &&
                              state is! GameLoading &&
                              state is! GameInitial) {
                            // Fallback if somehow no messages but not initial/loading
                            return Center(
                              child: Text(
                                'No narrative yet. Type your action!',
                                style: GoogleFonts.epilogue(
                                  color: Colors.white54,
                                ),
                              ),
                            );
                          } else {
                            // Display the list of AI messages
                            return ListView.builder(
                              controller: _scroll,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final msg = messages[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Align(
                                    alignment: Alignment
                                        .centerLeft, // Always align AI messages left
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                            0.9,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .black54, // AI message bubble color
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: borderGrey),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            msg.text,
                                            style: GoogleFonts.epilogue(
                                              color: Colors.white,
                                              fontSize: 15,
                                              height: 1.4,
                                            ),
                                          ),
                                          // Show streaming indicator if the AI message is not yet complete
                                          if (!msg.isComplete)
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                top: 4.0,
                                              ),
                                              child: SizedBox(
                                                width:
                                                    20, // Small width for subtle indicator
                                                height: 2,
                                                child: LinearProgressIndicator(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white70),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                    // --- Input Field ---
                    GeminiTextField(
                      controller: _controller,
                      onSend: _sendCommand, // Connect the onSend callback
                      isEnabled:
                          !(BlocProvider.of<GameBloc>(context).state
                                  is GameLoading ||
                              BlocProvider.of<GameBloc>(context).state
                                  is GameStreamingNarrative), // Disable input while AI is working
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

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    // Dispatch the dispose event for your Bloc
    context.read<GameBloc>().add(GameDisposeEvent());
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
