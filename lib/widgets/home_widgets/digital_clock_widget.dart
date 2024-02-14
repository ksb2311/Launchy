import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_launcher/constants/themes/theme_const.dart';
import 'package:intl/intl.dart';

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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            DateFormat('hh').format(DateTime.now()),
            style: TextStyle(
              color: systemAccentColor,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          Text(
            DateFormat('mm').format(DateTime.now()),
            style: TextStyle(
              color: systemAccentColor,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          Text(
            DateFormat('a').format(DateTime.now()),
            style: TextStyle(
              color: systemAccentColor,
              fontSize: 40,
              // fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
