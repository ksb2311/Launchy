import 'package:flutter/material.dart';

final ThemeData defaultTheme = _buildDefaultTheme();

ThemeData _buildDefaultTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: Colors.blue,
      secondary: Colors.blue,
      error: Colors.red,
      background: Colors.white,
    ),
    textTheme: _buildDefaultTextTheme(base.textTheme),
    primaryTextTheme: _buildDefaultTextTheme(base.primaryTextTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}

TextTheme _buildDefaultTextTheme(TextTheme base) {
  return base.copyWith(
    titleLarge: base.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    ),
  );
}
