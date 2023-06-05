import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/operations/appops.dart';
import 'package:flutter_launcher/page/settings/settings.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final Function(String) onThemeChanged;
  final String setTheme;
  final bool setIcon;
  final bool setClock;
  final bool setDate;
  final bool setDayProgress;
  final int dIconSize;
  const HomePage(
      {Key? key,
      required this.onThemeChanged,
      required this.setTheme,
      required this.setIcon,
      required this.dIconSize,
      required this.setClock,
      required this.setDate,
      required this.setDayProgress})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Application> listApps = AppOps().searchAppList;
  final appops = AppOps();
  List<Application> dockIconList = [];
  List<Application> preAppList = [];

  Color themeTextColor = Colors.black;
  Color themeBackground = Colors.white;

  final _textEditingController = TextEditingController();

  late bool shouldShowIcons;
  late bool shouldShowClock;
  late bool shouldShowDate;
  late bool shouldShowDayProgress;
  late int dIconSize;

  final ScrollController _scrollController = ScrollController();

  final List<String> alphabets = List.generate(
      26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

  final double _itemExtent = 100;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadApps();
    shouldShowIcons = widget.setIcon;
    shouldShowClock = widget.setClock;
    shouldShowDate = widget.setDate;
    shouldShowDayProgress = widget.setDayProgress;
    dIconSize = widget.dIconSize;
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.clear();
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

// Gettinng first letter of appname
  String getFirstLetter(String appName) {
    return appName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    themeTextColor = Theme.of(context).textTheme.bodyLarge!.color!;
    themeBackground = Theme.of(context).scaffoldBackgroundColor;
    final ThemeData currentTheme = Theme.of(context);

    DateTime now = DateTime.now();
    int hours = now.hour;
    int minutes = now.minute;
    int seconds = now.second;

    int totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
    double progress = totalSeconds / 86400;

    return Scaffold(
      backgroundColor: themeBackground,
      body: GestureDetector(
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
                                      showDayProgress: shouldShowDayProgress,
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
        child: PageView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
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
                            stream: Stream.periodic(const Duration(seconds: 1))
                                .asBroadcastStream(),
                            builder: (context, snapshot) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  shouldShowClock
                                      ? Row(
                                          children: [
                                            Text(
                                              // DateFormat('MM/dd/yyyy hh:mm:ss')
                                              DateFormat('hh')
                                                  .format(DateTime.now()),
                                              style: TextStyle(
                                                color: themeTextColor,
                                                fontSize: 50,
                                              ),
                                            ),
                                            Text(
                                              // DateFormat('MM/dd/yyyy hh:mm:ss')
                                              DateFormat(':mm a')
                                                  .format(DateTime.now()),
                                              style: TextStyle(
                                                  color: themeTextColor,
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  shouldShowDate
                                      ? Text(
                                          // DateFormat('MM/dd/yyyy hh:mm:ss')
                                          DateFormat('E dd MMM yyyy')
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                            color: themeTextColor,
                                            fontSize: 20,
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  shouldShowDayProgress
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Text(
                                                  'Day Progress ${(progress / 1 * 100).floor()} %'),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              LinearProgressIndicator(
                                                value: progress,
                                                backgroundColor: Colors.grey,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(themeTextColor),
                                              ),
                                            ])
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: currentTheme.brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey[800]
                                                  : Colors.grey[100],
                                              borderRadius:
                                                  const BorderRadius.only(
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
                                                      final AndroidIntent
                                                          intent =
                                                          AndroidIntent(
                                                        action:
                                                            'action_application_details_settings',
                                                        data:
                                                            'package:${dockIconList[index].packageName}',
                                                      );
                                                      Navigator.of(context)
                                                          .pop();
                                                      await intent.launch();
                                                    },
                                                    child: ListTile(
                                                      leading: const Icon(
                                                          Icons.info_outline),
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
                                                            .removeAt(index);
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: ListTile(
                                                      leading: const Icon(Icons
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
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SettingsPage(
                                                                  showClock:
                                                                      shouldShowClock,
                                                                  showDate:
                                                                      shouldShowDate,
                                                                  showDayProgress:
                                                                      shouldShowDayProgress,
                                                                  dIconSize:
                                                                      dIconSize,
                                                                  showIcons:
                                                                      shouldShowIcons,
                                                                  setTheme: widget
                                                                      .setTheme,
                                                                  onShowIconsChanged:
                                                                      (bool
                                                                          value) {
                                                                    shouldShowIcons =
                                                                        value;
                                                                  },
                                                                  onThemeChanged:
                                                                      widget
                                                                          .onThemeChanged,
                                                                  onDIconSizeChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      dIconSize =
                                                                          value;
                                                                    });
                                                                  },
                                                                  onShowClockChanged:
                                                                      (bool
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      shouldShowClock =
                                                                          value;
                                                                    });
                                                                  },
                                                                  onShowDateChanged:
                                                                      (bool
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      shouldShowDate =
                                                                          value;
                                                                    });
                                                                  },
                                                                  onShowDayProgressChanged:
                                                                      (bool
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      shouldShowDayProgress =
                                                                          value;
                                                                    });
                                                                  },
                                                                )),
                                                      );
                                                    },
                                                    child: ListTile(
                                                      leading: const Icon(Icons
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
                                      appops.openApps(dockIconList[index]);
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
              GestureDetector(
                onTap: (() => FocusScope.of(context).unfocus()),
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 50, left: 10, right: 10, bottom: 10),
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width - 50,
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: _scrollController,
                              // scrollDirection: Axis.horizontal,
                              scrollbarOrientation: ScrollbarOrientation.right,
                              interactive: true,
                              child: ListView.separated(
                                cacheExtent: 9999,
                                controller: _scrollController,
                                itemCount: appops.searchAppList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final appls = appops.searchAppList[index];
                                  String currentLetter =
                                      getFirstLetter(appls.appName);

                                  // Check if the separator should be displayed
                                  bool shouldDisplaySeparator = index == 0 ||
                                      currentLetter !=
                                          getFirstLetter(appops
                                              .searchAppList[index - 1]
                                              .appName);
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (shouldDisplaySeparator)
                                          Text(
                                            currentLetter,
                                            style: TextStyle(
                                                color: themeTextColor,
                                                fontSize: 18),
                                          ),
                                        GestureDetector(
                                          onTap: () {
                                            appops.openApps(appls);
                                          },
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
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration: BoxDecoration(
                                                              color: currentTheme
                                                                          .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors
                                                                      .grey[900]
                                                                  : Colors.grey[
                                                                      200],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.memory(
                                                                (appls as ApplicationWithIcon)
                                                                    .icon,
                                                                width: 42,
                                                                height: 42,
                                                                // cacheHeight: 42,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(appls
                                                                  .appName),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (dockIconList
                                                                    .length !=
                                                                4) {
                                                              setState(() {
                                                                appops.addAppToDock(
                                                                    appls
                                                                        .appName);
                                                                dockIconList =
                                                                    appops
                                                                        .docklistitems;
                                                              });
                                                            }
                                                            debugPrint(
                                                                dockIconList
                                                                    .toString());
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: ListTile(
                                                            leading: const Icon(
                                                                Icons
                                                                    .add_circle_outline),
                                                            title: Text(
                                                              dockIconList.length !=
                                                                      4
                                                                  ? "Add to Dock"
                                                                  : "Dock is Full",
                                                              style: TextStyle(
                                                                  color:
                                                                      themeTextColor),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            final AndroidIntent
                                                                intent =
                                                                AndroidIntent(
                                                              action:
                                                                  'action_application_details_settings',
                                                              data:
                                                                  'package:${appls.packageName}',
                                                            );

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
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            await DeviceApps
                                                                .uninstallApp(appls
                                                                    .packageName);
                                                          },
                                                          child: ListTile(
                                                            leading: const Icon(
                                                                Icons
                                                                    .remove_circle_outline),
                                                            title: Text(
                                                              "Uninstall",
                                                              style: TextStyle(
                                                                  color:
                                                                      themeTextColor),
                                                            ),
                                                          ),
                                                        ),
                                                        // const Divider(
                                                        //   color: Colors.grey,
                                                        // ),
                                                        // GestureDetector(
                                                        //   onTap: () async {
                                                        //     Navigator.pop(context);
                                                        //     Navigator.push(
                                                        //       context,
                                                        //       MaterialPageRoute(
                                                        //           builder: (context) =>
                                                        //               SettingsPage(
                                                        //                   showIcons:
                                                        //                       shouldShowIcons,
                                                        //                   onShowIconsChanged:
                                                        //                       (bool
                                                        //                           value) {
                                                        //                     shouldShowIcons =
                                                        //                         value;
                                                        //                   },
                                                        //                   onThemeChanged:
                                                        //                       widget
                                                        //                           .onThemeChanged)),
                                                        //     );
                                                        //   },
                                                        //   child: ListTile(
                                                        //     leading: const Icon(Icons
                                                        //         .settings_outlined),
                                                        //     title: Text(
                                                        //       "Launchy Settings",
                                                        //       style: TextStyle(
                                                        //           color:
                                                        //               themeTextColor),
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: shouldShowIcons
                                              ? ListTile(
                                                  leading: Image.memory(
                                                    (appls as ApplicationWithIcon)
                                                        .icon,
                                                    width: 42,
                                                  ),
                                                  title: Text(
                                                    appls.appName,
                                                    style: TextStyle(
                                                        color: themeTextColor),
                                                  ),
                                                )
                                              : ListTile(
                                                  title: Text(
                                                    appls.appName,
                                                    style: TextStyle(
                                                        color: themeTextColor),
                                                  ),
                                                ),
                                        ),
                                      ]);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  // if (index == 0) {
                                  //   print(getFirstLetter(
                                  //       appops.searchAppList[index].appName));
                                  //   return Text(
                                  //     getFirstLetter(
                                  //         appops.searchAppList[index].appName),
                                  //     style: TextStyle(color: themeTextColor),
                                  //   );
                                  // } else {
                                  //   String currentLetter = getFirstLetter(
                                  //       appops.searchAppList[index].appName);
                                  //   String previousLetter = getFirstLetter(
                                  //       appops.searchAppList[index - 1].appName);
                                  //   if (currentLetter != previousLetter) {
                                  //     return Text(
                                  //       currentLetter,
                                  //       style: const TextStyle(color: themeTextColor),
                                  //     );
                                  //   } else {
                                  return const SizedBox
                                      .shrink(); // Return an empty separator when the letter doesn't change
                                  // }
                                  // }
                                },
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              alphabets.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                  _scrollToItemStartingWith(
                                      alphabets[_currentIndex]);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child: Text(
                                    alphabets[index],
                                    style: TextStyle(
                                      fontWeight: _currentIndex == index
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                      TextField(
                        onSubmitted: (value) {
                          appops.openApps(appops.searchAppList[0]);
                        },
                        style: TextStyle(color: themeTextColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 15, bottom: 15, left: 20, right: 20),
                          focusColor: themeTextColor,
                          hintText: "Search",
                          hintStyle: TextStyle(color: themeTextColor),
                          filled: true,
                          fillColor: currentTheme.brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            appops.searchApp(value);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  void _scrollToItemStartingWith(String alphabet) {
    for (int i = 0; i < appops.searchAppList.length; i++) {
      if (appops.searchAppList[i].appName.startsWith(alphabet)) {
        _scrollController.animateTo(
          i * _itemExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        // print(alphabet.characters);
        // print('alphabet.characters');
        break;
      }
    }
  }
}
