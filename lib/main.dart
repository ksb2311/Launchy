import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_launcher/pages/homepage.dart';
import 'package:flutter_launcher/constants/themes/theme_const.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late SharedPreferences prefs;

  late String _selectedTheme = 'System Default';
  late bool shouldShowIcons = true;
  late bool shouldShowClock = true;
  late bool shouldShowDate = true;
  late bool shouldShowDayProgress = false;
  late bool shouldShowTodo = false;
  late int dIconSize = 48;
  
  Brightness brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    loadSettings();
  }

  void loadSettings() {
    _selectedTheme = prefs.getString('_selectedTheme') ?? 'System Default';
    shouldShowIcons = prefs.getBool('shouldShowIcons') ?? true;
    shouldShowClock = prefs.getBool('shouldShowClock') ?? true;
    shouldShowDate = prefs.getBool('shouldShowDate') ?? true;
    shouldShowDayProgress = prefs.getBool('shouldShowDayProgress') ?? false;
    shouldShowTodo = prefs.getBool('shouldShowTodo') ?? false;
    dIconSize = prefs.getInt('dIconSize') ?? 48;
  }

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
