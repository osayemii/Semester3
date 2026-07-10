import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/staff.dart';

// Same REST-over-Realtime-Database approach as ClassChatApp-main's
// ChatService: no firebase_database plugin (it has no Windows support),
// just plain HTTP calls against https://<project>-default-rtdb.firebaseio.com.
//
// The base URL is read from the app's own FirebaseOptions.databaseURL at
// call time (not hardcoded), so this automatically follows whatever project
// is configured in firebase_options.dart — no project-specific URL baked in.
class StaffService {
  String get _baseUrl {
    final databaseURL = Firebase.app().options.databaseURL;
    if (databaseURL == null) {
      throw StateError(
        'No databaseURL configured for this Firebase project. Check '
        'firebase_options.dart / the Realtime Database exists for this project.',
      );
    }
    return '$databaseURL/bakery/staff';
  }

  Future<String?> _getToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  // ADD — POST lets Firebase generate the push key (the record's id).
  Future<void> add(Staff staff) async {
    final token = await _getToken();
    final uri = Uri.parse('$_baseUrl.json?auth=$token');
    await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(staff.toMap()),
    );
  }

  // UPDATE — PUT replaces the record at its existing push key.
  Future<void> update(Staff staff) async {
    if (staff.id == null) {
      throw ArgumentError('Cannot update a staff member without an id.');
    }
    final token = await _getToken();
    final uri = Uri.parse('$_baseUrl/${staff.id}.json?auth=$token');
    await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(staff.toMap()),
    );
  }

  // DELETE
  Future<void> delete(String id) async {
    final token = await _getToken();
    final uri = Uri.parse('$_baseUrl/$id.json?auth=$token');
    await http.delete(uri);
  }

  // GET STAFF — returns a Stream that polls Firebase every 2 seconds,
  // exactly like ChatService.getMessagesStream().
  Stream<List<Staff>> getStaffStream() async* {
    while (true) {
      try {
        final token = await _getToken();
        final uri = Uri.parse('$_baseUrl.json?auth=$token');
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);

          if (decoded != null && decoded is Map) {
            final list = decoded.entries.map((entry) {
              return Staff.fromMap(
                entry.key.toString(),
                Map<dynamic, dynamic>.from(entry.value),
              );
            }).toList();

            list.sort((a, b) => a.name.compareTo(b.name));
            yield list;
          } else {
            yield [];
          }
        }
      } catch (e) {
        // ignore: avoid_print
        print('StaffService error: $e');
        yield [];
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
