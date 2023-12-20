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
// google maps stuff
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  // late LocationData locationData;
  bool cameraTrack = false;
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
      final GoogleMapController liveController = await mapController.future;

      if (cameraTrack) {
        liveController.moveCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0.0,
            target: LatLng(locationData.latitude!, locationData.longitude!), 
            zoom: 16.16
            )));
      }

      Future.delayed(const Duration(seconds: 15), districtMapCall);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
  }

  LatLng districtMapCall() {
    return const LatLng(37.803, -122.436);
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
