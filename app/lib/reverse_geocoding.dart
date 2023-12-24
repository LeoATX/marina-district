// void main() async {
// var request = Request(
//     'GET',
//     Uri.parse(
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=37.803, -122.436&key=AIzaSyCg9uv44YTyBI2U5vKNV2y8sjaRV9QbAq4'));
//
// StreamedResponse response = await request.send();
//
//
//
// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// } else {
//   print(response.reasonPhrase);
const uri = 'maps.googleapis.com';
const params = {
  'latlng': '37.803, -122.436',
  'key': 'AIzaSyCg9uv44YTyBI2U5vKNV2y8sjaRV9QbAq4'
};

class ReverseGeocoding {
  final List<Place> results;
  final String status;

  ReverseGeocoding({required this.results, required this.status});

  // const uri = 'maps.googleapis.com';
  // const params = {
  //   'latlng': '37.803, -122.436',
  //   'key': 'AIzaSyCg9uv44YTyBI2U5vKNV2y8sjaRV9QbAq4'
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
