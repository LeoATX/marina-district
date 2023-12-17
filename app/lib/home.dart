import 'package:flutter/cupertino.dart';
import 'package:app/map.dart';

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
  var pages = [
    CupertinoTabView(
      builder: (BuildContext context) {
        return const MapPage();
      },
    ),
    CupertinoTabView(
      builder: (BuildContext context) {
        return const Center(
          child: Text('Hello World'),
        );
      },
    )
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.map)),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.bookmark)),
      ]),
      tabBuilder: (BuildContext context, int index) {
        // uses index from tabBuilder to navigate pages
        return pages[index];
      },
    );
  }
}
