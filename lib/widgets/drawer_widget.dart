import 'package:android_intent_plus/android_intent.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/modules/app_helper.dart';
import 'package:flutter_launcher/widgets/drawer_widgets/appgriditem_widget.dart';

class CustomModalBottomSheet extends StatelessWidget {
  final TextEditingController _textEditingController;
  final AppOps appops;
  final bool sysBrightness;
  final Color themeTextColor;
  final Function addToDock;
  final Function clearText;
  final Function getFirstLetter;
  final Function loadApps;
  final bool setIcon;
  final List<Application> dockIconList;

  const CustomModalBottomSheet({
    super.key,
    required TextEditingController textEditingController,
    required this.appops,
    required this.sysBrightness,
    required this.themeTextColor,
    required this.addToDock,
    required this.clearText,
    required this.getFirstLetter,
    required this.loadApps,
    required this.dockIconList,
    required this.setIcon,
  }) : _textEditingController = textEditingController;

  // late bool shouldShowIcons = widget.setIcon;

  @override
  Widget build(BuildContext context) {
    return setIcon
        ? GestureDetector(
            // onTap: (() => FocusScope.of(context).unfocus()),
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQueryData.fromView(View.of(context)).padding.top,
                left: 10,
                right: 10,
              ),
              child: StatefulBuilder(
                builder: (BuildContext context, setState) {
                  return DraggableScrollableSheet(
                    initialChildSize: 1.0,
                    minChildSize: 0.99,
                    maxChildSize: 1.0,
                    expand: true,
                    snap: true,
                    builder: (context, scrollController) {
                      return Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          // Serarch Bar in Drawer
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 2),
                            child: TextField(
                              controller: _textEditingController,
                              onSubmitted: (value) {
                                appops.openApps(appops.searchAppList[0]);
                                // clearText();
                                // setState(() {
                                //   appops.searchApp('');
                                // });
                              },
                              onChanged: (String value) {
                                setState(() {
                                  appops.searchApp(value);
                                });
                              },
                              style: TextStyle(color: themeTextColor),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                                focusColor: themeTextColor,
                                hintText: "Search",
                                hintStyle: TextStyle(color: themeTextColor),
                                filled: true,
                                fillColor: sysBrightness ? Colors.grey[900] : Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: _textEditingController.text != ''
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          clearText();
                                          setState(() {
                                            appops.searchApp('');
                                          });
                                        },
                                      )
                                    : const Text(''),
                                prefixIcon: const Icon(Icons.search),
                              ),
                            ),
                          ),
                          Flexible(
                              child: Row(
                            children: [
                              SizedBox(
                                  // width: MediaQuery.sizeOf(context).width - 60,
                                  width: MediaQuery.sizeOf(context).width - 20,
                                  child: Scrollbar(
                                    controller: scrollController,
                                    interactive: true,
                                    // thumbVisibility: true,
                                    radius: const Radius.circular(10),
                                    // trackVisibility: true,
                                    thickness: 10,

                                    child: GridView.builder(
                                        cacheExtent: 9999,
                                        controller: scrollController,
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          childAspectRatio: 1.0,
                                        ),
                                        itemCount: appops.searchAppList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          final appsls = appops.searchAppList[index];
                                          // String currentLetter = getFirstLetter(appls.appName);

                                          // bool shouldDisplaySeparator =
                                          //     index == 0 || currentLetter != getFirstLetter(appops.searchAppList[index - 1].appName);

                                          if (appops.searchAppList.isNotEmpty) {
                                            return AppGridItem(
                                              appls: appsls,
                                              themeTextColor: themeTextColor,
                                              addToDock: addToDock,
                                              loadApps: loadApps,
                                              appops: appops,
                                              sysBrightness: sysBrightness,
                                              dockIconList: dockIconList,
                                            );
                                          } else {
                                            return const Expanded(
                                              child: Center(
                                                child: Text('Loading...'),
                                              ),
                                            );
                                          }
                                        }),
                                  )),
                            ],
                          )),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          )
        : GestureDetector(
            onTap: (() => FocusScope.of(context).unfocus()),
            child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQueryData.fromView(View.of(context)).padding.top,
                  left: 10,
                  right: 10,
                ),
                child: StatefulBuilder(builder: (BuildContext context, setState) {
                  return DraggableScrollableSheet(
                      initialChildSize: 1.0,
                      minChildSize: 0.99,
                      maxChildSize: 1.0,
                      expand: true,
                      snap: true,
                      builder: (context, scrollController) {
                        return Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            // Serarch Bar in Drawer
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 2),
                              child: TextField(
                                controller: _textEditingController,
                                onSubmitted: (value) {
                                  appops.openApps(appops.searchAppList[0]);
                                  clearText();
                                  setState(() {
                                    appops.searchApp('');
                                  });
                                },
                                style: TextStyle(color: themeTextColor),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                                  focusColor: themeTextColor,
                                  hintText: "Search",
                                  hintStyle: TextStyle(color: themeTextColor),
                                  filled: true,
                                  fillColor: sysBrightness ? Colors.grey[900] : Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: _textEditingController.text != ''
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            clearText();
                                            setState(() {
                                              appops.searchApp('');
                                            });
                                          },
                                        )
                                      : const Text(''),
                                  prefixIcon: const Icon(Icons.search),
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    appops.searchApp(value);
                                  });
                                },
                              ),
                            ),
                            Flexible(
                                child: Row(
                              children: [
                                SizedBox(
                                    // width: MediaQuery.sizeOf(context).width - 60,
                                    width: MediaQuery.sizeOf(context).width - 20,
                                    child: Scrollbar(
                                      controller: scrollController,
                                      interactive: true,
                                      // thumbVisibility: true,
                                      radius: const Radius.circular(10),
                                      // trackVisibility: true,
                                      thickness: 10,
                                      child: ListView.separated(
                                        cacheExtent: 9999,
                                        controller: scrollController,
                                        itemCount: appops.searchAppList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          final appls = appops.searchAppList[index];
                                          String currentLetter = getFirstLetter(appls.appName);

                                          // Check if the separator should be displayed
                                          bool shouldDisplaySeparator =
                                              index == 0 || currentLetter != getFirstLetter(appops.searchAppList[index - 1].appName);
                                          return appops.searchAppList.isNotEmpty
                                              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                                                      decoration: BoxDecoration(
                                                                          color: sysBrightness ? Colors.grey[900] : Colors.grey[200],
                                                                          borderRadius: BorderRadius.circular(30)),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Image.memory(
                                                                            (appls as ApplicationWithIcon).icon,
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
                                                            Image.memory(
                                                          (appls as ApplicationWithIcon).icon,
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
                                                ])
                                              : const Center(
                                                  child: Text('Loading...'),
                                                );
                                        },
                                        separatorBuilder: (BuildContext context, int index) {
                                          return const SizedBox.shrink(); // Return an empty separator when the letter doesn't change
                                          // }
                                          // }
                                        },
                                      ),
                                    )),
                              ],
                            )),
                          ],
                        );
                      });
                })));
  }
}


// Display Drawer
                // showModalBottomSheet(
                //     context: context,
                //     isScrollControlled: true,
                //     shape: const ContinuousRectangleBorder(),
                //     // backgroundColor: Colors.transparent,
                //     builder: (context) {
                //       return GestureDetector(
                //         onTap: (() => FocusScope.of(context).unfocus()),
                //         child: Padding(
                //           padding: EdgeInsets.only(
                //             top: MediaQueryData.fromView(View.of(context)).padding.top,
                //             left: 10,
                //             right: 10,
                //           ),
                //           child: StatefulBuilder(
                //             builder: (BuildContext context, setState) {
                //               return DraggableScrollableSheet(
                //                   initialChildSize: 1.0,
                //                   minChildSize: 0.99,
                //                   maxChildSize: 1.0,
                //                   expand: true,
                //                   snap: true,
                //                   builder: (context, scrollController) {
                //                     return Column(
                //                       // ignore: prefer_const_literals_to_create_immutables
                //                       children: [
                //                         // Serarch Bar in Drawer
                //                         Padding(
                //                           padding: const EdgeInsets.only(top: 5, bottom: 2),
                //                           child: TextField(
                //                             controller: _textEditingController,
                //                             onSubmitted: (value) {
                //                               appops.openApps(appops.searchAppList[0]);
                //                               _clearText();
                //                               setState(() {
                //                                 appops.searchApp('');
                //                               });
                //                             },
                //                             style: TextStyle(color: themeTextColor),
                //                             decoration: InputDecoration(
                //                               contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                //                               focusColor: themeTextColor,
                //                               hintText: "Search",
                //                               hintStyle: TextStyle(color: themeTextColor),
                //                               filled: true,
                //                               fillColor: sysBrightness ? Colors.grey[900] : Colors.grey[200],
                //                               border: OutlineInputBorder(
                //                                 borderRadius: BorderRadius.circular(30.0),
                //                                 borderSide: BorderSide.none,
                //                               ),
                //                               suffixIcon: _textEditingController.text != ''
                //                                   ? IconButton(
                //                                       icon: const Icon(Icons.clear),
                //                                       onPressed: () {
                //                                         _clearText();
                //                                         setState(() {
                //                                           appops.searchApp('');
                //                                         });
                //                                       },
                //                                     )
                //                                   : const Text(''),
                //                               prefixIcon: const Icon(Icons.search),
                //                             ),
                //                             onChanged: (String value) {
                //                               setState(() {
                //                                 appops.searchApp(value);
                //                               });
                //                             },
                //                           ),
                //                         ),
                //                         Flexible(
                //                             child: Row(
                //                           children: [
                //                             SizedBox(
                //                                 // width: MediaQuery.sizeOf(context).width - 60,
                //                                 width: MediaQuery.sizeOf(context).width - 20,
                //                                 child: Scrollbar(
                //                                   controller: scrollController,
                //                                   interactive: true,
                //                                   // thumbVisibility: true,
                //                                   radius: const Radius.circular(10),
                //                                   // trackVisibility: true,
                //                                   thickness: 10,
                //                                   // child: ListView.separated(
                //                                   //   cacheExtent: 9999,
                //                                   //   controller: scrollController,
                //                                   //   itemCount: appops.searchAppList.length,
                //                                   //   itemBuilder: (BuildContext context, int index) {
                //                                   //     final appls = appops.searchAppList[index];
                //                                   //     String currentLetter = getFirstLetter(appls.appName);

                //                                   //     // Check if the separator should be displayed
                //                                   //     bool shouldDisplaySeparator =
                //                                   //         index == 0 || currentLetter != getFirstLetter(appops.searchAppList[index - 1].appName);
                //                                   //     return appops.searchAppList.isNotEmpty
                //                                   //         ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //                                   //             if (shouldDisplaySeparator)
                //                                   //               Padding(
                //                                   //                 padding: const EdgeInsets.only(top: 10, bottom: 10),
                //                                   //                 child: Row(
                //                                   //                   // mainAxisAlignment:
                //                                   //                   //     MainAxisAlignment
                //                                   //                   //         .spaceEvenly,
                //                                   //                   children: [
                //                                   //                     Padding(
                //                                   //                       padding: const EdgeInsets.only(left: 15),
                //                                   //                       child: Text(
                //                                   //                         currentLetter,
                //                                   //                         style: TextStyle(
                //                                   //                             color: themeTextColor, fontSize: 20, fontWeight: FontWeight.bold),
                //                                   //                       ),
                //                                   //                     ),
                //                                   //                     // Container(
                //                                   //                     //   height:
                //                                   //                     //       2,
                //                                   //                     //   width:
                //                                   //                     //       MediaQuery.sizeOf(context).width - 80,
                //                                   //                     //   color:
                //                                   //                     //       Colors.grey,
                //                                   //                     // ),
                //                                   //                   ],
                //                                   //                 ),
                //                                   //               ),
                //                                   //             GestureDetector(
                //                                   //               onTap: () {
                //                                   //                 Navigator.pop(context);
                //                                   //                 appops.openApps(appls);
                //                                   //               },
                //                                   //               onLongPress: () {
                //                                   //                 showModalBottomSheet(
                //                                   //                   context: context,
                //                                   //                   backgroundColor: Colors.transparent,
                //                                   //                   isScrollControlled: true,
                //                                   //                   builder: (BuildContext context) {
                //                                   //                     return Container(
                //                                   //                       decoration: BoxDecoration(
                //                                   //                         color: sysBrightness ? Colors.grey[800] : Colors.grey[100],
                //                                   //                         borderRadius: const BorderRadius.only(
                //                                   //                           topLeft: Radius.circular(20),
                //                                   //                           topRight: Radius.circular(20),
                //                                   //                         ),
                //                                   //                       ),
                //                                   //                       child: Padding(
                //                                   //                         padding: const EdgeInsets.all(16),
                //                                   //                         child: Column(
                //                                   //                           mainAxisSize: MainAxisSize.min,
                //                                   //                           children: [
                //                                   //                             Container(
                //                                   //                               padding: const EdgeInsets.all(10),
                //                                   //                               decoration: BoxDecoration(
                //                                   //                                   color: sysBrightness ? Colors.grey[900] : Colors.grey[200],
                //                                   //                                   borderRadius: BorderRadius.circular(30)),
                //                                   //                               child: Row(
                //                                   //                                 mainAxisAlignment: MainAxisAlignment.center,
                //                                   //                                 children: [
                //                                   //                                   Image.memory(
                //                                   //                                     (appls as ApplicationWithIcon).icon,
                //                                   //                                     width: 42,
                //                                   //                                     height: 42,
                //                                   //                                     // cacheHeight: 42,
                //                                   //                                   ),
                //                                   //                                   const SizedBox(
                //                                   //                                     width: 10,
                //                                   //                                   ),
                //                                   //                                   Text(appls.appName),
                //                                   //                                 ],
                //                                   //                               ),
                //                                   //                             ),
                //                                   //                             const SizedBox(height: 16),
                //                                   //                             GestureDetector(
                //                                   //                               onTap: () {
                //                                   //                                 addToDock(appls);
                //                                   //                                 // debugPrint(dockIconList.toString());
                //                                   //                                 Navigator.of(context).pop();
                //                                   //                               },
                //                                   //                               child: ListTile(
                //                                   //                                 leading: const Icon(Icons.add_circle_outline),
                //                                   //                                 title: Text(
                //                                   //                                   dockIconList.length != 4 ? "Add to Dock" : "Dock is Full",
                //                                   //                                   style: TextStyle(color: themeTextColor),
                //                                   //                                 ),
                //                                   //                               ),
                //                                   //                             ),
                //                                   //                             GestureDetector(
                //                                   //                               onTap: () async {
                //                                   //                                 Navigator.of(context).pop();
                //                                   //                                 final AndroidIntent intent = AndroidIntent(
                //                                   //                                   action: 'action_application_details_settings',
                //                                   //                                   data: 'package:${appls.packageName}',
                //                                   //                                 );

                //                                   //                                 await intent.launch();
                //                                   //                               },
                //                                   //                               child: ListTile(
                //                                   //                                 leading: const Icon(Icons.info_outline),
                //                                   //                                 title: Text(
                //                                   //                                   "App Info",
                //                                   //                                   style: TextStyle(color: themeTextColor),
                //                                   //                                 ),
                //                                   //                               ),
                //                                   //                             ),
                //                                   //                             GestureDetector(
                //                                   //                               onTap: () async {
                //                                   //                                 Navigator.of(context).pop();
                //                                   //                                 bool isUninstalled = await DeviceApps.uninstallApp(appls.packageName);
                //                                   //                                 await Future.delayed(const Duration(seconds: 30));
                //                                   //                                 if (isUninstalled) {
                //                                   //                                   bool isAppInstalled =
                //                                   //                                       await DeviceApps.isAppInstalled(appls.packageName);
                //                                   //                                   if (!isAppInstalled) {
                //                                   //                                     // App is uninstalled
                //                                   //                                     loadApps();
                //                                   //                                     debugPrint('App uninstalled successfully');
                //                                   //                                   } else {
                //                                   //                                     // App is still installed
                //                                   //                                     debugPrint('App uninstallation failed App is still installed');
                //                                   //                                   }
                //                                   //                                 } else {
                //                                   //                                   // Uninstallation failed
                //                                   //                                   debugPrint('App uninstallation failed');
                //                                   //                                 }
                //                                   //                               },
                //                                   //                               child: ListTile(
                //                                   //                                 leading: const Icon(Icons.remove_circle_outline),
                //                                   //                                 title: Text(
                //                                   //                                   "Uninstall",
                //                                   //                                   style: TextStyle(color: themeTextColor),
                //                                   //                                 ),
                //                                   //                               ),
                //                                   //                             ),
                //                                   //                           ],
                //                                   //                         ),
                //                                   //                       ),
                //                                   //                     );
                //                                   //                   },
                //                                   //                 );
                //                                   //               },
                //                                   //               child: shouldShowIcons
                //                                   //                   ? ListTile(
                //                                   //                       leading:
                //                                   //                           //   ColorFiltered(
                //                                   //                           // colorFilter:
                //                                   //                           //     ColorFilter.mode(
                //                                   //                           //   systemAccentColor,
                //                                   //                           //   BlendMode.modulate,
                //                                   //                           // ),
                //                                   //                           // child: ColorFiltered(
                //                                   //                           //     colorFilter: const ColorFilter.matrix(<double>[
                //                                   //                           //       0.2126,
                //                                   //                           //       0.7152,
                //                                   //                           //       0.0722,
                //                                   //                           //       0,
                //                                   //                           //       0,
                //                                   //                           //       0.2126,
                //                                   //                           //       0.7152,
                //                                   //                           //       0.0722,
                //                                   //                           //       0,
                //                                   //                           //       0,
                //                                   //                           //       0.2126,
                //                                   //                           //       0.7152,
                //                                   //                           //       0.0722,
                //                                   //                           //       0,
                //                                   //                           //       0,
                //                                   //                           //       0,
                //                                   //                           //       0,
                //                                   //                           //       0,
                //                                   //                           //       1,
                //                                   //                           //       0,
                //                                   //                           //     ]),
                //                                   //                           //     child: Image.memory(
                //                                   //                           Image.memory(
                //                                   //                         (appls as ApplicationWithIcon).icon,
                //                                   //                         width: 48,
                //                                   //                         // color:
                //                                   //                         //     systemAccentColor,
                //                                   //                         // colorBlendMode:
                //                                   //                         //     BlendMode.modulate,
                //                                   //                       ),
                //                                   //                       title: Text(
                //                                   //                         appls.appName,
                //                                   //                         style: TextStyle(color: themeTextColor),
                //                                   //                       ),
                //                                   //                     )
                //                                   //                   // tileColor:
                //                                   //                   //     Colors.grey[300],

                //                                   //                   : ListTile(
                //                                   //                       title: Text(
                //                                   //                         appls.appName,
                //                                   //                         style: TextStyle(color: themeTextColor),
                //                                   //                       ),
                //                                   //                     ),
                //                                   //             ),
                //                                   //           ])
                //                                   //         : const Center(
                //                                   //             child: Text('Loading...'),
                //                                   //           );
                //                                   //   },
                //                                   //   separatorBuilder: (BuildContext context, int index) {
                //                                   //     return const SizedBox.shrink(); // Return an empty separator when the letter doesn't change
                //                                   //     // }
                //                                   //     // }
                //                                   //   },
                //                                   // ),
                //                                   child: GridView.builder(
                //                                       cacheExtent: 9999,
                //                                       controller: scrollController,
                //                                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //                                         crossAxisCount: 4,
                //                                         childAspectRatio: 1.0,
                //                                       ),
                //                                       itemCount: appops.searchAppList.length,
                //                                       itemBuilder: (BuildContext context, int index) {
                //                                         final appls = appops.searchAppList[index];
                //                                         String currentLetter = getFirstLetter(appls.appName);

                //                                         bool shouldDisplaySeparator =
                //                                             index == 0 || currentLetter != getFirstLetter(appops.searchAppList[index - 1].appName);

                //                                         if (appops.searchAppList.isNotEmpty) {
                //                                           return Column(
                //                                             crossAxisAlignment: CrossAxisAlignment.center,
                //                                             children: [
                //                                               // if (shouldDisplaySeparator)
                //                                               //   Padding(
                //                                               //     padding: const EdgeInsets.only(top: 10, bottom: 10),
                //                                               //     child: Row(
                //                                               //       // mainAxisAlignment:
                //                                               //       //     MainAxisAlignment
                //                                               //       //         .spaceEvenly,
                //                                               //       children: [
                //                                               //         Padding(
                //                                               //           padding: const EdgeInsets.only(left: 15),
                //                                               //           child: Text(
                //                                               //             currentLetter,
                //                                               //             style: TextStyle(
                //                                               //                 color: themeTextColor, fontSize: 20, fontWeight: FontWeight.bold),
                //                                               //           ),
                //                                               //         ),
                //                                               //         // Container(
                //                                               //         //   height:
                //                                               //         //       2,
                //                                               //         //   width:
                //                                               //         //       MediaQuery.sizeOf(context).width - 80,
                //                                               //         //   color:
                //                                               //         //       Colors.grey,
                //                                               //         // ),
                //                                               //       ],
                //                                               //     ),
                //                                               //   ),

                //                                               GestureDetector(
                //                                                   onTap: () {
                //                                                     Navigator.pop(context);
                //                                                     appops.openApps(appls);
                //                                                   },
                //                                                   onLongPress: () {
                //                                                     showModalBottomSheet(
                //                                                       context: context,
                //                                                       backgroundColor: Colors.transparent,
                //                                                       isScrollControlled: true,
                //                                                       builder: (BuildContext context) {
                //                                                         return Container(
                //                                                           decoration: BoxDecoration(
                //                                                             color: sysBrightness ? Colors.grey[800] : Colors.grey[100],
                //                                                             borderRadius: const BorderRadius.only(
                //                                                               topLeft: Radius.circular(20),
                //                                                               topRight: Radius.circular(20),
                //                                                             ),
                //                                                           ),
                //                                                           child: Padding(
                //                                                             padding: const EdgeInsets.all(16),
                //                                                             child: Column(
                //                                                               mainAxisSize: MainAxisSize.min,
                //                                                               children: [
                //                                                                 Container(
                //                                                                   padding: const EdgeInsets.all(10),
                //                                                                   decoration: BoxDecoration(
                //                                                                       color: sysBrightness ? Colors.grey[900] : Colors.grey[200],
                //                                                                       borderRadius: BorderRadius.circular(30)),
                //                                                                   child: Row(
                //                                                                     mainAxisAlignment: MainAxisAlignment.center,
                //                                                                     children: [
                //                                                                       Image.memory(
                //                                                                         (appls).icon,
                //                                                                         width: 42,
                //                                                                         height: 42,
                //                                                                         // cacheHeight: 42,
                //                                                                       ),
                //                                                                       const SizedBox(
                //                                                                         width: 10,
                //                                                                       ),
                //                                                                       Text(appls.appName),
                //                                                                     ],
                //                                                                   ),
                //                                                                 ),
                //                                                                 const SizedBox(height: 16),
                //                                                                 GestureDetector(
                //                                                                   onTap: () {
                //                                                                     addToDock(appls);
                //                                                                     // debugPrint(dockIconList.toString());
                //                                                                     Navigator.of(context).pop();
                //                                                                   },
                //                                                                   child: ListTile(
                //                                                                     leading: const Icon(Icons.add_circle_outline),
                //                                                                     title: Text(
                //                                                                       dockIconList.length != 4 ? "Add to Dock" : "Dock is Full",
                //                                                                       style: TextStyle(color: themeTextColor),
                //                                                                     ),
                //                                                                   ),
                //                                                                 ),
                //                                                                 GestureDetector(
                //                                                                   onTap: () async {
                //                                                                     Navigator.of(context).pop();
                //                                                                     final AndroidIntent intent = AndroidIntent(
                //                                                                       action: 'action_application_details_settings',
                //                                                                       data: 'package:${appls.packageName}',
                //                                                                     );

                //                                                                     await intent.launch();
                //                                                                   },
                //                                                                   child: ListTile(
                //                                                                     leading: const Icon(Icons.info_outline),
                //                                                                     title: Text(
                //                                                                       "App Info",
                //                                                                       style: TextStyle(color: themeTextColor),
                //                                                                     ),
                //                                                                   ),
                //                                                                 ),
                //                                                                 GestureDetector(
                //                                                                   onTap: () async {
                //                                                                     Navigator.of(context).pop();
                //                                                                     bool isUninstalled =
                //                                                                         await DeviceApps.uninstallApp(appls.packageName);
                //                                                                     await Future.delayed(const Duration(seconds: 30));
                //                                                                     if (isUninstalled) {
                //                                                                       bool isAppInstalled =
                //                                                                           await DeviceApps.isAppInstalled(appls.packageName);
                //                                                                       if (!isAppInstalled) {
                //                                                                         // App is uninstalled
                //                                                                         loadApps();
                //                                                                         debugPrint('App uninstalled successfully');
                //                                                                       } else {
                //                                                                         // App is still installed
                //                                                                         debugPrint(
                //                                                                             'App uninstallation failed App is still installed');
                //                                                                       }
                //                                                                     } else {
                //                                                                       // Uninstallation failed
                //                                                                       debugPrint('App uninstallation failed');
                //                                                                     }
                //                                                                   },
                //                                                                   child: ListTile(
                //                                                                     leading: const Icon(Icons.remove_circle_outline),
                //                                                                     title: Text(
                //                                                                       "Uninstall",
                //                                                                       style: TextStyle(color: themeTextColor),
                //                                                                     ),
                //                                                                   ),
                //                                                                 ),
                //                                                               ],
                //                                                             ),
                //                                                           ),
                //                                                         );
                //                                                       },
                //                                                     );
                //                                                   },
                //                                                   child: Column(
                //                                                     children: [
                //                                                       Container(
                //                                                         padding: const EdgeInsets.all(8.0),
                //                                                         child: Image.memory(
                //                                                           (appls as ApplicationWithIcon).icon,
                //                                                           fit: BoxFit.contain,
                //                                                           width: 48,
                //                                                         ),
                //                                                       ),
                //                                                       Text(
                //                                                         appls.appName,
                //                                                         style: TextStyle(color: themeTextColor),
                //                                                         overflow: TextOverflow.ellipsis,
                //                                                         maxLines: 1,
                //                                                       ),
                //                                                     ],
                //                                                   )),
                //                                               // Full-width separator
                //                                               // shouldDisplaySeparator
                //                                               //     ? SizedBox(
                //                                               //         height: 10,
                //                                               //         child: Text(
                //                                               //           currentLetter,
                //                                               //           style: TextStyle(
                //                                               //               color: themeTextColor, fontSize: 20, fontWeight: FontWeight.bold),
                //                                               //         ),
                //                                               //       )
                //                                               //     : Container(),
                //                                             ],
                //                                           );
                //                                         } else {
                //                                           return const Center(
                //                                             child: Text('Loading...'),
                //                                           );
                //                                         }
                //                                       }),
                //                                 )),
                //                           ],
                //                         )),
                //                       ],
                //                     );
                //                   });
                //             },
                //           ),
                //         ),
                //       );
                //     });