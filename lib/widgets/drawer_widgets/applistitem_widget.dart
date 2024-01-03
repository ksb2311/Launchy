import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/modules/app_helper.dart';

class AppListItem extends StatelessWidget {
  final Application appls;
  final Color themeTextColor;
  final Function addToDock;
  final Function loadApps;
  final AppOps appops;
  final bool sysBrightness;
  final bool shouldDisplaySeparator;
  final String currentLetter;
  final List<Application> dockIconList;

  const AppListItem({
    super.key,
    required this.appls,
    required this.themeTextColor,
    required this.addToDock,
    required this.loadApps,
    required this.appops,
    required this.sysBrightness,
    required this.dockIconList,
    required this.shouldDisplaySeparator,
    required this.currentLetter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (shouldDisplaySeparator)
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            // mainAxisAlignment:
            //     MainAxisAlignment
            //         .spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  currentLetter,
                  style: TextStyle(color: themeTextColor, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // Container(
              //   height:
              //       2,
              //   width:
              //       MediaQuery.sizeOf(context).width - 80,
              //   color:
              //       Colors.grey,
              // ),
            ],
          ),
        ),
      GestureDetector(
          onTap: () {
            Navigator.pop(context);
            appops.openApps(appls);
          },
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
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration:
                              BoxDecoration(color: sysBrightness ? Colors.grey[900] : Colors.grey[200], borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.memory(
                                (appls as ApplicationWithIcon).icon,
                                width: 48,
                                height: 48,
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
                            addToDock(appls);
                            // debugPrint(dockIconList.toString());
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
                            bool isUninstalled = await DeviceApps.uninstallApp(appls.packageName);
                            await Future.delayed(const Duration(seconds: 30));
                            if (isUninstalled) {
                              bool isAppInstalled = await DeviceApps.isAppInstalled(appls.packageName);
                              if (!isAppInstalled) {
                                // App is uninstalled
                                loadApps();
                                debugPrint('App uninstalled successfully');
                              } else {
                                // App is still installed
                                debugPrint('App uninstallation failed App is still installed');
                              }
                            } else {
                              // Uninstallation failed
                              debugPrint('App uninstallation failed');
                            }
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
          child: ListTile(
            leading:
                //   ColorFiltered(
                // colorFilter:
                //     ColorFilter.mode(
                //   systemAccentColor,
                //   BlendMode.modulate,
                // ),
                // child: ColorFiltered(
                //     colorFilter: const ColorFilter.matrix(<double>[
                //       0.2126,
                //       0.7152,
                //       0.0722,
                //       0,
                //       0,
                //       0.2126,
                //       0.7152,
                //       0.0722,
                //       0,
                //       0,
                //       0.2126,
                //       0.7152,
                //       0.0722,
                //       0,
                //       0,
                //       0,
                //       0,
                //       0,
                //       1,
                //       0,
                //     ]),
                //     child: Image.memory(
                Image(
              image: MemoryImage((appls as ApplicationWithIcon).icon),
              width: 48,
              // color:
              //     systemAccentColor,
              // colorBlendMode:
              //     BlendMode.modulate,
            ),
            title: Text(
              appls.appName,
              style: TextStyle(color: themeTextColor),
            ),
          )
          // tileColor:
          //     Colors.grey[300],

          // : ListTile(
          //     title: Text(
          //       appls.appName,
          //       style: TextStyle(color: themeTextColor),
          //     ),
          //   ),
          ),
    ]);
  }
}
