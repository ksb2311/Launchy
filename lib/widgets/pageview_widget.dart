import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/constants/themes/theme_const.dart';
import 'package:flutter_launcher/modules/app_helper.dart';
import 'package:flutter_launcher/pages/settings.dart';
import 'package:flutter_launcher/widgets/home_widgets.dart';
import 'package:flutter_launcher/widgets/todo_widget.dart';

class CustomPageView extends StatefulWidget {
  final Function(String) onThemeChanged;
  final bool shouldShowClock;
  final bool shouldShowDate;
  final bool shouldShowDayProgress;
  final bool shouldShowTodo;
  final bool shouldShowIcons;
  final int dIconSize;
  final List<Application> dockIconList;
  final AppOps appops;
  final bool sysBrightness;
  final Color themeTextColor;
  final String setTheme;

  const CustomPageView({
    super.key,
    required this.shouldShowClock,
    required this.shouldShowDate,
    required this.shouldShowDayProgress,
    required this.shouldShowTodo,
    required this.dIconSize,
    required this.dockIconList,
    required this.appops,
    required this.sysBrightness,
    required this.themeTextColor,
    required this.shouldShowIcons,
    required this.setTheme,
    required this.onThemeChanged,
  });

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  //  settings parametere
  late bool shouldShowIcons = widget.shouldShowIcons;
  late bool shouldShowClock = widget.shouldShowClock;
  late bool shouldShowDate = widget.shouldShowDate;
  late bool shouldShowDayProgress = widget.shouldShowDayProgress;
  late bool shouldShowTodo = widget.shouldShowTodo;
  late int dIconSize;

  @override
  Widget build(BuildContext context) {
    return PageView(
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
                    margin: const EdgeInsetsDirectional.only(top: 80, start: 20, end: 20, bottom: 20),
                    child: StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)).asBroadcastStream(),
                        builder: (context, snapshot) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              widget.shouldShowClock ? const DigitalClockWidget() : const SizedBox(),
                              widget.shouldShowDate ? const FullDateWidget() : const SizedBox(),
                              const SizedBox(
                                height: 20,
                              ),
                              // Display date widget
                              widget.shouldShowDayProgress ? const DayProgressWidget() : const SizedBox(),
                              const SizedBox(
                                height: 20,
                              ),
                              // Displays Todo widget
                              widget.shouldShowTodo ? const SizedBox(height: 300, child: TodoList()) : const SizedBox(),
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
                  widget.dockIconList.isNotEmpty && widget.dockIconList.length <= 4
                      ? Container(
                          key: UniqueKey(),
                          height: 80,
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
                              colorFilter: const ColorFilter.matrix(<double>[
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0.2126,
                                0.7152,
                                0.0722,
                                0,
                                0,
                                0,
                                0,
                                0,
                                1,
                                0,
                              ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List<Widget>.generate(widget.dockIconList.length <= 4 ? widget.dockIconList.length : 4, (index) {
                                  return GestureDetector(
                                      onLongPress: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: widget.sysBrightness ? Colors.grey[900] : Colors.grey[100],
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
                                                                    showClock: widget.shouldShowClock,
                                                                    showDate: widget.shouldShowDate,
                                                                    showDayProgress: widget.shouldShowDayProgress,
                                                                    showTodo: widget.shouldShowTodo,
                                                                    dIconSize: widget.dIconSize,
                                                                    showIcons: widget.shouldShowIcons,
                                                                    setTheme: widget.setTheme,
                                                                    onShowIconsChanged: (bool value) {
                                                                      shouldShowIcons = value;
                                                                    },
                                                                    onThemeChanged: widget.onThemeChanged,
                                                                    onDIconSizeChanged: (value) {
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
                  // Container(
                  //   color: Colors.amber,
                  //   height: 80,
                  //   width: double.infinity,
                  //   alignment: Alignment.center,
                  //   child: ListView.builder(
                  //     itemCount: dockIconList.length,
                  //     shrinkWrap: true,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return dockIconList.isNotEmpty
                  //           ? GestureDetector(
                  //               onTap: () {
                  //                 appops
                  //                     .openApps(dockIconList[index]);
                  //               },
                  //               child: Image.memory(
                  //                 (dockIconList[index]
                  //                         as ApplicationWithIcon)
                  //                     .icon,
                  //                 width: dIconSize.toDouble(),
                  //               ))
                  //           : const SizedBox();
                  //     },
                  //   ),
                  // )
                ],
              )),
        ]);
  }
}
