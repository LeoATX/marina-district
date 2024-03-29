import 'package:flutter/cupertino.dart';
import 'main.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<StatefulWidget> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String response = 'none';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return Center(
          child:
              Text("""${locationData.altitude}, ${locationData.longitude}"""),
        );
      },
    );
  }
}
