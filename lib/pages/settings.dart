import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/constants/settings/settings_const.dart';
import 'package:flutter_launcher/widgets/settings_widgets.dart';

class SettingsPage extends StatefulWidget {
  final Function(String) onThemeChanged;
  final ValueChanged<bool> onShowIconsChanged;
  final ValueChanged<bool> onShowClockChanged;
  final ValueChanged<bool> onShowDateChanged;
  final ValueChanged<bool> onShowDayProgressChanged;
  final ValueChanged<bool> onShowTodoChanged;
  final ValueChanged<int> onDIconSizeChanged;
  final bool showIcons;
  final bool showClock;
  final bool showDate;
  final bool showDayProgress;
  final bool showTodo;
  final String setTheme;
  final int dIconSize;
  const SettingsPage(
      {Key? key,
      required this.onThemeChanged,
      required this.onShowIconsChanged,
      required this.showIcons,
      required this.setTheme,
      required this.dIconSize,
      required this.onDIconSizeChanged,
      required this.showClock,
      required this.showDate,
      required this.showDayProgress,
      required this.onShowClockChanged,
      required this.onShowDateChanged,
      required this.onShowDayProgressChanged,
      required this.onShowTodoChanged,
      required this.showTodo})
      : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final MethodChannel _channel = const MethodChannel('settings_channel');

  late String _selectedTheme;
  // double _iconSize = 24;
  late bool showIcons;
  late bool showClock;
  late bool showDate;
  late bool showDayProgress;
  late bool showTodo;
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
    showClock = widget.showClock;
    showDate = widget.showDate;
    showDayProgress = widget.showDayProgress;
    showTodo = widget.showTodo;
    _selectedTheme = widget.setTheme;
    dIconSize = widget.dIconSize;
    _value = dIconSizeList.indexOf(dIconSize).toDouble() + 1;
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

    // Color? lightGrey = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        shadowColor: Colors.transparent,
      ),
      body: Column(
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
                        return GestureDetector(
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
                                              value: _selectedTheme,
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
                                                setState(() {
                                                  _selectedTheme = value!;
                                                });
                                                widget.onThemeChanged(value!);
                                              },
                                            ),
                                          ),
                                        ),
                                        SwitchListTile(
                                          title: const Text('Show Icons in Drawer'),
                                          value: showIcons,
                                          inactiveTrackColor: Colors.grey,
                                          // trackOutlineColor:
                                          //     MaterialStatePropertyAll(
                                          //         Colors.grey[400]),
                                          // activeTrackColor: Colors.grey,
                                          onChanged: (bool value) {
                                            setState(() {
                                              showIcons = value;
                                            });
                                            widget.onShowIconsChanged(value);
                                          },
                                        ),
                                        ListTile(
                                          title: Text('Home Icon Size $dIconSize'),
                                          // onTap: () {
                                          //   // Navigate to Widgets settings page
                                          // },
                                        ),
                                        SliderTheme(
                                          data: SliderTheme.of(context).copyWith(
                                            trackHeight: 10.0,
                                            trackShape: const RoundedRectSliderTrackShape(),
                                            thumbShape: const RoundSliderThumbShape(
                                                enabledThumbRadius: 14.0,
                                                // pressedElevation: 8.0,
                                                elevation: 2),
                                            thumbColor: themeBackground,
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
                                            onChanged: (value) {
                                              setState(() {
                                                _value = value;
                                                dIconSize = dIconSizeList[_value.toInt() - 1];
                                              });
                                              widget.onDIconSizeChanged(dIconSize);
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
                          return GestureDetector(
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
                                            value: showClock,
                                            inactiveTrackColor: Colors.grey,
                                            onChanged: (bool value) {
                                              setState(() {
                                                showClock = value;
                                              });
                                              widget.onShowClockChanged(value);
                                            },
                                          ),
                                          SwitchListTile(
                                            title: const Text(dateHomeWidget),
                                            value: showDate,
                                            inactiveTrackColor: Colors.grey,
                                            onChanged: (bool value) {
                                              setState(() {
                                                showDate = value;
                                              });
                                              widget.onShowDateChanged(value);
                                            },
                                          ),
                                          SwitchListTile(
                                            title: const Text(dayprogressHomeWidget),
                                            value: showDayProgress,
                                            inactiveTrackColor: Colors.grey,
                                            onChanged: (bool value) {
                                              setState(() {
                                                showDayProgress = value;
                                              });
                                              widget.onShowDayProgressChanged(value);
                                            },
                                          ),
                                          SwitchListTile(
                                            title: const Text(tasksHomeWidget),
                                            value: showTodo,
                                            inactiveTrackColor: Colors.grey,
                                            onChanged: (bool value) {
                                              setState(() {
                                                showTodo = value;
                                              });
                                              widget.onShowTodoChanged(value);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ]));
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
                            return MiscSetting(openDefaultLauncher);
                          });
                    }),
                ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text(aboutTitle),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return const AboutSetting();
                          });
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}