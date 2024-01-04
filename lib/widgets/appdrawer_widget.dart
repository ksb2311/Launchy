import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/modules/app_helper.dart';
import 'package:flutter_launcher/widgets/drawer_widgets/appgriditem_widget.dart';
import 'package:flutter_launcher/widgets/drawer_widgets/applistitem_widget.dart';

class AppDrawer extends StatefulWidget {
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

  const AppDrawer({
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

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // late bool shouldShowIcons = widget.setIcon;
  // final MethodChannel _channel = const MethodChannel('settings_channel');
  // double statusBarHeight = 0;
  // double navigationBarHeight = 0;
  // double screenWidth = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   getStatusBArHeight();
  // }

  // void getStatusBArHeight() async {
  //   var statusBarHeightTemp = await _channel.invokeMethod('getStatusBarHeight');
  //   var navigationBarHeighttTemp = await _channel.invokeMethod('getNavigationBarHeight');
  //   var screenWidthTemp = await _channel.invokeMethod('getScreenWidth');

  //   setState(() {
  //     statusBarHeight = statusBarHeightTemp.abs();
  //     navigationBarHeight = navigationBarHeighttTemp.abs();
  //     screenWidth = screenWidthTemp - 20;
  //   });
  //   // print(MediaQuery.sizeOf(context).width - 20);
  //   // print(screenWidth - 20);
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQueryData.fromView(View.of(context)).padding.top,
        // top: statusBarHeight,
        left: 10,
        right: 10,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.99,
        maxChildSize: 1.0,
        expand: true,
        // snap: true,
        // snapAnimationDuration: const Duration(milliseconds: 500),
        builder: (context, scrollController) {
          return Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              // Serarch Bar in Drawer
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                child: TextField(
                  controller: widget._textEditingController,
                  onSubmitted: (value) {
                    widget.appops.openApps(widget.appops.searchAppList[0]);
                    // clearText();
                    // setState(() {
                    //   appops.searchApp('');
                    // });
                  },
                  onChanged: (String value) {
                    setState(() {
                      widget.appops.searchApp(context, value);
                    });
                  },
                  style: TextStyle(color: widget.themeTextColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                    focusColor: widget.themeTextColor,
                    hintText: "Search",
                    hintStyle: TextStyle(color: widget.themeTextColor),
                    filled: true,
                    // fillColor: sysBrightness ? Colors.grey[900] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: widget._textEditingController.text != ''
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              widget.clearText();
                              setState(() {
                                widget.appops.searchApp(context, '');
                              });
                            },
                          )
                        : const Text(''),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              widget.setIcon
                  ? Flexible(
                      fit: FlexFit.tight,
                      child: Row(
                        children: [
                          SizedBox(
                              // width: MediaQuery.sizeOf(context).width - 60,
                              width: MediaQuery.sizeOf(context).width - 20,
                              // width: screenWidth,
                              // child: Scrollbar(
                              child: Scrollbar(
                                controller: scrollController,
                                interactive: true,
                                // thumbVisibility: true,
                                radius: const Radius.circular(10),
                                // trackVisibility: true,
                                thickness: 10,

                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GridView.builder(
                                      cacheExtent: 9999,
                                      controller: scrollController,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio: 0.9,
                                        mainAxisSpacing: 30,
                                        crossAxisSpacing: 10,
                                        // mainAxisExtent: 110,
                                      ),
                                      itemCount: widget.appops.searchAppList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final appsls = widget.appops.searchAppList[index];

                                        // String currentLetter = getFirstLetter(appls.appName);

                                        // bool shouldDisplaySeparator =
                                        //     index == 0 || currentLetter != getFirstLetter(appops.searchAppList[index - 1].appName);

                                        if (widget.appops.searchAppList.isNotEmpty) {
                                          return AppGridItem(
                                            appls: appsls,
                                            themeTextColor: widget.themeTextColor,
                                            addToDock: widget.addToDock,
                                            loadApps: widget.loadApps,
                                            appops: widget.appops,
                                            sysBrightness: widget.sysBrightness,
                                            dockIconList: widget.dockIconList,
                                          );
                                        } else {
                                          return const Expanded(
                                            child: Center(
                                              child: Text('Loading...'),
                                            ),
                                          );
                                        }
                                      }),
                                ),
                              )),
                        ],
                      ),
                    )
                  : Flexible(
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
                                itemCount: widget.appops.searchAppList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final appls = widget.appops.searchAppList[index];
                                  String currentLetter = widget.getFirstLetter(appls.appName);

                                  // Check if the separator should be displayed
                                  bool shouldDisplaySeparator =
                                      index == 0 || currentLetter != widget.getFirstLetter(widget.appops.searchAppList[index - 1].appName);
                                  return widget.appops.searchAppList.isNotEmpty
                                      ? AppListItem(
                                          appls: appls,
                                          themeTextColor: widget.themeTextColor,
                                          addToDock: widget.addToDock,
                                          loadApps: widget.loadApps,
                                          appops: widget.appops,
                                          sysBrightness: widget.sysBrightness,
                                          dockIconList: widget.dockIconList,
                                          shouldDisplaySeparator: shouldDisplaySeparator,
                                          currentLetter: currentLetter)
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
        },
      ),
    );
  }
}
