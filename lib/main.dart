// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:flutter_launcher/operations/appops.dart';
import 'package:flutter_launcher/page/homepage.dart';
import 'package:flutter_launcher/page/drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Drawerpage());
  }
}
