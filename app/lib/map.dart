import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

late LocationData locationData;

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.initialLocationData});

  final LocationData initialLocationData;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // future map controller handling
  final Completer<GoogleMapController> controller =
      Completer<GoogleMapController>();

  // actual map controller after await
  late GoogleMapController mapController;
  bool cameraTrack = true; // settable with buttons

  // marina district: LatLng(37.803, -122.436);

  // live location
  Location location = Location();

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    this.controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        automaticallyImplyMiddle: false,
        middle: Text(
          'hello',
          style: TextStyle(
              color: CupertinoTheme.of(context).primaryColor,
              fontFamily: 'JetBrains Mono'),
        ),
        border: null,
        // backgroundColor: const Color(0x00ffffff),
        // padding: EdgeInsetsDirectional.only(top: 5),
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
              compassEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 50),
                  child: const Text('hello')),
            ],
          ),
          if (!cameraTrack)
            // Recenter
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              width: 160,
              child: CupertinoButton(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 10),
                  color: CupertinoColors.activeBlue,
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Recenter', style: TextStyle()),
                      Icon(CupertinoIcons.location_fill)
                    ],
                  )),
            )
        ],
      ),
    );
  }
}
