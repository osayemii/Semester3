import 'dart:async';

import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  List<ChatMessage> messages = [];

  // Holds the stream subscription so we can cancel it when the screen closes.
  // Without this, the polling loop would keep running after logout — a memory leak.
  StreamSubscription<List<ChatMessage>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribeToMessages();
  }

  void _subscribeToMessages() {
    // getMessagesStream() returns an async* generator that yields a fresh
    // List<ChatMessage> every 2 seconds via the Firebase REST API.
    _subscription = chatService.getMessagesStream().listen((incoming) {
      if (mounted) {
        setState(() => messages = incoming);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) {
      return;
    }

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    // Cancel the polling loop when the widget is removed from the tree.
    _subscription?.cancel();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = authService.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Chat'),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {
              await authService.logout();

              if (!context.mounted) {
                return;
              }

              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,

              itemBuilder: (context, index) {
                final message = messages[index];

                final myChat = message.sender == currentUser;

                return ChatBubble(
                  message: message.text,
                  sender: message.sender,
                  myChat: myChat,
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(8),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (value) async {
                      final text = controller.text.trim();
                      if (text.isEmpty) {
                        return;
                      }
                      await chatService.sendMessage(
                        sender: currentUser,
                        text: text,
                      );
                      
                      controller.clear();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),

                  onPressed: () async {
                    final text = controller.text.trim();
                    if (text.isEmpty) {
                      return;
                    }
                    await chatService.sendMessage(
                      sender: currentUser,
                      text: text,
                    );
                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
