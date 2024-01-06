import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const appearanceTitle = 'Appearance';
const homeWidgetsTitle = 'Home Widgets';
const miscTitle = 'Misc';
const aboutTitle = 'About';

const clockHomeWidget = 'Clock';
const dateHomeWidget = 'Date';
const dayprogressHomeWidget = 'Day Progress';
const tasksHomeWidget = 'Tasks';

class SettingsConst extends ChangeNotifier {
  late SharedPreferences prefs;

  bool _showIcons = false;
  bool _showClock = false;
  bool _showDate = false;
  bool _showDayProgress = false;
  bool _showTodo = false;
  String _setTheme = 'System Default';
  int _dIconSize = 48;

  bool get showIcons => _showIcons;
  bool get showClock => _showClock;
  bool get showDate => _showDate;
  bool get showDayProgress => _showDayProgress;
  bool get showTodo => _showTodo;
  String get setTheme => _setTheme;
  int get dIconSize => _dIconSize;

  SettingsConst() {
    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    loadSettings();
  }

  void loadSettings() {
    _showIcons = prefs.getBool('showIcons') ?? true;
    _showClock = prefs.getBool('showClock') ?? true;
    _showDate = prefs.getBool('showDate') ?? true;
    _showDayProgress = prefs.getBool('showDayProgress') ?? false;
    _showTodo = prefs.getBool('showTodo') ?? false;
    _setTheme = prefs.getString('setTheme') ?? 'System Default';
    _dIconSize = prefs.getInt('dIconSize') ?? 48;
    notifyListeners();
  }

  void toggleShowIcons() {
    _showIcons = !_showIcons;
    prefs.setBool('showIcons', _showIcons);
    notifyListeners();
  }

  void toggleShowClock() {
    _showClock = !_showClock;
    prefs.setBool('showClock', _showClock);
    notifyListeners();
  }

  void toggleShowDate() {
    _showDate = !_showDate;
    prefs.setBool('showDate', _showDate);
    notifyListeners();
  }

  void toggleShowDayProgress() {
    _showDayProgress = !_showDayProgress;
    prefs.setBool('showDayProgress', _showDayProgress);
    notifyListeners();
  }

  void toggleShowTodo() {
    _showTodo = !_showTodo;
    prefs.setBool('showTodo', _showTodo);
    notifyListeners();
  }

  void setThemeStyle(String theme) {
    _setTheme = theme;
    prefs.setString('setTheme', _setTheme);
    notifyListeners();
  }

  void setDIconSize(int size) {
    _dIconSize = size;
    prefs.setInt('dIconSize', _dIconSize);
    notifyListeners();
  }
}
