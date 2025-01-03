import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/common_widgets/custom_bg.dart';
import 'package:flutter_map/const/urls.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/screens/full_map.dart';
import 'package:flutter_map/provider/map_provider/location_provider.dart';
import 'package:uuid/uuid.dart';
import '../provider/map_provider/circle_outline_map_provider.dart';
import 'package:flutter_map/utils/place_suggestions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.674777410675873, 77.50341320602973),
    zoom: 20,
  );

  final TextEditingController _searchController = TextEditingController();
  var uuid = Uuid();
  late String _sessionToken=  "112233";

  List<dynamic> _placesList= [];


  @override
  void initState() {
    super.initState();
    _searchController.addListener((){
      onChange();
    });
  }

  void onChange() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _placesList.clear();
      });
      return;
    }

    if (_sessionToken == "") {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    final apiKey = AppConstants.googleMapsApiKey; // Your API key
    final suggestions = await getSuggestion(
      input: _searchController.text,
      sessionToken: _sessionToken,
      apiKey: apiKey,
    );

    setState(() {
      _placesList = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    final locationState = Provider.of<LocationState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                    'Neer Manthan',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Full Map View'),
              onTap: () {
                Navigator.pop(context);
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
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('WL AND RAINFALL'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          custom_bg(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
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
                            borderRadius: BorderRadius.circular(20),
                            child: GoogleMap(
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              zoomControlsEnabled: true,
                              mapType: MapType.normal,
                              circles: mapState.circles,
                              onTap: (LatLng position) {
                                locationState.updateSelectedLocation(position);
                                mapState.updateCircle(position);
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
                                    offset: const Offset(0, 2),
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
                                onSubmitted: (value) async {
                                  if (value.isNotEmpty) {
                                    try {
                                      List<Location> locations = await locationFromAddress(value);
                                      if (locations.isNotEmpty) {
                                        Location selectedLocation = locations.first;
                                        _searchController.text = value;
                                        locationState.updateSelectedLocation(
                                          LatLng(selectedLocation.latitude, selectedLocation.longitude),
                                        );
                                      }
                                    } catch (e) {
                                      print("Error fetching location: $e");
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          // Place Suggestions List
                          if (_placesList.isNotEmpty)
                            Positioned(
                              top: 70,
                              left: 10,
                              right: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _placesList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        _placesList[index]['description'],
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      onTap: () async {
                                        try {
                                          List<Location> locations = await locationFromAddress(
                                            _placesList[index]['description'],
                                          );
                                          if (locations.isNotEmpty) {
                                            _searchController.text = _placesList[index]['description'];

                                            Location selectedLocation = locations.first;

                                            final GoogleMapController mapController = await _controller.future;
                                            await mapController.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                  target: LatLng(selectedLocation.latitude, selectedLocation.longitude),
                                                  zoom: 10,
                                                ),
                                              ),
                                            );

                                            Provider.of<MapState>(context, listen: false).updateCircle(
                                              LatLng(selectedLocation.latitude, selectedLocation.longitude),
                                            );

                                            Provider.of<LocationState>(context, listen: false).updateSelectedLocation(
                                              LatLng(selectedLocation.latitude, selectedLocation.longitude),
                                            );

                                            // Clear suggestions and reset session token
                                            setState(() {
                                              _placesList.clear();
                                              _searchController.clear();
                                              _sessionToken = "";
                                            });
                                          }
                                        } catch (e) {
                                          print("Error handling suggestion tap: $e");
                                        }
                                      },


                                    );
                                  },
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/fullMap');
                              },
                              backgroundColor: Colors.white,
                              mini: true,
                              child: const Icon(
                                Icons.fullscreen,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (locationState.selectedLocation != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Selected Location:",
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Latitude: ${locationState.selectedLocation!.latitude.toStringAsFixed(6)}",
                            style: const TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Longitude: ${locationState.selectedLocation!.longitude.toStringAsFixed(6)}",
                            style: const TextStyle(fontSize: 20, color: Color(0xFFFFFFFF)),
                          ),
                        ],
                      )
                    else
                      const Text(
                        "Tap on the map to select a location.",
                        style: TextStyle(fontSize: 26, color: Colors.black12),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}