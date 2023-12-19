import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.initialLocationData});
  final LocationData initialLocationData;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // google maps stuff
  late GoogleMapController mapController;
  late LocationData locationData;
  // final center = const LatLng(37.803, -122.436);

  // live location
  Location location = Location();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void currentLocation() async {
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      locationData = locationData;
      Future.delayed(const Duration(seconds: 15), districtMapCall);
    });
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
