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
          DateFormat('h').format(DateTime.now()),
          style: TextStyle(
            color: homeWidgetTextColor,
            fontSize: 50,
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
          DateFormat(':mm').format(DateTime.now()),
          style: TextStyle(
            color: homeWidgetTextColor,
            fontSize: 50,
            fontWeight: FontWeight.bold,
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
