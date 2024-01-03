import 'dart:developer';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppOps extends ChangeNotifier {
  List<Application> apps = [];
  List<Application> searchAppList = [];
  final List<Application> _dockListItems = [];

  List<Application> get dockListItems => _dockListItems;

  AppOps(context) {
    initApps(context);
  }

  void initApps(context) async {
    await listAllApps(context);
    await getPackageNames(['phone', 'Messages', 'Chrome', 'Camera']);
  }

  Future<void> listAllApps(context) async {
    try {
      apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
      );
      apps.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
      // context.read(appsProvider).state.sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
      // searchAppList.addAll(apps);
      // searchAppList = List.from(apps);
      searchAppList = apps;
      // searchAppList = context.read(appsProvider).state;
      // context.read(searchAppListProvider).state = apps;
    } catch (e) {
      log('error');
    }
  }

  // Future<void> getPackageName(String appName) async {
  //   var allapps = await DeviceApps.getInstalledApplications(
  //     includeAppIcons: true,
  //     includeSystemApps: true,
  //     onlyAppsWithLaunchIntent: true,
  //   );
  //   for (Application app in allapps) {
  //     if (app.appName.toLowerCase() == appName.toLowerCase()) {
  //       _dockListItems.add(app);
  //       break;
  //     }
  //   }
  //   notifyListeners();
  // }
  Future<void> getPackageNames(List<String> appNames) async {
    var allapps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );

    for (Application app in allapps) {
      if (_dockListItems.length < 4 && appNames.map((appName) => appName.toLowerCase()).contains(app.appName.toLowerCase())) {
        _dockListItems.add(app);
      }
    }

    notifyListeners();
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

  void searchApp(context, String value) {
    searchAppList = apps.where((application) => application.appName.toLowerCase().contains(value.toLowerCase())).toList();
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
        _dockListItems.add(application);
        notifyListeners();
        break;
      }
    }
  }
}
