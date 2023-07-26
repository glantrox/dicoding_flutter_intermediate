import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MapUtils {
  Future<String?> getStreetName(LatLng latLng, String addressValue) async {
    try {
      final info =
          await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      final place = info[0];

      switch (addressValue) {
        case "address":
          return place.name;
        case "all-address":
          return '${place.street}, ${place.subAdministrativeArea}, ${place.locality}, ${place.country} ';
      }
    } catch (e) {
      return "Error getting address";
    }
    return null;
  }
}
