import 'dart:developer';

import 'package:device_apps/device_apps.dart';

class AppOps {
  List<Application> apps = [];
  List<Application> searchAppList = [];
  List<Application> docklistitems = [];

  AppOps() {
    listAllApps();
  }

  void listAllApps() async {
    try {
      apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
      );
      apps.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
      searchAppList.addAll(apps);
    } catch (e) {
      log('error');
    }
  }

  void openApps(Application application) {
    DeviceApps.openApp(application.packageName);
  }

  void searchApp(String value) {
    searchAppList.clear();
    for (Application application in apps) {
      if (application.appName.toLowerCase().contains(value.toLowerCase())) {
        searchAppList.add(application);
      }
    }
  }

  void addAppToDock(String value) {
    for (Application application in apps) {
      if (application.appName.toLowerCase().contains(value.toLowerCase())) {
        docklistitems.add(application);
        break;
      }
    }
  }
}
