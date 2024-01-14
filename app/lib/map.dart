import 'dart:async';

// import 'dart:convert';
import 'package:flutter/services.dart';

import 'fetch_song.dart';
import 'main.dart';
import 'package:app/reverse_geocoding.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:location/location.dart';
import 'track.dart';

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

  late String mapStyle;

  // song recommendation page pop up
  bool getSongPressed = false;

  // marina district: LatLng(37.803, -122.436);

  // live location
  Location location = Location();

  // district name
  late ValueNotifier<String> distName;

  dynamic geocodeResponse;

  late List tracks;

  late List<dynamic> previewPlayers = [];

  // recenter & getSong inset amount
  static const double buttonInset = 20;

  // fetch songs for SongPage
  Future<bool> initSongs() async {
    // Future to get songs
    final String genre = await getGenre(getDistAddress(geocodeResponse));
    final List tracks = await getTracks(genre);
    // "return" tracks
    this.tracks = tracks;

    // create players
    for (final track in tracks) {
      if (track['preview_url'] != null) {
        final player = AudioPlayer();
        await player.setUrl(track['preview_url']);
        await player.setLoopMode(LoopMode.one);
        previewPlayers.add(player);
      } else {
        previewPlayers.add(null);
      }
    }
    return true;
  }

  void _onMapCreated(GoogleMapController controller) async {
    this.controller.complete(controller);
    mapStyle = await rootBundle.loadString('assets/MapStyle.json');
    await mapController.setMapStyle(mapStyle);
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
                target: LatLng(locationData.latitude!, locationData.longitude!),
                zoom: 16.16)));
      }
    });

    // get string from MapStyle.json

    // district name
    locationData = widget.initialLocationData;
    // distName = widget.initialDistName;
    distName = ValueNotifier<String>(widget.initialDistName);
    geocodeResponse = widget.initialGeocodeResponse;

    // TODO: change for prod
    Timer.periodic(const Duration(seconds: 5555), (timer) async {
      // make geocoding api call
      geocodeResponse = await getGeocodeResponse(locationData);
      print('making geolocation api calls');
      // distName = getDistrictName(geocodeResponse);
      distName.value = getDistrictName(geocodeResponse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        automaticallyImplyMiddle: false,
        middle: ValueListenableBuilder<String>(
          builder: (BuildContext context, String distName, Widget? child) {
            return Text(
              distName,
              style: TextStyle(
                  color: CupertinoTheme.of(context).primaryColor,
                  // fontSize: 24,
                  fontFamily: 'JetBrains Mono'),
            );
          },
          valueListenable: distName,
        ),
        border: null,
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
              // cloudMapId: '54bef6d26d4a77df',
            ),
          ),

          // get song button
          Align(
            alignment: Alignment.bottomRight,
            child: Builder(builder: (context) {
              if (!getSongPressed) {
                return Container(
                  padding: const EdgeInsets.only(
                      right: buttonInset, bottom: buttonInset),
                  width: 160,
                  child: CupertinoButton(
                      padding: const EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 10),
                      color: CupertinoTheme.of(context).primaryColor,
                      onPressed: () async {
                        setState(() {
                          getSongPressed = true;
                        });
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
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
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
                      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
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

          // song view container
          GestureDetector(
            // needed to prevent google maps from triggering setState
            behavior: HitTestBehavior.opaque,
            child: Builder(builder: (context) {
              if (getSongPressed) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).barBackgroundColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  margin: const EdgeInsets.all(20),
                  child: FutureBuilder(
                      future: initSongs(),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        // return song page within container
                        if (snapshot.data != null) {
                          return TrackPage(
                              tracks: tracks, players: previewPlayers);
                        } else {
                          // loading screen
                          return CupertinoActivityIndicator(
                            color: CupertinoTheme.of(context)
                                .textTheme
                                .textStyle
                                .color,
                            radius: 16,
                          );
                        }
                      }),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ),

          // closing button
          Builder(builder: (context) {
            if (getSongPressed) {
              return Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      getSongPressed = !getSongPressed;
                    });
                  },
                  child: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    size: 32,
                    color: CupertinoTheme.of(context).primaryColor,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          })
        ],
      ),
    );
  }
}
