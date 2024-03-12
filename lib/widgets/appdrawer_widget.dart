import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_launcher/constants/settings/settings_const.dart';
import 'package:flutter_launcher/modules/app_helper.dart';
import 'package:flutter_launcher/widgets/drawer_widgets/appgriditem_widget.dart';
import 'package:flutter_launcher/widgets/drawer_widgets/applistitem_widget.dart';
import 'package:flutter_launcher/widgets/drawer_widgets/keyboard_widget.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  final TextEditingController _textEditingController;
  final AppOps appops;
  final bool sysBrightness;
  final Color themeTextColor;
  final Function addToDock;
  final Function clearText;
  final Function getFirstLetter;
  final Function loadApps;
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
  }) : _textEditingController = textEditingController;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // This keeps the widget alive
  late AppOps appops;

  @override
  void initState() {
    super.initState();
    appops = widget.appops;
  }

  void _onKeyPressed(String key) {
    // Update the TextField with the pressed key
    setState(() {
      widget._textEditingController.text += key;
      appops.searchApp(context, widget._textEditingController.text);
    });
  }

  void _handleDeletePressed() {
    setState(() {
      if (widget._textEditingController.text.isNotEmpty) {
        widget._textEditingController.text = widget._textEditingController.text.substring(0, widget._textEditingController.text.length - 1);
        appops.searchApp(context, widget._textEditingController.text);
      }
    });
  }

  void _handleSubmitPressed() {
    appops.openApps(widget.appops.searchAppList[0]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ThemeData currentTheme = Theme.of(context);
    bool sysBrightness = currentTheme.brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: sysBrightness ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: sysBrightness ? Brightness.light : Brightness.dark,
    ));
    final settingsConst = Provider.of<SettingsConst>(context);

    return Padding(
      padding: const EdgeInsets.only(
        // top: MediaQueryData.fromView(View.of(context)).padding.top,
        left: 10,
        right: 10,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0.99,
        maxChildSize: 1.0,
        expand: true,
        builder: (context, scrollController) {
          final gridView = GridView.builder(
            cacheExtent: 9999,
            controller: scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              mainAxisSpacing: 30,
              crossAxisSpacing: 10,
            ),
            itemCount: appops.searchAppList.length,
            itemBuilder: (BuildContext context, int index) {
              final appsls = appops.searchAppList[index];
              return appops.searchAppList.isNotEmpty
                  ? AppGridItem(
                      appls: appsls,
                      themeTextColor: widget.themeTextColor,
                      addToDock: widget.addToDock,
                      loadApps: widget.loadApps,
                      appops: appops,
                      sysBrightness: widget.sysBrightness,
                      dockIconList: widget.dockIconList,
                    )
                  : const Expanded(
                      child: Center(
                        child: Text('Loading...'),
                      ),
                    );
            },
          );

          final listView = ListView.separated(
            cacheExtent: 9999,
            controller: scrollController,
            itemCount: appops.searchAppList.length,
            itemBuilder: (BuildContext context, int index) {
              final appls = appops.searchAppList[index];
              String currentLetter = widget.getFirstLetter(appls.appName);
              bool shouldDisplaySeparator = index == 0 || currentLetter != widget.getFirstLetter(widget.appops.searchAppList[index - 1].appName);
              return appops.searchAppList.isNotEmpty
                  ? AppListItem(
                      appls: appls,
                      themeTextColor: widget.themeTextColor,
                      addToDock: widget.addToDock,
                      loadApps: widget.loadApps,
                      appops: appops,
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
            },
          );
          return Column(
            children: [
              // Search Bar in Drawer
              Padding(
                padding: EdgeInsets.only(top: MediaQueryData.fromView(View.of(context)).padding.top + 5, bottom: 5, left: 20, right: 20),
                child: TextField(
                  controller: widget._textEditingController,
                  readOnly: true,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        barrierColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        builder: (BuildContext context) {
                          return SafeArea(
                              child: KeyboardWidget(
                            onKeyPressed: _onKeyPressed,
                            onDeletePressed: _handleDeletePressed,
                            onSubmitPressed: _handleSubmitPressed,
                          ));
                        });
                  },
                  // onSubmitted: (value) {
                  //   //appops.searchApp(context, value);
                  //   appops.openApps(widget.appops.searchAppList[0]);
                  //   // clearText();
                  //   // setState(() {
                  //   //   appops.searchApp('');
                  //   // });
                  // },
                  // onChanged: (String value) {
                  //   setState(() {
                  //     appops.searchApp(context, widget._textEditingController.text);
                  //     debugPrint(value);
                  //   });
                  // },
                  style: TextStyle(color: widget.themeTextColor),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, bottom: 15),
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
                                appops.searchApp(context, '');
                              });
                            },
                          )
                        : const Text(''),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              settingsConst.showIcons
                  ? Flexible(
                      fit: FlexFit.tight,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width - 20,
                            child: Scrollbar(
                              controller: scrollController,
                              interactive: true,
                              radius: const Radius.circular(10),
                              thickness: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: gridView,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Flexible(
                      fit: FlexFit.tight,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width - 20,
                            child: Scrollbar(
                              controller: scrollController,
                              interactive: true,
                              radius: const Radius.circular(10),
                              thickness: 10,
                              trackVisibility: true,
                              child: listView,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
