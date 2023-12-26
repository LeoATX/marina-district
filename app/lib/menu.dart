import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:app/map.dart';
import 'package:http/http.dart';

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
    response = 'hello';

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      // response = (await get(Uri.parse('https://httpbin.org/'))).body;
      // ignore: avoid_print
      print(response);
      setState(() {
        /* update response */
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (BuildContext context) {
        return Center(
          child: Text(
              """${locationData.altitude}, ${locationData.longitude.toString()}\n
              $response
              """),
        );
      },
    );
  }
}
