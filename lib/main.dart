// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_launcher/operations/appops.dart';
import 'package:flutter_launcher/page/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  String _selectedTheme = 'System Default';
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  @override
  Widget build(BuildContext context) {
    ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
      ),
    );

    ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
      ),
    );

    ThemeData getThemeData(String theme) {
      switch (theme) {
        case 'Light':
          return lightTheme;
        case 'Dark':
          return darkTheme;
        default:
          bool isDarkMode = brightness == Brightness.dark;
          if (!isDarkMode) {
            return lightTheme;
          } else {
            return darkTheme;
          }
      }
    }

    return MaterialApp(
        theme: getThemeData(_selectedTheme),
        // darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: HomePage(
          onThemeChanged: (String theme) {
            setState(() {
              _selectedTheme = theme;
            });
          },
        ));
  }
}
