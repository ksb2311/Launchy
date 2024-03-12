import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/constants/settings/settings_const.dart';

class AboutSetting extends StatelessWidget {
  const AboutSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Wrap(children: [
          StatefulBuilder(builder: (BuildContext context, setState) {
            return Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //     color: Theme.of(context).brightness ==
              //             Brightness.dark
              //         ? Colors.grey[800]
              //         : Colors.grey[200],
              //     borderRadius:
              //         BorderRadius.circular(30)),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(15),
                    width: double.infinity,
                    // decoration: BoxDecoration(
                    //     color: Theme.of(context).brightness ==
                    //             Brightness.dark
                    //         ? Colors.black
                    //         : Colors.white,
                    //     borderRadius:
                    //         BorderRadius.circular(20)),
                    child: const Text(
                      'Launchy',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: const Text('Licences'),
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('No Licence'),
                            content: const Text('You are under arrest!'),
                            actions: [
                              TextButton(
                                child: Text('Resist',
                                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[200] : Colors.grey[800])),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('About'),
                    onTap: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('About'),
                            content: const Text('App version 0.1.0'),
                            actions: [
                              TextButton(
                                child: Text('Close',
                                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[200] : Colors.grey[800])),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          })
        ]));
  }
}

class MiscSetting extends StatelessWidget {
  final VoidCallback? openDefaultLauncher;
  const MiscSetting(this.openDefaultLauncher, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Wrap(children: [
          StatefulBuilder(builder: (BuildContext context, setState) {
            return Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //     color: Theme.of(context).brightness ==
              //             Brightness.dark
              //         ? Colors.grey[800]
              //         : Colors.grey[200],
              //     borderRadius:
              //         BorderRadius.circular(30)),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(15),
                    // width: MediaQuery.sizeOf(context).width,
                    // decoration: BoxDecoration(
                    //     color: Theme.of(context).brightness ==
                    //             Brightness.dark
                    //         ? Colors.black
                    //         : Colors.white,
                    //     borderRadius:
                    //         BorderRadius.circular(20)),
                    child: const Text(
                      miscTitle,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    title: const Text('Set as Default'),
                    onTap: () {
                      // Navigate to Set as Default settings page
                      // openDefaultLauncher(context);
                      // Navigator.pop(context);
                      openDefaultLauncher!();
                    },
                  ),
                  ListTile(
                    title: const Text('Device Settings'),
                    onTap: () async {
                      // Navigator.pop(context);
                      // Navigate to Set as Default settings page
                      if (Platform.isAndroid) {
                        AndroidIntent intent = const AndroidIntent(
                          action: 'android.settings.SETTINGS',
                        );
                        await intent.launch();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('This feature is only available on Android devices'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          })
        ]));
  }
}

class HomeWidgetsSetting extends StatelessWidget {
  const HomeWidgetsSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
