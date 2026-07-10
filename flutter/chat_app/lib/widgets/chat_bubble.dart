import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool myChat;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.myChat
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Align(
      alignment: myChat
            ? Alignment.centerRight
            : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: myChat
              ? Colors.blue
              : Colors.grey.shade300,

          borderRadius: 
              BorderRadius.circular(15)
        ),

        child: Text(
          message,
          style: TextStyle(
            color: myChat ? Colors.white : Colors.black
          ),
        ),
      ),
    );
  }
}