import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Theme App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Bar')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Heading 4',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
              letterSpacing: 10,
              wordSpacing: 5,
              backgroundColor: Colors.red,
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  offset: Offset(5, 10),
                  color: Colors.grey,
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          Slider(value: 0.28, onChanged: (s) {}),
          Icon(Icons.collections_sharp),
          Checkbox(value: false, onChanged: (s) {}),
          TextButton(onPressed: () {}, child: Text('Text Button')),
          ElevatedButton(onPressed: () {}, child: Text('Elevatedd Button')),
        ],
      ),
    );
  }
}
