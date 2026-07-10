import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {

  final String message;
  final String sender;
  final bool myChat;

  const ChatBubble({
    super.key,
    required this.message,
    required this.sender,
    required this.myChat,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      alignment:
          myChat
              ? Alignment.centerRight
              : Alignment.centerLeft,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      child: Column(
        crossAxisAlignment:
            myChat
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,

        children: [

          //Sender name
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          //Message box
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: myChat
                  ? Colors.blue
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),

            child: Text(
              message,
              style: TextStyle(
                color: myChat
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}