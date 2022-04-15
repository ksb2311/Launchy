// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_final_fields

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var columnCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: PageView(
        children: [
          Container(
            child: Center(
              child: Text(
                "home",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          FutureBuilder(
            future: DeviceApps.getInstalledApplications(
              includeSystemApps: true,
              includeAppIcons: true,
              onlyAppsWithLaunchIntent: true,
            ),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Application> allApps = snapshot.data;

                return GridView.count(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: columnCount,
                  padding: EdgeInsets.only(top: 60),
                  children: List.generate(allApps.length, (index) {
                    return GestureDetector(
                        onTap: () =>
                            {DeviceApps.openApp(allApps[index].packageName)},
                        child: Column(
                          children: [
                            Image.memory(
                              (allApps[index] as ApplicationWithIcon).icon,
                              width: 42,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              allApps[index].appName,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ));
                  }),
                );
              }
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    ));
  }
}
