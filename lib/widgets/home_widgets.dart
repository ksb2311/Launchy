import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_launcher/themes.dart';

class DigitalClockWidget extends StatelessWidget {
  const DigitalClockWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          // DateFormat('MM/dd/yyyy hh:mm:ss')
          DateFormat('hh').format(DateTime.now()),
          style: TextStyle(
            color: homeWidgetTextColor,
            fontSize: 30,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                // offset: const Offset(1, 1),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        Text(
          // DateFormat('MM/dd/yyyy hh:mm:ss')
          DateFormat(':mm a').format(DateTime.now()),
          style: TextStyle(
            color: homeWidgetTextColor,
            fontSize: 30,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                // offset: const Offset(1, 1),
                blurRadius: 10,
              ),
            ],
            // fontWeight: FontWeight.w200
          ),
        ),
      ],
    );
  }
}

class FullDateWidget extends StatelessWidget {
  const FullDateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      // DateFormat('MM/dd/yyyy hh:mm:ss')
      DateFormat('E dd MMM yyyy').format(DateTime.now()),
      style: TextStyle(
        color: homeWidgetTextColor,
        fontSize: 15,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.5),
            // offset: const Offset(1, 1),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}

class DayProgressWidget extends StatelessWidget {
  const DayProgressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int hours = now.hour;
    int minutes = now.minute;
    int seconds = now.second;

    int totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
    double progress = totalSeconds / 86400;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Day Progress ${(progress / 1 * 100).floor()} %',
        style: TextStyle(
          color: homeWidgetTextColor,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.5),
              // offset: const Offset(1, 1),
              blurRadius: 10,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey,
        valueColor: AlwaysStoppedAnimation<Color>(homeWidgetTextColor),
      ),
    ]);
  }
}
