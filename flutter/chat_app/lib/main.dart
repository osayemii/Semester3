import 'package:chat_app/models/chat_message.dart';

import '/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat App",
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> messages = [];

  late Future<void> chatFuture;
  late Stream<String> messageStreams;

  @override
  void initState() {
    super.initState();

    chatFuture = loadMessages();
    messageStreams = receiveMessages();
  }

  Future<void> loadMessages() async {
    await Future.delayed(const Duration(seconds: 2));

    messages.addAll([
      ChatMessage(text: 'Message 1', myChat: false),
      ChatMessage(text: 'Message 2', myChat: true),
      ChatMessage(text: 'Welcome back!', myChat: false),
    ]);
  }

  Stream<String> receiveMessages() async* {
    List<String> replies = [
      'Hi 👋',
      'How are you?',
      'Did you try to reach me?',
      'Please call back or drop a message',
    ];

    for (var reply in replies) {
      await Future.delayed(const Duration(seconds: 3));

      yield reply;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat App')),

      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: chatFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return ListView.builder(
                  itemCount: messages.length,

                  itemBuilder: (context, index) {
                    return ChatBubble(
                      message: messages[index].text,
                      myChat: messages[index].myChat,
                    );
                  },
                );
              },
            ),
          ),

          StreamBuilder<String>(
            stream: messageStreams,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final alreadyExists = messages.any(
                    (message) => message.text == snapshot.data,
                  );

                  if (!alreadyExists) {
                    setState(() {
                      messages.add(
                        ChatMessage(text: snapshot.data!, myChat: false),
                      );
                    });
                  }
                });
              }
              return const SizedBox.shrink();
            },
          ),

          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = controller.text.trim();

                    if (text.isEmpty) {
                      return;
                    }

                    setState(() {
                      messages.add(ChatMessage(text: text, myChat: true));
                    });

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
