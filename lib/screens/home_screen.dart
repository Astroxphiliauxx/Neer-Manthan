import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/screens/full_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(28.674777410675873, 77.50341320602973),
    zoom: 14,
  );

  TextEditingController _searchController = TextEditingController();
  LatLng? _selectedLocation;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Maps',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Container
              Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
                child: Stack(
                 children: [
                   ClipRRect(
                     borderRadius: BorderRadius.circular(20), // Clip map inside rounded corners
                     child: GoogleMap(
                       initialCameraPosition: _kGooglePlex,
                       onMapCreated: (GoogleMapController controller) {
                       _controller.complete(controller);
                       },
                       zoomControlsEnabled: true,
                       mapToolbarEnabled: true,
                       mapType: MapType.normal,
                       onTap: (LatLng position) {
                       setState(() {
                        _selectedLocation = position;
                       });
                    },
                  ),
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
                           // Handle search functionality
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
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>FullScreenMap()));
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
          ),
        
              const SizedBox(height: 20),
        
              if (_selectedLocation != null) ...[
                Text(
                  "Selected Location:",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "Latitude:",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  color: Colors.white70,
                  child: Center(
                      child:
                         Text("${_selectedLocation!.latitude.toStringAsFixed(6)}",
                         style: TextStyle(fontSize: 20),),
                            ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Longitude:",
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  color: Colors.white70,
                  child: Center(
                    child:
                    Text("${_selectedLocation!.longitude.toStringAsFixed(6)}",
                      style: TextStyle(fontSize: 20),),
                  ),
                ),
              ] else
                Text(
                  "Tap on the map to select a location.",
                  style: TextStyle(fontSize: 26, color: Colors.grey),
                ),
        
              const SizedBox(height: 20),
        
              ElevatedButton.icon(
                onPressed: _selectedLocation != null
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Location Selected: (${_selectedLocation!.latitude}, ${_selectedLocation!.longitude})",
                      ),
                    ),
                  );
                }
                    : null, // Disable button if no location is selected
                icon: Icon(Icons.location_on),
                label: Text("Use this location"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedLocation != null
                      ? Colors.blue
                      : Colors.grey, // Change button color based on state
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
