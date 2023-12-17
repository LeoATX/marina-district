import 'package:app/home.dart';
import 'package:flutter/cupertino.dart';


void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'MD',
      theme: CupertinoThemeData(
        primaryColor: Color.fromARGB(224, 90, 169, 225),
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
