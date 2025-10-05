import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 252, 252, 252),
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primaryContainer: const Color(0xFFE9AF00),
    primary: const Color(0xFFE9AF00),
    onPrimary: const Color(0xFF191917),
    secondary: const Color(0xFFF28500),
    onSecondary: const Color(0xFF191917),
    error: const Color(0xFFC71A11),
    onError: const Color(0xFF191917),
    surface: const Color.fromARGB(255, 255, 255, 255),
    onSurface: const Color(0xFF191917),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.black),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
);
