import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BankApp());
}

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PayDay Bank App",
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}