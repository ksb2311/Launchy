import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/constants/settings/settings_const.dart';
import 'package:flutter_launcher/widgets/settings_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final MethodChannel _channel = const MethodChannel('settings_channel');

  // late String _selectedTheme;

  late SharedPreferences prefs;

  // double _iconSize = 24;
  // late bool showIcons;
  // late bool showClock;
  // late bool showDate;
  // late bool showDayProgress;
  // late bool showTodo;
  // late String setTheme;
  // late int dIconSize;

  // Color themeTextColor = Colors.black;
  // Color themeBackground = Colors.white;
  var dIconSizeList = [32, 48, 52, 60];

  late double _value;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void saveSetting(String key, dynamic value) async {
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  // Future<void> openDefaultLauncher(BuildContext context) async {
  //   if (Platform.isAndroid) {
  //     AndroidIntent intent = AndroidIntent(
  //       action: 'android.intent.action.MAIN',
  //       category: 'android.intent.category.HOME',
  //       flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
  //     );
  //     intent.launch();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('This feature is only available on Android devices')),
  //     );
  //   }
  // }

  void openDefaultLauncher() {
    _channel.invokeMethod('setDefaultLauncher');
  }

  @override
  Widget build(BuildContext context) {
    final settingsConst = Provider.of<SettingsConst>(context, listen: false);

    _value = dIconSizeList.indexOf(settingsConst.dIconSize).toDouble() + 1;
    // debugPrint('initPrefs() $_selectedTheme');

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        shadowColor: Colors.transparent,
      ),
      body: Container(
        margin: EdgeInsets.only(
          bottom: MediaQueryData.fromView(View.of(context)).padding.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                // height: 300,
                padding: const EdgeInsets.all(30),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Launchy',
                        style: TextStyle(fontSize: 30),
                        // textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Android Launcher',
                        // textAlign: TextAlign.center
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.color_lens_outlined),
                    title: const Text(appearanceTitle),
                    onTap: () {
                      showModalBottomSheet(
                        // backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.only(
                              bottom: MediaQueryData.fromView(View.of(context)).padding.bottom,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Wrap(
                                children: [
                                  StatefulBuilder(
                                    builder: (BuildContext context, setState) {
                                      return Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.all(10),
                                        // decoration: BoxDecoration(
                                        //   color: Theme.of(context).brightness ==
                                        //           Brightness.dark
                                        //       ? Colors.grey[800]
                                        //       : Colors.grey[800],
                                        //   borderRadius: BorderRadius.circular(30),
                                        // ),
                                        child: Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              padding: const EdgeInsets.all(5),
                                              margin: const EdgeInsets.all(15),
                                              width: MediaQuery.of(context).size.width,
                                              // decoration: BoxDecoration(
                                              //   color: Theme.of(context).brightness ==
                                              //           Brightness.dark
                                              //       ? Colors.black
                                              //       : Colors.white,
                                              //   borderRadius: BorderRadius.circular(20),
                                              // ),
                                              child: const Text(
                                                appearanceTitle,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            ListTile(
                                              title: const Text('Theme'),
                                              trailing: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  borderRadius: BorderRadius.circular(20),
                                                  value: settingsConst.setTheme,
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: 'System Default',
                                                      child: Text(
                                                        'System Default',
                                                        style: TextStyle(
                                                          color: Theme.of(context).textTheme.bodyLarge!.color!,
                                                        ),
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Light',
                                                      child: Text(
                                                        'Light',
                                                        style: TextStyle(
                                                          color: Theme.of(context).textTheme.bodyLarge!.color!,
                                                        ),
                                                      ),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: 'Dark',
                                                      child: Text(
                                                        'Dark',
                                                        style: TextStyle(
                                                          color: Theme.of(context).textTheme.bodyLarge!.color!,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  onChanged: (String? value) {
                                                    // setState(() {
                                                    //   _selectedTheme = value!;
                                                    // });
                                                    // widget.onThemeChanged(_selectedTheme);
                                                    settingsConst.setThemeStyle(value!);
                                                    setState(() {});
                                                    saveSetting('_selectedTheme', value);
                                                    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                                                      systemNavigationBarIconBrightness:
                                                          Theme.of(context).brightness == Brightness.dark ? Brightness.dark : Brightness.light,
                                                    ));
                                                  },
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              title: const Text('App Drawer Style'),
                                              trailing: ToggleButtons(
                                                isSelected: [settingsConst.showIcons, !settingsConst.showIcons],
                                                borderRadius: BorderRadius.circular(20),
                                                onPressed: (int index) {
                                                  setState(() {
                                                    for (int i = 0; i < 2; i++) {
                                                      if (i == index) {
                                                        settingsConst.toggleShowIcons();
                                                      }
                                                    }
                                                  });
                                                  saveSetting('showIcons', settingsConst.showIcons);
                                                },
                                                children: const <Widget>[
                                                  Icon(Icons.grid_view),
                                                  Icon(Icons.list),
                                                ],
                                              ),
                                            ),
                                            ListTile(
                                              title: const Text('Home Icon Size'),
                                              trailing: Text(
                                                '${settingsConst.dIconSize}',
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              // onTap: () {
                                              //   // Navigate to Widgets settings page
                                              // },
                                            ),
                                            SliderTheme(
                                              data: SliderTheme.of(context).copyWith(
                                                // trackHeight: 10.0,
                                                trackShape: const RoundedRectSliderTrackShape(),
                                                thumbShape: const RoundSliderThumbShape(
                                                    enabledThumbRadius: 14.0,
                                                    // pressedElevation: 8.0,
                                                    elevation: 2),
                                                // thumbColor: themeBackground,
                                                // overlayColor:
                                                //     Colors.black.withOpacity(0.2),
                                                // overlayShape:
                                                //     const RoundSliderOverlayShape(
                                                //         overlayRadius: 32.0),
                                                tickMarkShape: const RoundSliderTickMarkShape(),
                                                // inactiveTickMarkColor: Colors.black,
                                                // activeTickMarkColor: themeTextColor,
                                                // valueIndicatorShape:
                                                //     const PaddleSliderValueIndicatorShape(),
                                                // valueIndicatorColor: themeTextColor,
                                                // valueIndicatorTextStyle:
                                                //     const TextStyle(
                                                //   color: Colors.white,
                                                //   fontSize: 20.0,
                                                // ),
                                              ),
                                              child: Slider(
                                                min: 1,
                                                max: 4,
                                                value: _value,
                                                divisions: 3,
                                                label: '${settingsConst.dIconSize}',
                                                onChanged: (value) {
                                                  setState(() {
                                                    _value = value;
                                                    settingsConst.setDIconSize(dIconSizeList[_value.toInt() - 1]);
                                                  });
                                                  // widget.onDIconSizeChanged(dIconSize);
                                                  saveSetting('dIconSize', settingsConst.dIconSize);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.widgets_outlined),
                    title: const Text(homeWidgetsTitle),
                    onTap: () {
                      showModalBottomSheet(
                          // backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              margin: EdgeInsets.only(
                                bottom: MediaQueryData.fromView(View.of(context)).padding.bottom,
                              ),
                              child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Wrap(children: [
                                    StatefulBuilder(
                                      builder: (BuildContext context, setState) {
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
                                                width: MediaQuery.sizeOf(context).width,
                                                // decoration: BoxDecoration(
                                                //     color: Theme.of(context).brightness ==
                                                //             Brightness.dark
                                                //         ? Colors.black
                                                //         : Colors.white,
                                                //     borderRadius:
                                                //         BorderRadius.circular(20)),
                                                child: const Text(
                                                  'Widgets',
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                              SwitchListTile(
                                                title: const Text(clockHomeWidget),
                                                value: settingsConst.showClock,
                                                // inactiveTrackColor: Colors.grey,
                                                onChanged: (bool value) {
                                                  // setState(() {
                                                  //   showClock = value;
                                                  // });
                                                  // widget.onShowClockChanged(value);
                                                  settingsConst.toggleShowClock();
                                                  setState(() {});
                                                  saveSetting('showClock', value);
                                                },
                                              ),
                                              SwitchListTile(
                                                title: const Text(dateHomeWidget),
                                                value: settingsConst.showDate,
                                                // inactiveTrackColor: Colors.grey,
                                                onChanged: (bool value) {
                                                  // setState(() {
                                                  //   showDate = value;
                                                  // });
                                                  // widget.onShowDateChanged(value);
                                                  settingsConst.toggleShowDate();
                                                  setState(() {});
                                                  saveSetting('showDate', value);
                                                },
                                              ),
                                              SwitchListTile(
                                                title: const Text(dayprogressHomeWidget),
                                                value: settingsConst.showDayProgress,
                                                // inactiveTrackColor: Colors.grey,
                                                onChanged: (bool value) {
                                                  // setState(() {
                                                  //   showDayProgress = value;
                                                  // });
                                                  // widget.onShowDayProgressChanged(value);
                                                  settingsConst.toggleShowDayProgress();
                                                  setState(() {});
                                                  saveSetting('showDayProgress', value);
                                                },
                                              ),
                                              SwitchListTile(
                                                title: const Text(tasksHomeWidget),
                                                value: settingsConst.showTodo,
                                                // inactiveTrackColor: Colors.grey,
                                                onChanged: (bool value) {
                                                  // setState(() {
                                                  //   showTodo = value;
                                                  // });
                                                  // widget.onShowTodoChanged(value);
                                                  settingsConst.toggleShowTodo();
                                                  setState(() {});
                                                  saveSetting('showTodo', value);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  ])),
                            );
                          });
                    },
                  ),
                  ListTile(
                      leading: const Icon(Icons.miscellaneous_services_outlined),
                      title: const Text(miscTitle),
                      onTap: () {
                        showModalBottomSheet(
                            // backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  margin: EdgeInsets.only(
                                    bottom: MediaQueryData.fromView(View.of(context)).padding.bottom,
                                  ),
                                  child: MiscSetting(openDefaultLauncher));
                            });
                      }),
                  ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text(aboutTitle),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  margin: EdgeInsets.only(
                                    bottom: MediaQueryData.fromView(View.of(context)).padding.bottom,
                                  ),
                                  child: const AboutSetting());
                            });
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
