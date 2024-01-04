import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/constants/themes/theme_const.dart';
import 'package:flutter_launcher/modules/app_helper.dart';
import 'package:flutter_launcher/pages/settings.dart';
import 'package:flutter_launcher/widgets/home_widgets/day_progress_widget.dart';
import 'package:flutter_launcher/widgets/home_widgets/digital_clock_widget.dart';
import 'package:flutter_launcher/widgets/home_widgets/full_date_widget.dart';
import 'package:flutter_launcher/widgets/home_widgets/todo_widget.dart';
import 'package:provider/provider.dart';

class CustomPageView extends StatefulWidget {
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
  final List<Application> dockIconList;
  final AppOps appops;
  final bool sysBrightness;
  final Color themeTextColor;

  const CustomPageView({
    super.key,
    required this.dIconSize,
    required this.dockIconList,
    required this.appops,
    required this.sysBrightness,
    required this.themeTextColor,
    required this.setTheme,
    required this.onThemeChanged,
    required this.showIcons,
    required this.showClock,
    required this.showDate,
    required this.showDayProgress,
    required this.showTodo,
    required this.onShowIconsChanged,
    required this.onShowClockChanged,
    required this.onShowDateChanged,
    required this.onShowDayProgressChanged,
    required this.onShowTodoChanged,
    required this.onDIconSizeChanged,
  });

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  //  settings parametere
  late bool showIcons;
  late bool showClock;
  late bool showDate;
  late bool showDayProgress;
  late bool showTodo;
  late String setTheme;
  late int dIconSize;

  final GlobalKey containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    showIcons = widget.showIcons;
    showClock = widget.showClock;
    showDate = widget.showDate;
    showDayProgress = widget.showDayProgress;
    showTodo = widget.showTodo;
    dIconSize = widget.dIconSize;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData currentTheme = Theme.of(context);
    bool sysBrightness = currentTheme.brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: sysBrightness ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ));
    return PageView(
        // physics: const ClampingScrollPhysics(),
        // physics: const BouncingScrollPhysics(),
        // scrollDirection: Axis.horizontal,
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
                    margin: const EdgeInsetsDirectional.only(top: 80, start: 20, end: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Digital clock widget
                        widget.showClock ? const DigitalClockWidget() : const SizedBox(),
                        widget.showDate ? const FullDateWidget() : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                        // Display date widget
                        widget.showDayProgress ? const DayProgressWidget() : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                        // Displays Todo widget
                        widget.showTodo ? SizedBox(height: 300, key: containerKey, child: const TodoList()) : const SizedBox(),
                        // const SizedBox(
                        //   height: 100,
                        //   width: 100,
                        //   child: RiveAnimation.asset(
                        //       'assets/notification.riv'),
                        // )
                      ],
                    ),
                  ),
                  // dock home page
                  Provider.of<AppOps>(context).dockListItems.isNotEmpty && Provider.of<AppOps>(context).dockListItems.length <= 4
                      ? Container(
                          key: UniqueKey(),
                          height: 80,
                          margin: EdgeInsets.only(
                            bottom: MediaQueryData.fromView(View.of(context)).padding.bottom,
                          ),
                          // margin: const EdgeInsets.all(30),
                          decoration: const BoxDecoration(
                              // color: themeTextColor.withOpacity(0.5),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              systemAccentColor,
                              BlendMode.modulate,
                            ),
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.matrix(
                                  <double>[0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: List<Widget>.generate(
                                    Provider.of<AppOps>(context).dockListItems.length <= 4 ? Provider.of<AppOps>(context).dockListItems.length : 4,
                                    (index) {
                                  return GestureDetector(
                                      onLongPress: () {
                                        showModalBottomSheet(
                                          context: context,
                                          // backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                bottom: MediaQueryData.fromView(View.of(context)).padding.bottom,
                                              ),
                                              decoration: const BoxDecoration(
                                                // color: widget.sysBrightness ? Colors.grey[900] : Colors.grey[100],
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
                                                        final AndroidIntent intent = AndroidIntent(
                                                          action: 'action_application_details_settings',
                                                          data: 'package:${widget.dockIconList[index].packageName}',
                                                        );
                                                        Navigator.of(context).pop();
                                                        await intent.launch();
                                                      },
                                                      child: ListTile(
                                                        leading: const Icon(Icons.info_outline),
                                                        title: Text(
                                                          "App Info",
                                                          style: TextStyle(color: widget.themeTextColor),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          widget.dockIconList.removeAt(index);
                                                        });
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: ListTile(
                                                        leading: const Icon(Icons.remove_circle_outline),
                                                        title: Text(
                                                          "Remove",
                                                          style: TextStyle(color: widget.themeTextColor),
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
                                                              builder: (context) => SettingsPage(
                                                                    showClock: showClock,
                                                                    showDate: showDate,
                                                                    showDayProgress: showDayProgress,
                                                                    showTodo: showTodo,
                                                                    dIconSize: widget.dIconSize,
                                                                    showIcons: showIcons,
                                                                    setTheme: widget.setTheme,
                                                                    onShowIconsChanged: (bool value) {
                                                                      showIcons = value;
                                                                    },
                                                                    onThemeChanged: widget.onThemeChanged,
                                                                    onDIconSizeChanged: (value) {
                                                                      setState(() {
                                                                        dIconSize = value;
                                                                      });
                                                                    },
                                                                    onShowClockChanged: (bool value) {
                                                                      setState(() {
                                                                        showClock = value;
                                                                      });
                                                                    },
                                                                    onShowDateChanged: (bool value) {
                                                                      setState(() {
                                                                        showDate = value;
                                                                      });
                                                                    },
                                                                    onShowDayProgressChanged: (bool value) {
                                                                      setState(() {
                                                                        showDayProgress = value;
                                                                      });
                                                                    },
                                                                    onShowTodoChanged: (bool value) {
                                                                      setState(() {
                                                                        showTodo = value;
                                                                      });
                                                                    },
                                                                  )),
                                                        );
                                                      },
                                                      child: ListTile(
                                                        leading: const Icon(Icons.settings_outlined),
                                                        title: Text(
                                                          "Launchy Settings",
                                                          style: TextStyle(color: widget.themeTextColor),
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
                                        widget.appops.openApps(widget.dockIconList[index]);
                                      },
                                      child: Image.memory(
                                        (widget.dockIconList[index] as ApplicationWithIcon).icon,
                                        key: UniqueKey(),
                                        width: widget.dIconSize.toDouble(),
                                      ));
                                }),
                              ),
                            ),
                          ))
                      : const SizedBox(),
                ],
              )),
        ]);
  }
}
