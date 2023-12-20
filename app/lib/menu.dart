import 'package:flutter/cupertino.dart';
import 'package:app/map.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _MenuPageState();
}

class _MenuPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return Center(
          child: Text(
              '${locationData.altitude}, ${locationData.longitude.toString()}',
              // style: const TextStyle(
              //     color: CupertinoDynamicColor.withBrightness(
              //         color: CupertinoColors.black,
              //         darkColor: CupertinoColors.white))
                      ),
        );
      },
    );
  }
}
