import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_launcher/page/homepage.dart';
import 'package:flutter_launcher/themes.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedTheme = 'System Default';
  bool shouldShowIcons = true;
  bool shouldShowClock = true;
  bool shouldShowDate = true;
  bool shouldShowDayProgress = true;
  bool shouldShowTodo = true;
  int dIconSize = 48;
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  @override
  Widget build(BuildContext context) {
    ThemeData getThemeData(String theme) {
      switch (theme) {
        case 'Light':
          return defaultTheme;
        case 'Dark':
          return darkTheme;
        default:
          bool isDarkMode = brightness == Brightness.dark;
          if (!isDarkMode) {
            return defaultTheme;
          } else {
            return darkTheme;
          }
      }
    }

    return MaterialApp(
        theme: getThemeData(_selectedTheme),
        themeMode: ThemeMode.system,
        home: HomePage(
          dIconSize: dIconSize,
          setTheme: _selectedTheme,
          setIcon: shouldShowIcons,
          setClock: shouldShowClock,
          setDate: shouldShowDate,
          setDayProgress: shouldShowDayProgress,
          setTodo: shouldShowTodo,
          onThemeChanged: (String theme) {
            setState(() {
              _selectedTheme = theme;
            });
          },
        ));
  }
}
