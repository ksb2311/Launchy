import 'package:flutter/material.dart';

final ThemeData defaultTheme = _buildDefaultTheme();

final ThemeData darkTheme = _buildDarkTheme();

Color themeTextColor = Colors.white;
Color themeBackground = Colors.white;
Color homeWidgetTextColor = Colors.white;
const Color drawerBackgroundLight = Colors.white;
const Color drawerBackgroundDark = Colors.grey;

ThemeData _buildDefaultTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    useMaterial3: true,
    colorScheme: base.colorScheme.copyWith(
      primary: Colors.grey,
      secondary: Colors.grey,
      error: Colors.red,
      // background: Colors.transparent,
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
    scaffoldBackgroundColor: Colors.transparent,
  );
}

ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    useMaterial3: true,
    colorScheme: base.colorScheme.copyWith(
      primary: Colors.grey,
      secondary: Colors.grey,
      error: Colors.red,
      background: Colors.black,
    ),
    textTheme: _buildDefaultTextTheme(base.textTheme),
    primaryTextTheme: _buildDefaultTextTheme(base.primaryTextTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    ),
    scaffoldBackgroundColor: Colors.transparent,
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
