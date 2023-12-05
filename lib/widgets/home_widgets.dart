import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_launcher/constants/themes/theme_const.dart';

// shows digital clock 12hr
class DigitalClockWidget extends StatefulWidget {
  const DigitalClockWidget({Key? key}) : super(key: key);

  @override
  State<DigitalClockWidget> createState() => _DigitalClockWidgetState();
}

class _DigitalClockWidgetState extends State<DigitalClockWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    return Row(
      children: [
        Text(
          DateFormat('hh').format(DateTime.now()),
          style: TextStyle(
            color: homeWidgetTextColor,
            fontSize: 30,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        Text(
          DateFormat(':mm a').format(DateTime.now()),
          style: TextStyle(
            color: homeWidgetTextColor,
            fontSize: 30,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// shows full date with day
class FullDateWidget extends StatefulWidget {
  const FullDateWidget({Key? key}) : super(key: key);

  @override
  State<FullDateWidget> createState() => _FullDateWidgetState();
}

class _FullDateWidgetState extends State<FullDateWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(days: 1), (timer) {
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
        valueColor: const AlwaysStoppedAnimation<Color>(homeWidgetTextColor),
      ),
    ]);
  }
}
