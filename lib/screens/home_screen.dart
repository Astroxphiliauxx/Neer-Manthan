import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/common_widgets/custom_bg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/screens/full_map.dart';
import 'package:flutter_map/provider/map_provider/location_provider.dart';
import 'package:uuid/uuid.dart';
import '../provider/map_provider/circle_outline_map_provider.dart';
import 'package:http/http.dart' as http;

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
  var uuid = Uuid();
  String _SessionToken=  '112233';

  List<dynamic> _placesList= [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener((){
      onChange();
    });
  }

  void onChange(){
    if(_SessionToken==null){
      setState(() {
        _SessionToken=uuid.v4();
      });
    }
    getSuggestion(_searchController.text);
  }

  void getSuggestion(String input) async{
    String kPLACES_API_KEY= "AIzaSyCvv6_VkZFnr7VKmX6lkF9-wOCLPPd5-7o";
    String baseURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_SessionToken';

    try {
      var response = await http.get(Uri.parse(request));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _placesList = jsonDecode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //cool
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

                              onSubmitted: (value) async {

                                  if (value.isNotEmpty) {
                                    try {
                                      // Fetch the location based on the submitted value
                                      List<Location> locations = await locationFromAddress(value);
                                      if (locations.isNotEmpty) {
                                        Location selectedLocation = locations.first;

                                        // Update search text
                                        _searchController.text = value;

                                        // Update location using state management
                                        context.read<LocationState>().updateSelectedLocation(
                                          LatLng(selectedLocation.latitude, selectedLocation.longitude),
                                        );

                                        print("Submitted Location: Latitude: ${selectedLocation.latitude}, Longitude: ${selectedLocation.longitude}");
                                      }
                                    } catch (e) {
                                      print("Error fetching location: $e");
                                    }
                                  }

                              },),
                                 ) ), //search bar

                        if (_placesList != null && _placesList.isNotEmpty)
                          Positioned(
                            top: 70, // Adjust this to match the height of the search bar plus padding
                            left: 10,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9), // Semi-transparent background
                                borderRadius: BorderRadius.circular(10), // Optional rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                shrinkWrap: true, // Prevent ListView from expanding infinitely
                                itemCount: _placesList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(_placesList[index]['description']),
                                    onTap: () async{

                                      print("Selected location: ${_placesList[index]['description']}");
                                      _searchController.text = _placesList[index]['description'];
                                      List<Location> locations= await locationFromAddress(_placesList[index]['description']);
                                      print(locations.last.latitude);
                                      print(locations.last.longitude);
                                      setState(() {
                                        _placesList.clear();
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ), //list of address

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
                            ), // Smaller button size
                          ),
                        ), // full map button
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<LocationState>(
                    builder: (context, locationState, child) {
                      if (locationState.selectedLocation != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Selected Location:",
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,color: Color(0xFFFFFFFF)),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Latitude:",
                              style: TextStyle(fontSize: 20,
                               color: Color(0xFFFFFFFF
                            ),),),
                            Container(
                              color: Colors.black12,
                              child: Center(
                                child: Text(
                                  locationState.selectedLocation!.latitude.toStringAsFixed(6),
                                  style: const TextStyle(fontSize: 20,color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Longitude:",
                              style: TextStyle(fontSize: 20,color: Color(0xFFFFFFFF)),
                            ),
                            Container(
                              color: Colors.black12,
                              child: Center(
                                child: Text(
                                  locationState.selectedLocation!.longitude.toStringAsFixed(6),
                                  style: const TextStyle(fontSize: 20,color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text(
                          "Tap on the map to select a location.",
                          style: TextStyle(fontSize: 26, color: Colors.black12),
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
          ],
        ),

    );
  }
}
