import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:submission_intermediate/providers/map_provider.dart';

class SetLocationScreen extends StatefulWidget {
  final Function onPop;
  final Function onSaveLocation;
  const SetLocationScreen(
      {super.key, required this.onPop, required this.onSaveLocation});

  @override
  State<SetLocationScreen> createState() => SetLocationScreenState();
}

class SetLocationScreenState extends State<SetLocationScreen> {
  late GoogleMapController mapController;
  late MapProvider _mapProvider;
  late LatLng? _latLng;
  bool detail = false;
  double containerHeight = 0;

  Set<Marker> markers = {};
  _zoomCamera(CameraUpdate value) {
    mapController.animateCamera(value);
  }

  _loadMarkers(LatLng latLng) async {
    final marker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: const MarkerId("id"),
      position: latLng,
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      return getAddresses();
    });
    setState(() {
      _latLng = latLng;
      mapController.animateCamera(CameraUpdate.newLatLng(latLng));
      Future.delayed(const Duration(milliseconds: 300), () {
        markers.add(marker);
      });
      detail = !detail;
      containerHeight = detail ? 300 : 0;
      detail = !detail;
    });
  }

  Future<void> getAddresses() async {
    await _mapProvider.getMainAddress(_latLng!);
    await _mapProvider.getSubAddress(_latLng!);
    debugPrint('getting address.');
    return;
  }

  Future<void> setLocation() async {
    await _mapProvider.setCurrentLocation(_latLng!);
  }

  @override
  void initState() {
    _mapProvider = Provider.of<MapProvider>(context, listen: false);
    _latLng = LatLng(_mapProvider.currentPosition!.latitude,
        _mapProvider.currentPosition!.longitude);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentLatLng = LatLng(_mapProvider.currentPosition!.latitude,
        _mapProvider.currentPosition!.longitude);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: const BoxDecoration(color: Colors.grey),
            child: Center(
              child: GoogleMap(
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: (controller) async {
                  setState(() {
                    mapController = controller;
                  });
                  Future.delayed(const Duration(milliseconds: 300), () {
                    return _loadMarkers(_latLng!);
                  });
                },
                onTap: (argument) => _loadMarkers(argument),
                initialCameraPosition: CameraPosition(
                  target: LatLng(_mapProvider.currentPosition!.latitude,
                      _mapProvider.currentPosition!.longitude),
                  zoom: 18,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 40,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton.small(
                          backgroundColor: Colors.blue,
                          heroTag: "zoom-in",
                          onPressed: () => _zoomCamera(CameraUpdate.zoomIn()),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        FloatingActionButton.small(
                          backgroundColor: Colors.blue,
                          heroTag: "zoom-out",
                          onPressed: () => _zoomCamera(CameraUpdate.zoomOut()),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                        FloatingActionButton.small(
                          backgroundColor: Colors.blue,
                          heroTag: "zoom-in",
                          onPressed: () => _zoomCamera(
                              CameraUpdate.newLatLngZoom(currentLatLng, 14)),
                          child: const Icon(
                            Icons.location_searching_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Visibility(
                      visible: _latLng == null ? false : true,
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          margin: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _mapProvider.currentMainAddress,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              Text(
                                _mapProvider.currentSubAddress,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.grey),
                              ),
                              const SizedBox(height: 22),
                              GestureDetector(
                                onTap: () {
                                  setLocation();

                                  widget.onSaveLocation();
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: const Center(
                                    child: Text(
                                      'Set Location',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: IconButton(
                onPressed: () => widget.onPop(),
                icon: Container(
                    margin: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_back_ios_new))),
          ),
        ],
      ),
    );
  }
}
