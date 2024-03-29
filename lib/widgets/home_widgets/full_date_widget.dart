import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_launcher/constants/themes/theme_const.dart';
import 'package:intl/intl.dart';

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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Text(
          // DateFormat('MM/dd/yyyy hh:mm:ss')
          DateFormat('E dd MMM yyyy').format(DateTime.now()),
          style: TextStyle(
            color: systemAccentColor,
            fontSize: 15,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                // offset: const Offset(1, 1),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
