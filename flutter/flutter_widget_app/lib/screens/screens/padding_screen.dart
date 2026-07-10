import 'package:flutter/material.dart';

class PaddingScreen extends StatelessWidget {
  const PaddingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Padding Widget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        //padding: const EdgeInsets.symmetric(horizontal: 40),//another style
        child: Container(
          color: Colors.blue,
          height: 100,
          child: const Center(
            child: Text(
              'Padding Example',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}