import 'package:flutter/material.dart';

class AppFocusObserver extends WidgetsBindingObserver {
  bool isAppInFocus = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      isAppInFocus = true;
      // App is in focus
      debugPrint('App is in focus');
    } else {
      isAppInFocus = false;
      // App is not in focus
      debugPrint('App is not in focus');
    }
  }
}
