import 'package:battery_plus/battery_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/constants/settings/settings_const.dart';
import 'package:flutter_launcher/modules/app_helper.dart';
import 'package:flutter_launcher/pages/settings.dart';
import 'package:flutter_launcher/widgets/appdrawer_widget.dart';
import 'package:flutter_launcher/widgets/pageview_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver, TickerProviderStateMixin {
  // List<Application> listApps = AppOps().searchAppList;
  late final AppOps appops;
  late final SettingsConst settingsConst;
  late List<Application> dockIconList;
  List<Application> preAppList = [];
  // AppFocusObserver appFocusObserver = AppFocusObserver();

// search textfield controller
  final _textEditingController = TextEditingController();
  late AnimationController anicontroller;

// shared preferences
  late SharedPreferences prefs;

// settings parametere
  // late String _selectedTheme = 'System Default';
  // late bool shouldShowIcons = false;
  // late bool shouldShowClock = true;
  // late bool shouldShowDate = true;
  // late bool shouldShowDayProgress = false;
  // late bool shouldShowTodo = false;
  // late int dIconSize = 48;

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
    // appops.listAllApps();
    // appops = AppOps(context);
    appops = Provider.of<AppOps>(context, listen: false);
    settingsConst = Provider.of<SettingsConst>(context, listen: false);
    dockIconList = appops.dockListItems;
    WidgetsBinding.instance.addObserver(this);
    // initPrefs();
    getBatteryPercentage();
    // Stream<ApplicationEvent> appEvents = DeviceApps.listenToAppsChanges();
    // WidgetsBinding.instance.addObserver(appFocusObserver);
    anicontroller = BottomSheet.createAnimationController(this);
    anicontroller.duration = const Duration(milliseconds: 500);
    // _selectedTheme = settingsConst.setTheme;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   appops = Provider.of<AppOps>(context, listen: false);
  //   dockIconList = appops.dockListItems;
  // }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(appFocusObserver);
    _textEditingController.clear();
    anicontroller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // void initPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   loadSettings();
  // }

  // void loadSettings() {
  //   _selectedTheme = prefs.getString('_selectedTheme') != null ? prefs.getString('_selectedTheme')! : 'System Default';
  //   shouldShowIcons = prefs.getBool('shouldShowIcons') != null ? prefs.getBool('shouldShowIcons')! : true;
  //   shouldShowClock = prefs.getBool('shouldShowClock') != null ? prefs.getBool('shouldShowClock')! : true;
  //   shouldShowDate = prefs.getBool('shouldShowDate') != null ? prefs.getBool('shouldShowDate')! : true;
  //   shouldShowDayProgress = prefs.getBool('shouldShowDayProgress') != null ? prefs.getBool('shouldShowDayProgress')! : false;
  //   shouldShowTodo = prefs.getBool('shouldShowTodo') != null ? prefs.getBool('shouldShowTodo')! : false;
  //   dIconSize = prefs.getInt('dIconSize') != null ? prefs.getInt('dIconSize')! : 48;
  // }

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
  // Future<void> loadApps() async {
  //   List<Application> apps =
  //       await DeviceApps.getInstalledApplications(includeAppIcons: true, includeSystemApps: true, onlyAppsWithLaunchIntent: true);

  //   apps.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

  //   setState(() {
  //     appops.searchAppList = apps;
  //   });
  // }

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
      appops.addAppToDock(appls.packageName);
      // setState(() {
      //   dockIconList = appops.docklistitems;
      //   debugPrint(dockIconList.toString());
      // });
    }
  }

  void openWallpaperSettings() async {
    Uri url = Uri.parse('android-settings://display');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not open the wallpaper settings';
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   systemNavigationBarColor: Colors.transparent,
    // ));
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // themeTextColor = Theme.of(context).textTheme.bodyLarge!.color!;
    // themeBackground = Theme.of(context).scaffoldBackgroundColor;
    final ThemeData currentTheme = Theme.of(context);
    bool sysBrightness = currentTheme.brightness == Brightness.dark;
    Color themeTextColor = Theme.of(context).textTheme.bodyLarge!.color!;
    // Color themeBackground = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  backgroundColor: Colors.transparent,
                  barrierColor: Theme.of(context).canvasColor,
                  elevation: 0,
                  // shape: const ContinuousRectangleBorder(),
                  // backgroundColor: sysBrightness ? drawerBackgroundDark : drawerBackgroundLight,
                  // barrierColor: Colors.transparent,
                  transitionAnimationController: anicontroller,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return AppDrawer(
                          textEditingController: _textEditingController,
                          appops: appops,
                          sysBrightness: sysBrightness,
                          themeTextColor: themeTextColor,
                          addToDock: addToDock,
                          clearText: _clearText,
                          getFirstLetter: getFirstLetter,
                          loadApps: appops.listAllApps,
                          dockIconList: dockIconList,
                        );
                      },
                    );
                  }).then((value) {
                SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light,
                  systemNavigationBarIconBrightness: Brightness.light,
                ));
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
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarIconBrightness: sysBrightness ? Brightness.light : Brightness.dark,
              systemNavigationBarIconBrightness: sysBrightness ? Brightness.light : Brightness.dark,
            ));
            showModalBottomSheet(
              context: context,
              // backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Container(
                    decoration: const BoxDecoration(
                      // color: sysBrightness ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.only(
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
                                MaterialPageRoute(builder: (context) => const SettingsPage()),
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
                          // GestureDetector(
                          //   onTap: () async {
                          //     Navigator.pop(context);
                          //     showModalBottomSheet(
                          //         // backgroundColor: Colors.transparent,
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return HomeWidgetSwitch(
                          //             setIcon: shouldShowIcons,
                          //             setClock: shouldShowClock,
                          //             setDate: shouldShowDate,
                          //             setDayProgress: shouldShowDayProgress,
                          //             setTodo: shouldShowTodo,
                          //             dIconSize: dIconSize,
                          //           );
                          //         });
                          //   },
                          //   child: ListTile(
                          //     leading: const Icon(Icons.widgets_outlined),
                          //     title: Text(
                          //       "Home Widgets",
                          //       style: TextStyle(color: themeTextColor),
                          //     ),
                          //   ),
                          // ),

                          // GestureDetector(
                          //   onTap: () async {
                          //     Navigator.pop(context);
                          //     openWallpaperSettings();
                          //   },
                          //   child: ListTile(
                          //     leading: const Icon(Icons.wallpaper),
                          //     title: Text(
                          //       "Wallpaper",
                          //       style: TextStyle(color: themeTextColor),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ).then((value) {
              SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
                systemNavigationBarIconBrightness: Brightness.light,
              ));
            });
          },
          child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: CustomPageView(
                dockIconList: dockIconList,
                appops: appops,
                sysBrightness: sysBrightness,
                themeTextColor: themeTextColor,
              )),
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
