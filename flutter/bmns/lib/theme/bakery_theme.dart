import 'package:flutter/material.dart';

// Same warm bakery palette as the web app's assets/style.css
// (cream background, brown/amber accents) so both look like one product.
class BakeryColors {
  static const cream = Color(0xFFFDF6EC);
  static const creamDark = Color(0xFFF5E9D6);
  static const brown = Color(0xFF6B4226);
  static const brownDark = Color(0xFF4A2C18);
  static const amber = Color(0xFFC9812F);
  static const amberDark = Color(0xFFA8651C);
  static const green = Color(0xFF2E7D32);
  static const red = Color(0xFFB3261E);
}

ThemeData buildBakeryTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: BakeryColors.amber,
    primary: BakeryColors.amber,
    onPrimary: Colors.white,
    secondary: BakeryColors.brown,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: BakeryColors.cream,
    appBarTheme: const AppBarTheme(
      backgroundColor: BakeryColors.brown,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: BakeryColors.amber,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: BakeryColors.cream,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: BakeryColors.creamDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: BakeryColors.amber, width: 2),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
