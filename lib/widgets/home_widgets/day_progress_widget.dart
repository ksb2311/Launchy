import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_launcher/constants/themes/theme_const.dart';

//shows day progress bar
class DayProgressWidget extends StatefulWidget {
  const DayProgressWidget({Key? key}) : super(key: key);

  @override
  State<DayProgressWidget> createState() => _DayProgressWidgetState();
}

class _DayProgressWidgetState extends State<DayProgressWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(hours: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int hours = now.hour;
    int minutes = now.minute;
    int seconds = now.second;

    int totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
    double progress = totalSeconds / 86400;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Text(
          'Day Progress ${(progress / 1 * 100).floor()} %',
          style: TextStyle(
            color: systemAccentColor,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                // offset: const Offset(1, 1),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(systemAccentColor),
        ),
      ]),
    );
  }
}
