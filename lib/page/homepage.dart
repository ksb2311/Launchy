import 'dart:ui';

import 'package:android_intent_plus/android_intent.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/operations/appops.dart';
import 'package:flutter_launcher/page/settings/settings.dart';
import 'package:flutter_launcher/widgets/home_widgets.dart';
import 'package:flutter_launcher/widgets/todo_widget.dart';
import 'package:flutter_launcher/themes.dart';

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
  List<Application> dockIconList = [];
  List<Application> preAppList = [];

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
  final ScrollController _scrollController = ScrollController();

  final List<String> alphabets = List.generate(
      26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

  // final double _itemExtent = 100;

  // int _currentIndex = 0;

// battery parameters
  var battery = Battery();
  int bLevel = 0;
// expands notification panel
  final MethodChannel _channel = const MethodChannel('my_channel');

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
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.clear();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // Handle the app being uninstalled
      // Perform the necessary list update here
      // Example: delete all items from the `todoItems` list

      setState(() {
        appops.searchAppList.clear();
        loadApps();
      });
    }
  }

  // displays notification panel
  void _showNotificationPanel() {
    _channel.invokeMethod('showNotificationPanel');
  }

  // creating list of installed apps
  Future<void> loadApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true);

    apps.sort(
        (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

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

  @override
  Widget build(BuildContext context) {
    themeTextColor = Theme.of(context).textTheme.bodyLarge!.color!;
    themeBackground = Theme.of(context).scaffoldBackgroundColor;
    final ThemeData currentTheme = Theme.of(context);

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
          resizeToAvoidBottomInset: true,
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
                    shape: const ContinuousRectangleBorder(),
                    // backgroundColor: Colors.transparent,
                    builder: (context) {
                      return GestureDetector(
                        onTap: (() => FocusScope.of(context).unfocus()),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQueryData.fromView(View.of(context))
                                .padding
                                .top,
                            left: 10,
                            right: 10,
                          ),
                          child: StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return DraggableScrollableSheet(
                                  initialChildSize: 1.0,
                                  minChildSize: 0.99,
                                  maxChildSize: 1.0,
                                  expand: true,
                                  snap: true,
                                  builder: (context, scrollController) {
                                    return Column(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        // Serarch Bar in Drawer
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: TextField(
                                            controller: _textEditingController,
                                            onSubmitted: (value) {
                                              appops.openApps(
                                                  appops.searchAppList[0]);
                                            },
                                            style: TextStyle(
                                                color: themeTextColor),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      top: 15,
                                                      bottom: 15,
                                                      left: 20,
                                                      right: 20),
                                              focusColor: themeTextColor,
                                              hintText: "Search",
                                              hintStyle: TextStyle(
                                                  color: themeTextColor),
                                              filled: true,
                                              fillColor:
                                                  currentTheme.brightness ==
                                                          Brightness.dark
                                                      ? Colors.grey[900]
                                                      : Colors.grey[200],
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                borderSide: BorderSide.none,
                                              ),
                                              suffixIcon: _textEditingController
                                                          .text !=
                                                      ''
                                                  ? IconButton(
                                                      icon: const Icon(
                                                          Icons.clear),
                                                      onPressed: () {
                                                        _clearText();
                                                        setState(() {
                                                          appops.searchApp('');
                                                        });
                                                      },
                                                    )
                                                  : const Text(''),
                                              prefixIcon:
                                                  const Icon(Icons.search),
                                            ),
                                            onChanged: (String value) {
                                              setState(() {
                                                appops.searchApp(value);
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                            child: Row(
                                          children: [
                                            SizedBox(
                                              // width: MediaQuery.sizeOf(context).width - 60,
                                              width: MediaQuery.sizeOf(context)
                                                      .width -
                                                  20,
                                              child: Scrollbar(
                                                controller: scrollController,
                                                interactive: true,
                                                // thumbVisibility: true,
                                                radius:
                                                    const Radius.circular(10),
                                                // trackVisibility: true,
                                                thickness: 10,
                                                child: ListView.separated(
                                                  cacheExtent: 9999,
                                                  controller: scrollController,
                                                  itemCount: appops
                                                      .searchAppList.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final appls = appops
                                                        .searchAppList[index];
                                                    String currentLetter =
                                                        getFirstLetter(
                                                            appls.appName);

                                                    // Check if the separator should be displayed
                                                    bool
                                                        shouldDisplaySeparator =
                                                        index == 0 ||
                                                            currentLetter !=
                                                                getFirstLetter(appops
                                                                    .searchAppList[
                                                                        index -
                                                                            1]
                                                                    .appName);
                                                    return appops.searchAppList
                                                            .isNotEmpty
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                                if (shouldDisplaySeparator)
                                                                  Text(
                                                                    currentLetter,
                                                                    style: TextStyle(
                                                                        color:
                                                                            themeTextColor,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    appops.openApps(
                                                                        appls);
                                                                  },
                                                                  onLongPress:
                                                                      () {
                                                                    showModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      isScrollControlled:
                                                                          true,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: currentTheme.brightness == Brightness.dark
                                                                                ? Colors.grey[800]
                                                                                : Colors.grey[100],
                                                                            borderRadius:
                                                                                const BorderRadius.only(
                                                                              topLeft: Radius.circular(20),
                                                                              topRight: Radius.circular(20),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(16),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.all(10),
                                                                                  decoration: BoxDecoration(color: currentTheme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200], borderRadius: BorderRadius.circular(30)),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      Image.memory(
                                                                                        (appls as ApplicationWithIcon).icon,
                                                                                        width: 42,
                                                                                        height: 42,
                                                                                        // cacheHeight: 42,
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                      Text(appls.appName),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: 16),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    if (dockIconList.length != 4 && !dockIconList.contains(appls)) {
                                                                                      setState(() {
                                                                                        appops.addAppToDock(appls.appName);
                                                                                        dockIconList = appops.docklistitems;
                                                                                      });
                                                                                    }
                                                                                    debugPrint(dockIconList.toString());
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: ListTile(
                                                                                    leading: const Icon(Icons.add_circle_outline),
                                                                                    title: Text(
                                                                                      dockIconList.length != 4 ? "Add to Dock" : "Dock is Full",
                                                                                      style: TextStyle(color: themeTextColor),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    Navigator.of(context).pop();
                                                                                    final AndroidIntent intent = AndroidIntent(
                                                                                      action: 'action_application_details_settings',
                                                                                      data: 'package:${appls.packageName}',
                                                                                    );

                                                                                    await intent.launch();
                                                                                  },
                                                                                  child: ListTile(
                                                                                    leading: const Icon(Icons.info_outline),
                                                                                    title: Text(
                                                                                      "App Info",
                                                                                      style: TextStyle(color: themeTextColor),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () async {
                                                                                    Navigator.of(context).pop();
                                                                                    await DeviceApps.uninstallApp(appls.packageName);
                                                                                    // removeUninstalledApp(appls.packageName);
                                                                                  },
                                                                                  child: ListTile(
                                                                                    leading: const Icon(Icons.remove_circle_outline),
                                                                                    title: Text(
                                                                                      "Uninstall",
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
                                                                  child: shouldShowIcons
                                                                      ? ListTile(
                                                                          leading:
                                                                              Image.memory(
                                                                            (appls as ApplicationWithIcon).icon,
                                                                            width:
                                                                                42,
                                                                          ),
                                                                          title:
                                                                              Text(
                                                                            appls.appName,
                                                                            style:
                                                                                TextStyle(color: themeTextColor),
                                                                          ),
                                                                        )
                                                                      : ListTile(
                                                                          title:
                                                                              Text(
                                                                            appls.appName,
                                                                            style:
                                                                                TextStyle(color: themeTextColor),
                                                                          ),
                                                                        ),
                                                                ),
                                                              ])
                                                        : const CircularProgressIndicator();
                                                  },
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return const SizedBox
                                                        .shrink(); // Return an empty separator when the letter doesn't change
                                                    // }
                                                    // }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
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
                      color: currentTheme.brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[100],
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
                                          showDayProgress:
                                              shouldShowDayProgress,
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
                                          onShowDayProgressChanged:
                                              (bool value) {
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
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: PageView(
                  // physics: const ClampingScrollPhysics(),
                  // physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    // HomePage
                    Container(
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsetsDirectional.only(
                                  top: 80, start: 20, end: 20, bottom: 20),
                              child: StreamBuilder(
                                  stream: Stream.periodic(
                                          const Duration(seconds: 1))
                                      .asBroadcastStream(),
                                  builder: (context, snapshot) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Row(
                                        //   crossAxisAlignment: CrossAxisAlignment.end,
                                        //   children: [
                                        //     bLevel == 100
                                        //         ? const Icon(
                                        //             Icons.battery_std_rounded)
                                        //         : bLevel >= 90
                                        //             ? const Icon(
                                        //                 Icons.battery_6_bar_rounded)
                                        //             : bLevel >= 70
                                        //                 ? const Icon(Icons
                                        //                     .battery_5_bar_rounded)
                                        //                 : bLevel >= 50
                                        //                     ? const Icon(Icons
                                        //                         .battery_4_bar_rounded)
                                        //                     : bLevel >= 30
                                        //                         ? const Icon(Icons
                                        //                             .battery_3_bar_rounded)
                                        //                         : bLevel >= 20
                                        //                             ? const Icon(Icons
                                        //                                 .battery_2_bar_rounded)
                                        //                             : bLevel >= 10
                                        //                                 ? const Icon(Icons
                                        //                                     .battery_1_bar_rounded)
                                        //                                 : const Icon(Icons
                                        //                                     .battery_0_bar_rounded),
                                        //     Text(
                                        //       " $bLevel",
                                        //       style: TextStyle(color: themeTextColor),
                                        //     ),
                                        //   ],
                                        // ),
                                        // Digital clock widget
                                        shouldShowClock
                                            ? const DigitalClockWidget()
                                            : const SizedBox(),
                                        shouldShowDate
                                            ? const FullDateWidget()
                                            : const SizedBox(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        // Display date widget
                                        shouldShowDayProgress
                                            ? const DayProgressWidget()
                                            : const SizedBox(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        // Displays Todo widget
                                        shouldShowTodo
                                            ? const SizedBox(
                                                height: 300, child: TodoList())
                                            : const SizedBox(),
                                        // const SizedBox(
                                        //   height: 100,
                                        //   width: 100,
                                        //   child: RiveAnimation.asset(
                                        //       'assets/notification.riv'),
                                        // )
                                      ],
                                    );
                                  }),
                            ),
                            // dock home page
                            Container(
                              height: 80,
                              margin: const EdgeInsets.all(30),
                              // decoration: const BoxDecoration(
                              //     color: themeTextColor60,
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List<Widget>.generate(
                                    dockIconList.length <= 4
                                        ? dockIconList.length
                                        : 4, (index) {
                                  return dockIconList.isNotEmpty &&
                                          dockIconList.length <= 4
                                      ? GestureDetector(
                                          onLongPress: () {
                                            showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: currentTheme
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.grey[800]
                                                        : Colors.grey[100],
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            final AndroidIntent
                                                                intent =
                                                                AndroidIntent(
                                                              action:
                                                                  'action_application_details_settings',
                                                              data:
                                                                  'package:${dockIconList[index].packageName}',
                                                            );
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            await intent
                                                                .launch();
                                                          },
                                                          child: ListTile(
                                                            leading: const Icon(
                                                                Icons
                                                                    .info_outline),
                                                            title: Text(
                                                              "App Info",
                                                              style: TextStyle(
                                                                  color:
                                                                      themeTextColor),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            setState(() {
                                                              dockIconList
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: ListTile(
                                                            leading: const Icon(
                                                                Icons
                                                                    .remove_circle_outline),
                                                            title: Text(
                                                              "Remove",
                                                              style: TextStyle(
                                                                  color:
                                                                      themeTextColor),
                                                            ),
                                                          ),
                                                        ),
                                                        const Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          SettingsPage(
                                                                            showClock:
                                                                                shouldShowClock,
                                                                            showDate:
                                                                                shouldShowDate,
                                                                            showDayProgress:
                                                                                shouldShowDayProgress,
                                                                            showTodo:
                                                                                shouldShowTodo,
                                                                            dIconSize:
                                                                                dIconSize,
                                                                            showIcons:
                                                                                shouldShowIcons,
                                                                            setTheme:
                                                                                widget.setTheme,
                                                                            onShowIconsChanged:
                                                                                (bool value) {
                                                                              shouldShowIcons = value;
                                                                            },
                                                                            onThemeChanged:
                                                                                widget.onThemeChanged,
                                                                            onDIconSizeChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                dIconSize = value;
                                                                              });
                                                                            },
                                                                            onShowClockChanged:
                                                                                (bool value) {
                                                                              setState(() {
                                                                                shouldShowClock = value;
                                                                              });
                                                                            },
                                                                            onShowDateChanged:
                                                                                (bool value) {
                                                                              setState(() {
                                                                                shouldShowDate = value;
                                                                              });
                                                                            },
                                                                            onShowDayProgressChanged:
                                                                                (bool value) {
                                                                              setState(() {
                                                                                shouldShowDayProgress = value;
                                                                              });
                                                                            },
                                                                            onShowTodoChanged:
                                                                                (bool value) {
                                                                              setState(() {
                                                                                shouldShowTodo = value;
                                                                              });
                                                                            },
                                                                          )),
                                                            );
                                                          },
                                                          child: ListTile(
                                                            leading: const Icon(
                                                                Icons
                                                                    .settings_outlined),
                                                            title: Text(
                                                              "Launchy Settings",
                                                              style: TextStyle(
                                                                  color:
                                                                      themeTextColor),
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
                                          onTap: () {
                                            appops
                                                .openApps(dockIconList[index]);
                                          },
                                          child: Image.memory(
                                            (dockIconList[index]
                                                    as ApplicationWithIcon)
                                                .icon,
                                            width: dIconSize.toDouble(),
                                          ))
                                      : Icon(
                                          Icons.add,
                                          color: themeTextColor,
                                        );
                                }),
                              ),
                            ),
                          ],
                        )),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
