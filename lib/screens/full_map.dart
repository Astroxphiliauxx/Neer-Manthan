import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/screens/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({super.key});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(28.674777410675873, 77.50341320602973),
    zoom: 14,
  );

  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
        centerTitle: true,
      ),
      body: Stack(
        children: [

             GoogleMap(
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              zoomControlsEnabled: true,
              mapToolbarEnabled: true,
              mapType: MapType.normal,
              onTap: (LatLng position) {
                setState((){

                });
              },
            ),

          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2), // Shadow position
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search location',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
                onSubmitted: (value) {

                  print("Search for: $value");
                },
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.fullscreen,
                color: Colors.blueAccent,
              ),
              mini: true, // Smaller button size
            ),
          ),
        ],
      ),
    );
  }
}
