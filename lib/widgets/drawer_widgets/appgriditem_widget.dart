import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/modules/app_helper.dart';

class AppGridItem extends StatelessWidget {
  final Application appls;
  final Color themeTextColor;
  final Function addToDock;
  final Function loadApps;
  final AppOps appops;
  final bool sysBrightness;
  final List<Application> dockIconList;

  const AppGridItem({
    Key? key,
    required this.appls,
    required this.themeTextColor,
    required this.addToDock,
    required this.loadApps,
    required this.appops,
    required this.sysBrightness,
    required this.dockIconList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loadAllApps = appops.listAllApps(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            appops.openApps(appls);
          },
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              // backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Theme.of(context).hoverColor, borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: MemoryImage((appls as ApplicationWithIcon).icon),
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
                            await Future.delayed(const Duration(seconds: 10));
                            if (isUninstalled) {
                              bool isAppInstalled = await DeviceApps.isAppInstalled(appls.packageName);
                              if (!isAppInstalled) {
                                // App is uninstalled
                                loadAllApps;
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
          child: Column(
            children: [
              Image(
                image: MemoryImage((appls as ApplicationWithIcon).icon),
                width: 52,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                appls.appName,
                style: TextStyle(color: themeTextColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
