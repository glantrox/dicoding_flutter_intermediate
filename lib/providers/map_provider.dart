import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:submission_intermediate/core/api/map_repository.dart';

import '../core/utils/handler.dart';

class MapProvider extends ChangeNotifier {
  final MapRepository mapRepository;
  MapProvider(this.mapRepository);

  String currentMainAddress = "Main Address";
  String currentSubAddress = "Sub Address";

  Position? currentPosition;
  LatLng? _currentLatLng;
  LatLng? get currentLatLng => _currentLatLng;

  // O=========================================================================>
  // ? Get Main Address by LatLng
  // <=========================================================================O

  Future<void> getMainAddress(LatLng latLng) async {
    final result = await mapRepository.getMainAddress(latLng);
    if (result != null) {
      currentMainAddress = result;
      notifyListeners();
    } else {
      throw Exception('Address not Found');
    }
    notifyListeners();
  }

  // O=========================================================================>
  // ? Get Sub Address by LatLng
  // <=========================================================================O

  Future<void> getSubAddress(LatLng latLng) async {
    final result = await mapRepository.getSubAddress(latLng);
    if (result != null) {
      currentSubAddress = result;
      notifyListeners();
    } else {
      throw Exception('Address not Found');
    }
    notifyListeners();
  }

  // O=========================================================================>
  // ? Get Current Position
  // <=========================================================================O

  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
      notifyListeners();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // O=========================================================================>
  // ? Additional Functions
  // <=========================================================================O

  // Set Current State of Latitude Longitude
  Future<void> setCurrentLocation(LatLng latLng) async {
    _currentLatLng = latLng;
    notifyListeners();
    return;
  }

  // Clears Current State of Latitude Longitude
  Future<void> clearLatLng() async {
    _currentLatLng = null;
    notifyListeners();
  }
}
