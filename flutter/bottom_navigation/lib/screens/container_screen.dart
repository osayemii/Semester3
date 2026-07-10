import 'package:flutter/material.dart';

class ContainerScreen extends StatelessWidget{
  const ContainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 100,
          color: Colors.blue,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(10, 10),
                color: Colors.black,
                blurRadius: 45,
                spreadRadius: 20
              )
            ]
          ),
        ),
      ),
    );
  }
}