import 'dart:async';
import 'main.dart';
import 'package:app/reverse_geocoding.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'fetch_song.dart';

class MapPage extends StatefulWidget {
  const MapPage(
      {super.key,
      required this.initialLocationData,
      required this.initialDistName,
      required this.initialGeocodeResponse});

  final LocationData initialLocationData;
  final String initialDistName;
  final String initialGeocodeResponse;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // future map controller handling
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  // actual map controller after await
  late GoogleMapController mapController;
  bool cameraTrack = true; // settable with button

  // song recommendation page pop up
  bool getSongPressed = false;

  // marina district: LatLng(37.803, -122.436);

  // live location
  Location location = Location();

  // district name
  late String distName;

  dynamic geocodeResponse;

  void _onMapCreated(GoogleMapController controller) {
    this.controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    // live location monitoring
    location.onLocationChanged.listen((LocationData currentLocation) async {
      // Use current location
      locationData = currentLocation;
      // run once on map created
      mapController = await controller.future;

      if (cameraTrack) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                bearing: 0.0,
                target: LatLng(locationData.latitude!, locationData.longitude!),
                zoom: 16.16)));
      }
    });

    // district name
    locationData = widget.initialLocationData;
    distName = widget.initialDistName;
    geocodeResponse = widget.initialGeocodeResponse;

    // TODO: change for prod
    Timer.periodic(const Duration(seconds: 9999999), (timer) async {
      // make geocoding api call
      geocodeResponse = getGeocodeResponse(locationData);
      print('making api calls');
      distName = getDistrictName(geocodeResponse);

      setState(() {
        /* update response */
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        automaticallyImplyMiddle: false,
        middle: Text(
          distName,
          style: TextStyle(
              color: CupertinoTheme.of(context).primaryColor,
              // fontSize: 24,
              fontFamily: 'JetBrains Mono'),
        ),
        border: null,
        // backgroundColor: const Color(0x00ffffff),
      ),
      backgroundColor: const Color(0x00ffffff),
      child: Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerMove: (pointerMoveEvent) {
              setState(() {
                cameraTrack = false;
              });
            },
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.initialLocationData.latitude!,
                    widget.initialLocationData.longitude!),
                zoom: 16.16,
              ),
              onMapCreated: _onMapCreated,
              compassEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
          // Add button
          // SafeArea(
          //   top: true,
          //   child: Container(
          //     alignment: Alignment.topRight,
          //     child: Text(
          //       distName,
          //       style: TextStyle(
          //           color: CupertinoTheme.of(context).primaryColor,
          //           fontSize: 24,
          //           fontFamily: 'JetBrains Mono'),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              width: 160,
              child: CupertinoButton(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 10),
                  color: CupertinoTheme.of(context).primaryColor,
                  // TODO: implement get songs on pressed
                  onPressed: () async {
                    getSongPressed = true;
                    setState(() {});
                  },
                  minSize: 0,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Get Song',
                          style: TextStyle(color: CupertinoColors.white)),
                      Icon(
                        CupertinoIcons.music_note_2,
                        color: CupertinoColors.white,
                      )
                    ],
                  )),
            ),
          ),
          // Recenter
          Builder(builder: (context) {
            if (!cameraTrack) {
              return Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  width: 160,
                  child: CupertinoButton(
                      padding: const EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 10),
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      onPressed: () {
                        setState(() {
                          cameraTrack = true;
                          mapController.animateCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  bearing: 0.0,
                                  target: LatLng(locationData.latitude!,
                                      locationData.longitude!),
                                  zoom: 16.16)));
                        });
                      },
                      minSize: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Recenter',
                              style: TextStyle(
                                  color: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .color)),
                          Icon(
                            CupertinoIcons.location_fill,
                            color: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .color,
                          )
                        ],
                      )),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          Builder(builder: (context) {
            if (getSongPressed) {
              return FutureBuilder(future: Future(() async {
                Future<List> songs =
                    getSongs(await getGenre(getDistrictName(geocodeResponse)));
                return songs;
              }), builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    heightFactor: 0.5,
                    child: Container(),
                  );
                } else {
                  return Container();
                }
              });
            } else {
              return const SizedBox.shrink();
            }
          })
        ],
      ),
    );
  }
}
