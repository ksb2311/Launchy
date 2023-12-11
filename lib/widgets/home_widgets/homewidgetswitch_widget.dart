import 'package:flutter/material.dart';
import 'package:flutter_launcher/constants/settings/settings_const.dart';

class HomeWidgetSwitch extends StatefulWidget {
  final bool setIcon;
  final bool setClock;
  final bool setDate;
  final bool setDayProgress;
  final bool setTodo;
  final int dIconSize;
  const HomeWidgetSwitch(
      {super.key,
      required this.setIcon,
      required this.setClock,
      required this.setDate,
      required this.setDayProgress,
      required this.setTodo,
      required this.dIconSize});

  @override
  State<HomeWidgetSwitch> createState() => _HomeWidgetSwitchState();
}

class _HomeWidgetSwitchState extends State<HomeWidgetSwitch> {
  // settings parametere
  late bool shouldShowIcons;
  late bool shouldShowClock;
  late bool shouldShowDate;
  late bool shouldShowDayProgress;
  late bool shouldShowTodo;
  late int dIconSize;

  @override
  Widget build(BuildContext context) {
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
                      value: shouldShowClock,
                      inactiveTrackColor: Colors.grey,
                      onChanged: (bool value) {
                        setState(() {
                          shouldShowClock = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text(dateHomeWidget),
                      value: shouldShowDate,
                      inactiveTrackColor: Colors.grey,
                      onChanged: (bool value) {
                        setState(() {
                          shouldShowDate = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text(dayprogressHomeWidget),
                      value: shouldShowDayProgress,
                      inactiveTrackColor: Colors.grey,
                      onChanged: (bool value) {
                        setState(() {
                          shouldShowDayProgress = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text(tasksHomeWidget),
                      value: shouldShowTodo,
                      inactiveTrackColor: Colors.grey,
                      onChanged: (bool value) {
                        setState(() {
                          shouldShowTodo = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ]));
  }
}
