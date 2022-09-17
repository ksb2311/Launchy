import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher/operations/appops.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final AppOps appops = AppOps();
    List<Application> dockIconList = [];

    const themeColor = Colors.white;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: Colors.black,
          child: PageView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              // HomePage
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
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        // itemCount: appops.searchAppList.length,
                        // itemBuilder: (BuildContext context, int index) {
                        //   final appls = appops.searchAppList[index];
                        //   return ListTile(
                        //     leading: Image.memory(
                        //       (appls as ApplicationWithIcon).icon,
                        //       width: 42,
                        //     ),
                        //     title: Text(
                        //       appls.appName,
                        //       style: const TextStyle(color: themeColor),
                        //     ),
                        //   );
                        // },
                        itemCount: appops.searchAppList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              "hkjhlkh",
                              style: TextStyle(color: themeColor),
                            ),
                          );
                        },
                      ),
                    ),
                    TextField(
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: themeColor, width: 2)),
                            // labelText: 'Password',
                            hintText: "Search",
                            hintStyle: const TextStyle(color: themeColor)),
                        onChanged: (String value) {
                          setState(() {
                            appops.searchApp(value);
                          });
                        }),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
