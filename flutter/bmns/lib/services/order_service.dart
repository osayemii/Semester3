import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/order.dart';

// Customer orders. Same REST-over-Realtime-Database approach as
// ClassChatApp-main's ChatService — see staff_service.dart for the full
// explanation. Data lives under /bakery/orders.
//
// The base URL is read from the app's own FirebaseOptions.databaseURL at
// call time (not hardcoded), so this follows whatever project is configured
// in firebase_options.dart.
class OrderService {
  String get _baseUrl {
    final databaseURL = Firebase.app().options.databaseURL;
    if (databaseURL == null) {
      throw StateError(
        'No databaseURL configured for this Firebase project. Check '
        'firebase_options.dart / the Realtime Database exists for this project.',
      );
    }
    return '$databaseURL/bakery/orders';
  }

  Future<String?> _getToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  Future<void> add(Order order) async {
    final token = await _getToken();
    final uri = Uri.parse('$_baseUrl.json?auth=$token');
    await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(order.toMap()),
    );
  }

  Future<void> update(Order order) async {
    if (order.id == null) {
      throw ArgumentError('Cannot update an order without an id.');
    }
    final token = await _getToken();
    final uri = Uri.parse('$_baseUrl/${order.id}.json?auth=$token');
    await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(order.toMap()),
    );
  }

  Future<void> delete(String id) async {
    final token = await _getToken();
    final uri = Uri.parse('$_baseUrl/$id.json?auth=$token');
    await http.delete(uri);
  }

  Stream<List<Order>> getOrderStream() async* {
    while (true) {
      try {
        final token = await _getToken();
        final uri = Uri.parse('$_baseUrl.json?auth=$token');
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);

          if (decoded != null && decoded is Map) {
            final list = decoded.entries.map((entry) {
              return Order.fromMap(
                entry.key.toString(),
                Map<dynamic, dynamic>.from(entry.value),
              );
            }).toList();

            list.sort((a, b) => b.orderedDate.compareTo(a.orderedDate));
            yield list;
          } else {
            yield [];
          }
        }
      } catch (e) {
        // ignore: avoid_print
        print('OrderService error: $e');
        yield [];
      }

      await Future.delayed(const Duration(seconds: 2));
    }
  }
}
