import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:submission_intermediate/providers/map_provider.dart';

class StoryLocationScreen extends StatefulWidget {
  final Function onPop;
  final LatLng latLng;
  const StoryLocationScreen(
      {super.key, required this.latLng, required this.onPop});

  @override
  State<StoryLocationScreen> createState() => _StoryLocationScreenState();
}

class _StoryLocationScreenState extends State<StoryLocationScreen> {
  late LatLng _latLng;
  late GoogleMapController mapController;
  late MapProvider _mapProvider;
  bool detail = false;
  double containerHeight = 0;

  final Set<Marker> markers = {};

  Future<void> getAddresses() async {
    await _mapProvider.getMainAddress(_latLng);
    await _mapProvider.getSubAddress(_latLng);
    debugPrint('getting address.');
    return;
  }

  _zoomLatLng(LatLng latLng, double zoom) {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_latLng, 18),
    );
  }

  _zoomCamera(CameraUpdate value) {
    mapController.animateCamera(value);
  }

  _toggleAddress() {
    Future.delayed(const Duration(milliseconds: 300), () {
      return getAddresses();
    });
    _zoomLatLng(_latLng, 20);
    setState(() {
      detail = !detail;
      containerHeight = detail ? 150 : 0;
    });
  }

  _loadMarkers() {
    _latLng = widget.latLng;
    final marker = Marker(
      markerId: const MarkerId("location"),
      position: _latLng,
      onTap: () => _toggleAddress(),
    );
    markers.add(marker);
  }

  @override
  void initState() {
    _loadMarkers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mapProvider = Provider.of<MapProvider>(context);

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
                markers: markers,
                initialCameraPosition: CameraPosition(
                  target: _latLng,
                  zoom: 18,
                ),
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
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
                              CameraUpdate.newLatLngZoom(_latLng, 14)),
                          child: const Icon(
                            Icons.location_searching_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Visibility(
                      visible: detail,
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
          )
        ],
      ),
    );
  }
}
