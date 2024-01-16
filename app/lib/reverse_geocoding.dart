// const uri = 'maps.googleapis.com';
// const params = {
//   'latlng': '37.803, -122.436',
//   'key': 'AIzaSyCLSLujA8LsgKYlwKZbCe0ixQJ1R4_eHss'
// };
import 'dart:convert';
import 'package:http/http.dart';
import 'package:location/location.dart';

String getDistrictName(dynamic response) {
  String distName = "not available";
  // dynamic response =
  //     (await get(Uri.https(uri, 'maps/api/geocode/json', params))).body;
  response = jsonDecode(response);
  ReverseGeocoding reverseGeocoding = ReverseGeocoding.fromJson(response);

  // loop through to try and get neighborhood
  resultLoop:
  for (var result in reverseGeocoding.results) {
    for (var component in result.addressComponent) {
      if (component.types.contains('neighborhood')) {
        distName = component.longName;
        break resultLoop;
      }
      if (component.types.contains('locality')) {
        distName = component.longName;
        break resultLoop;
      }
      if (component.types.contains('administrative_area_level_2')) {
        distName = component.longName;
        break resultLoop;
      }
      if (component.types.contains('administrative_area_level_1')) {
        distName = component.longName;
        break resultLoop;
      }
    }
  }

  return distName;
}

String getDistAddress(dynamic response) {
  String distAddress = "";
  response = jsonDecode(response);
  ReverseGeocoding reverseGeocoding = ReverseGeocoding.fromJson(response);

  for (var result in reverseGeocoding.results) {
    if (distAddress != "") {
      return distAddress;
    }
    for (var index = 0; index < result.addressComponent.length; index += 1) {
      // break here if possible
      if (result.addressComponent[index].types.contains('neighborhood')) {
        distAddress = "$distAddress${result.addressComponent[index].longName}";
      }
      if (result.addressComponent[index].types.contains('locality')) {
        if (distAddress == "") {
          distAddress =
              "$distAddress${result.addressComponent[index].longName}";
        } else {
          distAddress =
              "$distAddress, ${result.addressComponent[index].longName}";
        }
      }
      if (result.addressComponent[index].types
          .contains('administrative_area_level_1')) {
        if (distAddress == "") {
          distAddress =
              "$distAddress${result.addressComponent[index].longName}";
        } else {
          distAddress =
              "$distAddress, ${result.addressComponent[index].longName}";
        }
      }
    }
  }

  return distAddress;
}

Future<String> getGeocodeResponse(LocationData locationData) async {
  const uri = 'maps.googleapis.com';
  Map<String, String> params = {
    'latlng': '${locationData.latitude}, ${locationData.longitude}',
    'key': 'AIzaSyCLSLujA8LsgKYlwKZbCe0ixQJ1R4_eHss'
  };
  // make geocoding api call
  Response geocodeResponse =
      (await get(Uri.https(uri, 'maps/api/geocode/json', params)));
  return geocodeResponse.body;
}

class ReverseGeocoding {
  final List<Place> results;
  final String status;

  ReverseGeocoding({required this.results, required this.status});

  // const uri = 'maps.googleapis.com';
  // const params = {
  //   'latlng': '37.803, -122.436',
  //   'key': 'AIzaSyCLSLujA8LsgKYlwKZbCe0ixQJ1R4_eHss'
  // };

  // dynamic response =
  //     (await get(Uri.https(uri, 'maps/api/geocode/json', params))).body;
  //   response = jsonDecode(response);
  //   ReverseGeocoding.fromJson(response as Map<String, dynamic>)
  factory ReverseGeocoding.fromJson(Map<String, dynamic> json) {
    return ReverseGeocoding(
        results:
            List<Place>.from(json['results'].map((x) => Place.fromJson(x))),
        status: json['status']);
  }
}

class Place {
  final List<AddressComponent> addressComponent;
  final String formattedAddress;

  Place({required this.addressComponent, required this.formattedAddress});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        addressComponent: List<AddressComponent>.from(json['address_components']
            .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json['formatted_address']);
  }
}

class AddressComponent {
  final String longName;
  final String shortName;
  final List<String> types;

  AddressComponent(this.longName, this.shortName, this.types);

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(json['long_name'], json['short_name'],
        List<String>.from(json['types']));
  }
}
