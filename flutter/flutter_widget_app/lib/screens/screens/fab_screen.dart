import 'package:flutter/material.dart';

class FabScreen extends StatefulWidget{
  const FabScreen({super.key});

  @override
  State<FabScreen> createState() => _FabScreenState();
}

class _FabScreenState extends State<FabScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Action button'),
      ),
      
      body: Center(
        child: Text(
          '$counter',
          style: const TextStyle(
            fontSize: 40,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => {
          setState(() {
            counter++;
          })
        },
        child: const Icon(
          color: Colors.white,
          Icons.add
        ),
      ),
    );
  }
}