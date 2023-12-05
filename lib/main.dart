import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_launcher/pages/homepage.dart';
import 'package:flutter_launcher/constants/themes/theme_const.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTheme.accentColor.load();
  runApp(const MaterialApp(home: MyApp()));
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
  bool shouldShowDayProgress = false;
  bool shouldShowTodo = false;
  int dIconSize = 48;
  Brightness brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;

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
