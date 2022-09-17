import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/operations/appops.dart';
import 'package:intl/intl.dart';

class Drawerpage extends StatefulWidget {
  const Drawerpage({Key? key}) : super(key: key);

  @override
  State<Drawerpage> createState() => _DrawerpageState();
}

class _DrawerpageState extends State<Drawerpage> {
  // List<Application> listApps = AppOps().searchAppList;
  final AppOps appops = AppOps();
  List<Application> dockIconList = [];
  final _textEditingController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: PageView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsetsDirectional.only(
                            top: 80, start: 20, end: 20, bottom: 20),
                        child: StreamBuilder(
                            stream: Stream.periodic(const Duration(seconds: 1))
                                .asBroadcastStream(),
                            builder: (context, snapshot) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        // DateFormat('MM/dd/yyyy hh:mm:ss')
                                        DateFormat('hh').format(DateTime.now()),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 50,
                                        ),
                                      ),
                                      Text(
                                        // DateFormat('MM/dd/yyyy hh:mm:ss')
                                        DateFormat(':mm a')
                                            .format(DateTime.now()),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 50,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    // DateFormat('MM/dd/yyyy hh:mm:ss')
                                    DateFormat('E dd  MMM  yyyy')
                                        .format(DateTime.now()),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      Container(
                        height: 80,
                        margin: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            dockIconList.isNotEmpty
                                ? Image.memory(
                                    (dockIconList[0] as ApplicationWithIcon)
                                        .icon,
                                    width: 42,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      appops.addAppToDock('camera');
                                      dockIconList = appops.docklistitems;
                                    },
                                    icon: const Icon(
                                      Icons.cabin,
                                      color: Colors.black,
                                    )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                      ),
                    ],
                  )),
              GestureDetector(
                onTap: (() => FocusScope.of(context).unfocus()),
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 50, left: 10, right: 10, bottom: 10),
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: appops.searchAppList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final appls = appops.searchAppList[index];
                            return GestureDetector(
                              onTap: () {
                                appops.openApps(appls);
                              },
                              child: ListTile(
                                leading: Image.memory(
                                  (appls as ApplicationWithIcon).icon,
                                  width: 42,
                                ),
                                title: Text(
                                  appls.appName,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      TextField(
                          controller: _textEditingController,
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              border: const OutlineInputBorder(),
                              // labelText: 'Password',
                              hintText: "Search",
                              hintStyle: const TextStyle(color: Colors.white)),
                          onChanged: (String value) {
                            setState(() {
                              appops.searchApp(value);
                            });
                          }),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
    // void searchApp(String Query) {
    //   final suggestions = listApps.where((app) {
    //     appName = listApps.
    //   });
    // }
  }
}
