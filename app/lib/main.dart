import 'package:app/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

void main() {
  runApp(const App());
}

// Global Variables
// location data
late LocationData locationData;
// Spotify Token
late String spotifyToken;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Brightness? brightness;
  Color? backgroundColor;
  Color? textColor;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // control theme based on light or dark mode
    brightness = MediaQuery.of(context).platformBrightness;
    // dark mode
    if (brightness == Brightness.dark) {
      backgroundColor = const Color(0xFF1F2A39);
      textColor = CupertinoColors.white;
    }
    // light mode
    else {
      backgroundColor = CupertinoColors.systemBackground;
      textColor = CupertinoColors.label;
    }

    return CupertinoApp(
      title: 'MD',
      theme: CupertinoThemeData(
          primaryColor: const Color.fromARGB(255, 90, 169, 225),
          textTheme: CupertinoTextThemeData(
              textStyle:
                  TextStyle(color: textColor, fontFamily: 'JetBrains Mono')),
          barBackgroundColor: backgroundColor,
          scaffoldBackgroundColor: backgroundColor),
      home: const HomePage(title: 'home'),
    );
  }
}
