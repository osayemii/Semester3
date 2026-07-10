import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_message.dart';

// Firebase Realtime Database exposes every node as a plain HTTP endpoint.
// Format: https://<project>-default-rtdb.firebaseio.com/<path>.json
//
// This replaces the firebase_database plugin (which has no Windows
// implementation) with direct HTTP calls — pure Dart, works on every platform.

class ChatService {
  static const String _baseUrl =
      'https://classchatproject-default-rtdb.firebaseio.com/messages';

  // Gets a short-lived ID token from firebase_auth so the REST request
  // is authenticated (matches Firebase security rules that require login).
  Future<String?> _getToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  // SEND MESSAGE
  // POST to /messages.json — Firebase auto-generates a unique push key,
  // exactly like DatabaseReference.push().set() did before.
  Future<void> sendMessage({
    required String sender,
    required String text,
  }) async {
    final token = await _getToken();
    final uri = Uri.parse('$_baseUrl.json?auth=$token');

    await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'sender': sender,
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }),
    );
  }

  // GET MESSAGES — returns a Stream that polls Firebase every 2 seconds.
  //
  // Why polling instead of a real-time socket?
  // Firebase REST does support Server-Sent Events (SSE), but parsing the
  // event stream manually adds complexity. Polling every 2 s is simpler,
  // good enough for a class chat, and fully cross-platform.
  Stream<List<ChatMessage>> getMessagesStream() async* {
    while (true) {
      try {
        final token = await _getToken();
        final uri = Uri.parse('$_baseUrl.json?auth=$token');
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);

          if (decoded != null && decoded is Map) {
            // Firebase returns: { pushKey: { sender, text, timestamp }, ... }
            final messages = decoded.entries.map((entry) {
              return ChatMessage.fromMap(
                Map<dynamic, dynamic>.from(entry.value),
              );
            }).toList();

            // Sort oldest → newest so chat reads top to bottom
            messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
            yield messages;
          } else {
            yield []; // No messages yet
          }
        }
      } catch (e) {
        print('ChatService error: $e');
        yield [];
      }

      // Wait 2 seconds before next poll
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
