import 'package:flutter/material.dart';

class IconScreen extends StatelessWidget {
  const IconScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Widget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [

            Icon(
              Icons.home,
              size: 60,
              color: Colors.blue,
            ),

            SizedBox(height: 20),

            Icon(
              Icons.favorite,
              size: 60,
              color: Colors.red,
            ),

            SizedBox(height: 20),

            Icon(
              Icons.settings,
              size: 60,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}