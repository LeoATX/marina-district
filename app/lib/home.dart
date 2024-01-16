import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'package:app/map.dart';
import 'package:app/menu.dart';
import 'package:app/reverse_geocoding.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

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
  late String distName;
  late String geocodeResponse;

  Future<String> minimumDelay() async {
    // minimum delay
    await Future.delayed(const Duration(seconds: 2));
    return 'delay complete';
  }

  Future<void> initLocation() async {
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
    // locationData = await location.getLocation();
    locationData = await location.getLocation();

    // init distName & geocodeResponse
    geocodeResponse = await getGeocodeResponse(locationData);
    distName = getDistrictName(geocodeResponse);
    print('location data complete');
  }

  // Future<String> initDistName() async {
  //   locationData = await initLocation();
  //   const uri = 'maps.googleapis.com';
  //   final Map<String, String> params = {
  //     'latlng': '${locationData.latitude}, ${locationData.longitude}',
  //     'key': 'AIzaSyCLSLujA8LsgKYlwKZbCe0ixQJ1R4_eHss'
  //   };
  //
  //   // make geocoding api call
  //   dynamic response =
  //       (await get(Uri.https(uri, 'maps/api/geocode/json', params))).body;
  //   distName = getDistrictName(response);
  //   return distName;
  // }

  Future<String> getSpotifyToken() async {
    const clientId = '783911c86b494ab282bd1623ca55998b';
    const clientSecret = String.fromEnvironment('spotifyClientSecret');
    print('getting spotify token');
    final response = (await post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body:
            'grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret'));

    final accessToken = jsonDecode(response.body)['access_token'];
    return accessToken;
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3000), (timer) async {
      spotifyToken = await getSpotifyToken();
      print('getting spotify token in init state');
    });
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
          return MapPage(
              initialLocationData: locationData,
              initialDistName: distName,
              initialGeocodeResponse: geocodeResponse);
        },
      ),
      CupertinoTabView(builder: (BuildContext context) {
        return const MenuPage();
      }),
    ];

    return FutureBuilder<List<dynamic>>(
        // future: Future.wait([bar, foo]),
        future:
            Future.wait([minimumDelay(), initLocation(), getSpotifyToken()]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            spotifyToken = snapshot.data![2];
            // return CupertinoTabScaffold(
            //   tabBar: CupertinoTabBar(
            //       items: const [
            //         BottomNavigationBarItem(
            //             icon: Icon(CupertinoIcons.map),
            //             activeIcon: Icon(CupertinoIcons.map_fill)),
            //         BottomNavigationBarItem(
            //             icon: Icon(CupertinoIcons.bookmark),
            //             activeIcon: Icon(CupertinoIcons.bookmark_fill)),
            //       ],
            //       activeColor: CupertinoTheme.of(context).primaryColor,
            //       border: const Border() // remove hairline border
            //       ),
            //   tabBuilder: (BuildContext context, int index) {
            //     // uses index from tabBuilder to navigate pages
            //     return pages[index];
            //   },
            // );
            return pages[0];
          } else {
            return CupertinoPageScaffold(
                child: Center(
                    child: Text('Marina',
                        style: TextStyle(
                            // fontFamily: 'JetBrains Mono',
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: CupertinoTheme.of(context).primaryColor))));
          }
        });
  }
}
