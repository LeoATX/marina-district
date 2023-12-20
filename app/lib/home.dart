import 'package:flutter/cupertino.dart';
import 'package:app/map.dart';
import 'package:app/load.dart';
import 'package:location/location.dart';
import 'package:app/menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List pages;
  late LocationData locationData;

  // final Future<String> _calculation = Future<String>.delayed(
  //   const Duration(seconds: 2),
  //   () {
  //     return 'Data Loaded';
  //   },
  // );

  Future<String> minimumDelay() async {
    // minimum delay
    await Future.delayed(const Duration(seconds: 2));
    return 'delay complete';
  }

  Future<dynamic> initialLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    while (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    while (permissionGranted != PermissionStatus.granted) {
      permissionGranted = await location.requestPermission();
    }
    return await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    pages = [
      CupertinoTabView(
        builder: (BuildContext context) {
          return MapPage(initialLocationData: locationData);
        },
      ),
      CupertinoTabView(builder: (BuildContext context) {
        return const MenuPage();
      }),
    ];

    return FutureBuilder<List<dynamic>>(
        // future: Future.wait([bar, foo]),
        future: Future.wait([minimumDelay(), initialLocation()]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.map),
                      activeIcon: Icon(CupertinoIcons.map_fill)),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.bookmark),
                      activeIcon: Icon(CupertinoIcons.bookmark_fill)),
                ],
                activeColor: CupertinoTheme.of(context).primaryColor,
              ),
              tabBuilder: (BuildContext context, int index) {
                // uses index from tabBuilder to navigate pages
                locationData = snapshot.data![1];
                return pages[index];
              },
            );
          } else {
            return const LoadPage();
          }
        });
  }
}
