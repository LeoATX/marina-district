import 'package:app/home.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Brightness? brightness;
  Color? scaffoldBackgroundColor;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // control theme based on light or dark mode
    brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.dark) {
      scaffoldBackgroundColor = CupertinoColors.systemBackground;
    }
    else {
      scaffoldBackgroundColor = CupertinoColors.systemBackground;
    }
    
    return CupertinoApp(
      title: 'MD',
      theme: CupertinoThemeData(
          primaryColor: const Color.fromARGB(224, 90, 169, 225),
          textTheme: const CupertinoTextThemeData(
              textStyle: TextStyle(fontFamily: 'JetBrains Mono')),
          scaffoldBackgroundColor: scaffoldBackgroundColor),
      home: const HomePage(title: 'home'),
    );
  }
}
