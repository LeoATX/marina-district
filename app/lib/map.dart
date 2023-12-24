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
  bool cameraTrack = false; // settable with buttons

  // marina district: LatLng(37.803, -122.436);

  // live location
  Location location = Location();

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
  }

  void _onMapCreated(GoogleMapController controller) {
    this.controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.initialLocationData.latitude!,
                widget.initialLocationData.longitude!),
            zoom: 16.16,
          ),
          onMapCreated: _onMapCreated,
          compassEnabled: false,
          myLocationEnabled: true),
    );
  }
}
