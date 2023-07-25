import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/map.dart';

class MapRepository {
  Future<String?> getMainAddress(LatLng latLng) async {
    String? result = await MapUtils().getStreetName(latLng, 'address');
    return result;
  }

  Future<String?> getSubAddress(LatLng latLng) async {
    String? result = await MapUtils().getStreetName(latLng, 'all-address');
    return result;
  }
}
