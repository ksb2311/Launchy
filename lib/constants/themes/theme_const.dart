import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';

final ThemeData defaultTheme = _buildDefaultTheme();
final ThemeData darkTheme = _buildDarkTheme();

// Color themeTextColor = Theme.of(context).textTheme.bodyLarge!.color!;
// Color themeBackground = Theme.of(context).scaffoldBackgroundColor;
const Color homeWidgetTextColor = Colors.white;

Color systemAccentColor = SystemTheme.accentColor.accent;
const scaffoldBGColor = Colors.transparent;

// font
const titleLargeFontWeight = FontWeight.bold;
const bodyMediumFontWeight = FontWeight.normal;
const labelLargeFontWeight = FontWeight.bold;

const titleLargeFontSize = 18.0;
const bodyMediumFontSize = 14.0;
const labelLargeFontSize = 19.0;

// default / light Theme
const Color drawerBackgroundLight = Colors.white;
const defaultAppBarBGColor = Colors.white;
const defaultAppBarFGColor = Colors.black;

// dark theme
const Color drawerBackgroundDark = Colors.black;
const darkAppBarBGColor = Colors.black;
const darkAppBarFGColor = Colors.white;

ThemeData _buildDefaultTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: systemAccentColor,
      // secondary: Colors.grey,
      // error: Colors.red,
      // background: Colors.transparent,
    ),
    textTheme: _buildDefaultTextTheme(base.textTheme),
    primaryTextTheme: _buildDefaultTextTheme(base.primaryTextTheme),
    appBarTheme: const AppBarTheme(
      // backgroundColor: defaultAppBarBGColor,
      // foregroundColor: defaultAppBarFGColor,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    ),
    scaffoldBackgroundColor: scaffoldBGColor,
  );
}

ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: systemAccentColor,
      // secondary: themeTextColor,
      // error: Colors.red,
      // background: Colors.black,
    ),
    textTheme: _buildDefaultTextTheme(base.textTheme),
    primaryTextTheme: _buildDefaultTextTheme(base.primaryTextTheme),
    appBarTheme: const AppBarTheme(
      // backgroundColor: darkAppBarBGColor,
      // foregroundColor: darkAppBarFGColor,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    ),
    scaffoldBackgroundColor: scaffoldBGColor,
  );
}

TextTheme _buildDefaultTextTheme(TextTheme base) {
  return base.copyWith(
    titleLarge: base.titleLarge?.copyWith(
      fontWeight: titleLargeFontWeight,
      fontSize: titleLargeFontSize,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontWeight: bodyMediumFontWeight,
      fontSize: bodyMediumFontSize,
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontWeight: labelLargeFontWeight,
      fontSize: labelLargeFontSize,
    ),
  );
}

ThemeData myTheme(BuildContext context) {
  return Theme.of(context);
}
