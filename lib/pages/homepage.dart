import 'dart:ui';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/modules/app_focus_observer.dart';
import 'package:flutter_launcher/modules/app_helper.dart';
import 'package:flutter_launcher/pages/settings.dart';
import 'package:flutter_launcher/widgets/drawer_widget.dart';
import 'package:flutter_launcher/widgets/pageview_widget.dart';

class HomePage extends StatefulWidget {
  final Function(String) onThemeChanged;
  final String setTheme;
  final bool setIcon;
  final bool setClock;
  final bool setDate;
  final bool setDayProgress;
  final bool setTodo;
  final int dIconSize;
  const HomePage(
      {Key? key,
      required this.onThemeChanged,
      required this.setTheme,
      required this.setIcon,
      required this.dIconSize,
      required this.setClock,
      required this.setDate,
      required this.setDayProgress,
      required this.setTodo})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // List<Application> listApps = AppOps().searchAppList;
  final appops = AppOps();
  late List<Application> dockIconList;
  List<Application> preAppList = [];
  AppFocusObserver appFocusObserver = AppFocusObserver();

// search textfield controller
  final _textEditingController = TextEditingController();

// settings parametere
  late bool shouldShowIcons;
  late bool shouldShowClock;
  late bool shouldShowDate;
  late bool shouldShowDayProgress;
  late bool shouldShowTodo;
  late int dIconSize;

// scroll controller
  // final ScrollController _scrollController = ScrollController();

  final List<String> alphabets = List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

  // final double _itemExtent = 100;

  // int _currentIndex = 0;

// battery parameters
  var battery = Battery();
  int bLevel = 0;
// expands notification panel
  final MethodChannel _channel = const MethodChannel('settings_channel');

  @override
  void initState() {
    super.initState();
    loadApps();
    WidgetsBinding.instance.addObserver(this);
    shouldShowIcons = widget.setIcon;
    shouldShowClock = widget.setClock;
    shouldShowDate = widget.setDate;
    shouldShowDayProgress = widget.setDayProgress;
    shouldShowTodo = widget.setTodo;
    dIconSize = widget.dIconSize;
    getBatteryPercentage();
    // Stream<ApplicationEvent> appEvents = DeviceApps.listenToAppsChanges();
    WidgetsBinding.instance.addObserver(appFocusObserver);
    dockIconList = appops.docklistitems;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(appFocusObserver);
    _textEditingController.clear();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);

  //   if (state == AppLifecycleState.paused) {
  //     // Handle the app being uninstalled
  //     // Perform the necessary list update here
  //     // Example: delete all items from the `todoItems` list

  //     setState(() {
  //       appops.searchAppList.clear();
  //       loadApps();
  //     });
  //   }
  // }

  // displays notification panel
  void _showNotificationPanel() {
    _channel.invokeMethod('showNotificationPanel');
  }

  // creating list of installed apps
  Future<void> loadApps() async {
    List<Application> apps =
        await DeviceApps.getInstalledApplications(includeAppIcons: true, includeSystemApps: true, onlyAppsWithLaunchIntent: true);

    apps.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

    setState(() {
      appops.searchAppList = apps;
    });
  }

  // clears input text serach textfield
  void _clearText() {
    _textEditingController.clear();
  }

  // Gettinng first letter of appname
  String getFirstLetter(String appName) {
    return appName[0].toUpperCase();
  }

  // battery status
  void getBatteryPercentage() async {
    final batteryLevel = await battery.batteryLevel;
    bLevel = batteryLevel;
    setState(() {});
  }

  // clears uninstalled app
  void removeUninstalledApp(String packageName) {
    setState(() {
      appops.searchAppList.removeWhere((app) => app.packageName == packageName);
    });
  }

  void addToDock(appls) {
    if (dockIconList.length != 4 && !dockIconList.contains(appls)) {
      appops.addAppToDock(appls.appName);
      setState(() {
        dockIconList = appops.docklistitems;
        debugPrint(dockIconList.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // themeTextColor = Theme.of(context).textTheme.bodyLarge!.color!;
    // themeBackground = Theme.of(context).scaffoldBackgroundColor;
    final ThemeData currentTheme = Theme.of(context);
    bool sysBrightness = currentTheme.brightness == Brightness.dark;
    Color themeTextColor = Theme.of(context).textTheme.bodyLarge!.color!;
    // Color themeBackground = Theme.of(context).scaffoldBackgroundColor;

    return WillPopScope(
      onWillPop: () async {
        // Disable back button functionality
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onVerticalDragEnd: (details) async {
              // Check if the user swiped up
              if (details.velocity.pixelsPerSecond.dy > 0) {
                // User swiped Down
                // StatusBarManager.expandNotificationsPanel();
                _showNotificationPanel();
              }
              if (details.velocity.pixelsPerSecond.dy < 0) {
                // User swiped up
                // appops.searchApp('phone');
                // appops.openApps(appops.searchAppList[0]);
                // loadApps();

                // Uri phoneNumber = Uri.parse('tel:');

                // if (await canLaunchUrl(phoneNumber)) {
                //   await launchUrl(phoneNumber);
                // } else {
                //   throw 'Could not launch phone app';
                // }

                // Display Drawer
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    // shape: const ContinuousRectangleBorder(),
                    // backgroundColor: Colors.transparent,
                    // barrierColor: Colors.transparent,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return CustomModalBottomSheet(
                            textEditingController: _textEditingController,
                            appops: appops,
                            sysBrightness: sysBrightness,
                            themeTextColor: themeTextColor,
                            addToDock: addToDock,
                            clearText: _clearText,
                            getFirstLetter: getFirstLetter,
                            loadApps: loadApps,
                            dockIconList: dockIconList,
                            setIcon: shouldShowIcons,
                          );
                        },
                      );
                    });
              }
            },

            // onHorizontalDragUpdate: (details) {
            //   // Check if the user swiped right
            //   if (details.delta.dx > 0) {
            //     // User swiped right
            //     print('swipe right');
            //     appops.searchApp('camera');
            //     appops.openApps(appops.searchAppList[0]);
            //     loadApps();
            //   }
            // },
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: sysBrightness ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsPage(
                                          dIconSize: dIconSize,
                                          showIcons: shouldShowIcons,
                                          showClock: shouldShowClock,
                                          showDate: shouldShowDate,
                                          showDayProgress: shouldShowDayProgress,
                                          showTodo: shouldShowTodo,
                                          setTheme: widget.setTheme,
                                          onShowIconsChanged: (bool value) {
                                            shouldShowIcons = value;
                                          },
                                          onThemeChanged: widget.onThemeChanged,
                                          onDIconSizeChanged: (int value) {
                                            setState(() {
                                              dIconSize = value;
                                            });
                                          },
                                          onShowClockChanged: (bool value) {
                                            setState(() {
                                              shouldShowClock = value;
                                            });
                                          },
                                          onShowDateChanged: (bool value) {
                                            setState(() {
                                              shouldShowDate = value;
                                            });
                                          },
                                          onShowDayProgressChanged: (bool value) {
                                            setState(() {
                                              shouldShowDayProgress = value;
                                            });
                                          },
                                          onShowTodoChanged: (bool value) {
                                            setState(() {
                                              shouldShowTodo = value;
                                            });
                                          },
                                        )),
                              );
                            },
                            child: ListTile(
                              leading: const Icon(Icons.settings_outlined),
                              title: Text(
                                "Launchy Settings",
                                style: TextStyle(color: themeTextColor),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.pop(context);
                            },
                            child: ListTile(
                              leading: const Icon(Icons.wallpaper),
                              title: Text(
                                "Wallpaper",
                                style: TextStyle(color: themeTextColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: CustomPageView(
                  onShowIconsChanged: (bool value) {
                    shouldShowIcons = value;
                  },
                  onDIconSizeChanged: (int value) {
                    setState(() {
                      dIconSize = value;
                    });
                  },
                  onShowClockChanged: (bool value) {
                    setState(() {
                      shouldShowClock = value;
                    });
                  },
                  onShowDateChanged: (bool value) {
                    setState(() {
                      shouldShowDate = value;
                    });
                  },
                  onShowDayProgressChanged: (bool value) {
                    setState(() {
                      shouldShowDayProgress = value;
                    });
                  },
                  onShowTodoChanged: (bool value) {
                    setState(() {
                      shouldShowTodo = value;
                    });
                  },
                  dIconSize: dIconSize,
                  dockIconList: dockIconList,
                  appops: appops,
                  sysBrightness: sysBrightness,
                  themeTextColor: themeTextColor,
                  setTheme: widget.setTheme,
                  onThemeChanged: widget.onThemeChanged,
                  showIcons: shouldShowIcons,
                  showClock: shouldShowClock,
                  showDate: shouldShowDate,
                  showDayProgress: shouldShowDayProgress,
                  showTodo: shouldShowTodo,
                )),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

Widget renderGrids(BuildContext context) {
  final grids = SliverGrid(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
    ),
    delegate: SliverChildListDelegate(
      [
        Container(),
      ],
    ),
  );
  return grids;
}