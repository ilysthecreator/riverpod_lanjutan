import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF673AB7); // Deep Purple
  static const Color secondaryColor = Color(0xFF03A9F4); // Light Blue
  static const Color errorColor = Color(0xFFF44336); // Red
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color textBodyColor = Color(0xFF333333);
  static const Color textTitleColor = Color(0xFF111111);
  static const Color textSecondaryColor = Color(0xFF757575);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.grey[50], // Or another light color
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.grey[900], // Or another dark color
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.dark),
    useMaterial3: true,
  );
}
