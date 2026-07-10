import 'package:flutter/material.dart';

class AlignScreen extends StatelessWidget {
  const AlignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Align Widget'),
      ),
      body: Align(
        alignment: Alignment.bottomRight,
        /*other styles
        Alignment.topLeft
        Alignment.center
        Alignment.bottomCenter*/
        child: Container(
          width: 120,
          height: 120,
          color: Colors.orange,
        ),
      ),
    );
  }
}