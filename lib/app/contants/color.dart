import 'package:flutter/material.dart';

const appPurple = Color(0xFF431AA1);
const appPurpleDark = Color(0xFF1E0771);
const appPurpleLight1 = Color(0xFF9345F2);
const appPurpleLight2 = Color(0xFFB9A2D8);
const appWhite = Color(0xFFFAF8FC);
const appOrange = Color(0xFFE670A4);

ThemeData themeLight = ThemeData(
  brightness: Brightness.light,
  primaryColor: appPurple,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    elevation: 4,
    backgroundColor: appPurple,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appPurpleDark,
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
  listTileTheme: const ListTileThemeData(
    textColor: appPurpleDark,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: appPurpleDark,
    indicatorColor: appPurpleDark,
    unselectedLabelColor: Colors.grey,
  ),
);

ThemeData themeDark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: appPurple,
  scaffoldBackgroundColor: appPurpleDark,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: appPurpleDark,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: appWhite,
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
  listTileTheme: const ListTileThemeData(
    textColor: appWhite,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: appWhite,
    indicatorColor: appWhite,
    unselectedLabelColor: Colors.grey,
  ),
);
