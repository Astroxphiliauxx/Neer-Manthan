import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/screens/full_map.dart';
import 'package:flutter_map/provider/map_provider/location_provider.dart';
import '../provider/map_provider/circle_outline_map_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.674777410675873, 77.50341320602973),
    zoom: 10,
  );

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Aqua Predict'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_2_outlined),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.water_drop, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Aqua Predict',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Full Map View'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FullScreenMap()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed((context), '/theme');
    
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
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
                        offset: const Offset(0, 3),
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
                        child: Consumer2<MapState, LocationState>(
                          builder: (context, mapState, locationState, child) {
                            return GoogleMap(
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              zoomControlsEnabled: true,
                              mapType: MapType.normal,
                              circles: mapState!.circles,
                              onTap: (LatLng position) {
                                locationState.updateSelectedLocation(position);
                                mapState?.updateCircle(position);
                              },
                            );
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
                                offset: const Offset(0, 2), // Shadow position
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search location',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            onSubmitted: (value) {},
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FullScreenMap()),
                            );
                          },
                          backgroundColor: Colors.white,
                          mini: true,
                          child: const Icon(
                            Icons.fullscreen,
                            color: Colors.blueAccent,
                          ), // Smaller button size
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
            
                // Display selected location details
                Consumer<LocationState>(
                  builder: (context, locationState, child) {
                    if (locationState.selectedLocation != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Selected Location:",
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Latitude:",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            color: Colors.black12,
                            child: Center(
                              child: Text(
                                locationState.selectedLocation!.latitude.toStringAsFixed(6),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Longitude:",
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            color: Colors.black12,
                            child: Center(
                              child: Text(
                                locationState.selectedLocation!.longitude.toStringAsFixed(6),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text(
                        "Tap on the map to select a location.",
                        style: TextStyle(fontSize: 26, color: Colors.grey),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
