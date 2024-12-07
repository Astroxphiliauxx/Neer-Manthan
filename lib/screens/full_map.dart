import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/map_provider/circle_outline_map_provider.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({super.key});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(28.674777410675873, 77.50341320602973),
    zoom: 10,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<MapState>(
              builder: (context, mapState, child) {
                return GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: true,
                  mapType: MapType.normal,
                  circles: mapState.circles,
                  onTap: (LatLng position) {
                    mapState.updateCircle(position);
                  },
                );
              },
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: FloatingActionButton(
                onPressed: () {

                  Navigator.pop(context);
                },
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.fullscreen,
                  color: Colors.blueAccent,
                ),
                mini: true, // Smaller button size
              ),
            ),
          ],
        ),
      ),
    );
  }


}
