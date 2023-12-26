import 'dart:developer';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/foundation.dart';

class AppOps extends ChangeNotifier {
  List<Application> apps = [];
  List<Application> searchAppList = [];
  List<Application> docklistitems = [];

  AppOps() {
    listAllApps();
    getPackageName('phone');
    getPackageName('Messages');
    getPackageName('Chrome');
    getPackageName('Camera');
  }

  void listAllApps() async {
    try {
      apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
      );
      apps.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
      // searchAppList.addAll(apps);
      // searchAppList = List.from(apps);
      searchAppList = apps;
      notifyListeners();
    } catch (e) {
      log('error');
    }
  }

  void getPackageName(String appName) async {
    var allapps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
    for (Application app in allapps) {
      if (app.appName.toLowerCase() == appName.toLowerCase()) {
        docklistitems.add(app);
        notifyListeners();
        break;
      }
    }
  }

  void openApps(Application application) {
    DeviceApps.openApp(application.packageName);
  }

  // void searchApp(String value) {
  //   searchAppList.clear();
  //   for (Application application in apps) {
  //     if (application.appName.toLowerCase().contains(value.toLowerCase())) {
  //       searchAppList.add(application);
  //     }
  //   }
  // }
  void searchApp(String value) {
    searchAppList = apps.where((application) => application.appName.toLowerCase().contains(value.toLowerCase())).toList();
    notifyListeners(); // Notify listeners here
  }

  // void addAppToDock(String value) {
  //   for (Application application in apps) {
  //     if (application.appName.toLowerCase().contains(value.toLowerCase())) {
  //       docklistitems.add(application);
  //       break;
  //     }
  //   }
  // }
  void addAppToDock(String value) {
    for (Application application in apps) {
      if (application.packageName.toLowerCase().contains(value.toLowerCase())) {
        docklistitems.add(application);
        notifyListeners(); // Notify listeners here
        break;
      }
    }
  }
}
