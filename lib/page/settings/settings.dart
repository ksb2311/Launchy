import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(String) onThemeChanged;
  final ValueChanged<bool> onShowIconsChanged;
  final ValueChanged<int> onDIconSizeChanged;
  final bool showIcons;
  final String setTheme;
  final int dIconSize;
  const SettingsPage(
      {Key? key,
      required this.onThemeChanged,
      required this.onShowIconsChanged,
      required this.showIcons,
      required this.setTheme,
      required this.dIconSize,
      required this.onDIconSizeChanged})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _selectedTheme;
  // double _iconSize = 24;
  late bool showIcons;
  late String setTheme;
  late int dIconSize;

  Color themeTextColor = Colors.black;
  Color themeBackground = Colors.white;
  var dIconSizeList = [24, 32, 48, 52];

  late double _value;

  @override
  void initState() {
    super.initState();
    showIcons = widget.showIcons;
    _selectedTheme = widget.setTheme;
    dIconSize = widget.dIconSize;
    _value = dIconSizeList.indexOf(dIconSize).toDouble() + 1;
    print(_value);
  }

  Future<void> openDefaultLauncher(BuildContext context) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = const AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.HOME',
      );
      await intent.launch();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('This feature is only available on Android devices')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData getThemeData(String theme) {
    //   switch (theme) {
    //     case 'Light':
    //       return ThemeData.light();
    //     case 'Dark':
    //       return ThemeData.dark();
    //     default:
    //       return ThemeData.from(colorScheme: ColorScheme.light());
    //   }
    // }

    Color? lightGrey = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              children: [
                const Text(
                  'Appearcance',
                  style: TextStyle(fontSize: 15),
                ),
                ListTile(
                  title: const Text('Theme'),
                  trailing: DropdownButton<String>(
                    value: _selectedTheme,
                    items: [
                      DropdownMenuItem(
                          child: Text(
                            'System Default',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!),
                          ),
                          value: 'System Default'),
                      DropdownMenuItem(
                          child: Text('Light',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!)),
                          value: 'Light'),
                      DropdownMenuItem(
                          child: Text('Dark',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!)),
                          value: 'Dark'),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        _selectedTheme = value!;
                      });
                      widget.onThemeChanged(value!);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Show Icons in Drawer'),
                  trailing: Switch(
                    value: showIcons,
                    onChanged: (bool value) {
                      setState(() {
                        showIcons = value;
                      });
                      widget.onShowIconsChanged(value);
                      debugPrint("widget.onShowIconsChanged $value $showIcons");
                    },
                  ),
                ),
                ListTile(
                  title: Text('Icon Size $dIconSize'),
                  onTap: () {
                    // Navigate to Widgets settings page
                  },
                ),
                SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 10.0,
                      trackShape: const RoundedRectSliderTrackShape(),
                      // activeTrackColor: Colors.purple.shade800,
                      // inactiveTrackColor: Colors.purple.shade100,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 14.0,
                        pressedElevation: 8.0,
                      ),
                      thumbColor: lightGrey,
                      overlayColor: Colors.black.withOpacity(0.2),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 32.0),
                      tickMarkShape: const RoundSliderTickMarkShape(),
                      // activeTickMarkColor: Colors.pinkAccent,
                      inactiveTickMarkColor: Colors.white,
                      valueIndicatorShape:
                          const PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.black,
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    child: Slider(
                      min: 1,
                      max: 4,
                      value: _value,
                      divisions: 3,
                      // label: '${_value.round()}',
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                          dIconSize = dIconSizeList[_value.toInt() - 1];
                        });
                        widget.onDIconSizeChanged(dIconSize);
                      },
                    )),
              ],
            ),
          ),
          // ListTile(
          //   title: const Text('Icon Size'),
          //   trailing: Slider(
          //     value: _iconSize,
          //     min: 12,
          //     max: 48,
          //     onChanged: (double value) {
          //       setState(() {
          //         _iconSize = value;
          //       });
          //     },
          //   ),
          // ),

          ListTile(
            title: const Text('Widgets'),
            onTap: () {
              // Navigate to Widgets settings page
            },
          ),
          ListTile(
            title: const Text('Set as Default'),
            onTap: () {
              // Navigate to Set as Default settings page
              openDefaultLauncher(context);
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('About'),
                    content: const Text('App version 1.0.0'),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
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
  }
}
