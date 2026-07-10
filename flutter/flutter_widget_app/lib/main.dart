import 'package:flutter/material.dart';
import 'package:flutter_widget_app/screens/screens/home_screen.dart';
// import 'screens/screens/tabbar_screen.dart';
// import 'screens/screens/fab_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Widgets",
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
