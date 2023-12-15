import 'package:flutter/material.dart';

const appPurple = Color(0xFF431AA1);
const appPurpleDark = Color(0xFF1E0771);
const appPurpleLight1 = Color(0xFF9345F2);
const appPurpleLight2 = Color(0xFFB9A2D8);
const appWhite = Color(0xFFFAF8FC);
const appOrange = Color(0xFFE670A4);

ThemeData themeLight = ThemeData(
  primaryColor: appPurple,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: appPurple,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: appPurpleDark,
    ),
    bodyMedium: TextStyle(
      color: appPurpleDark,
    ),
    bodySmall: TextStyle(
      color: appPurpleDark,
    ),
  ),
);

ThemeData themeDark = ThemeData(
  primaryColor: appPurple,
  scaffoldBackgroundColor: appPurpleDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: appPurpleDark,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: appWhite,
    ),
    bodyMedium: TextStyle(
      color: appWhite,
    ),
    bodySmall: TextStyle(
      color: appWhite,
    ),
  ),
);
