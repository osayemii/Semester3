import 'package:flutter/material.dart';

class ColumnScreen extends StatelessWidget {
  const ColumnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Column Widget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 100, height: 60, color: Colors.red),
            Container(width: 100, height: 60, color: Colors.green),
            Container(width: 100, height: 60, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}