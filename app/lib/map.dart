import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

late LocationData locationData;

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.initialLocationData});
  final LocationData initialLocationData;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
// google maps stuff
  late GoogleMapController mapController;
  // late LocationData locationData;
  bool cameraTrack = true;
  // marina district: LatLng(37.803, -122.436);

  // live location
  Location location = Location();

  @override
  void initState() {
    super.initState();

    // live location monitoring
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      locationData = currentLocation;

      // if (cameraTrack) {
      //   mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      //       target: LatLng(locationData.latitude!, locationData.longitude!))));
      // }

      Future.delayed(const Duration(seconds: 15), districtMapCall);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
            zoom: 14,
          ),
          onMapCreated: _onMapCreated,
          compassEnabled: false,
          myLocationEnabled: true),
    );
  }
}
