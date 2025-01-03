import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/map_provider/location_provider.dart';
import '../provider/map_provider/circle_outline_map_provider.dart';
import '../utils/calculate_distance.dart';

class HomeScreenAgra extends StatefulWidget {
  const HomeScreenAgra({super.key});

  @override
  State<HomeScreenAgra> createState() => _HomeScreenAgraState();
}

class _HomeScreenAgraState extends State<HomeScreenAgra> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.1767, 78.0081),
    zoom: 10,
  );

  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};
  String nearestWellName = "";
  double? nearestWellDistance;

  @override
  void initState() {
    super.initState();
    _addStationMarkers();
  }

  void _addStationMarkers() {
    for (var station in stations) {
      final latitude = station['latitude'] is int
          ? (station['latitude'] as int).toDouble()
          : station['latitude'] as double;

      final longitude = station['longitude'] is int
          ? (station['longitude'] as int).toDouble()
          : station['longitude'] as double;

      _markers.add(
        Marker(
          markerId: MarkerId(station['id'].toString()),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: station['name'],
            snippet: "ID: ${station['id']}",
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final locationState = Provider.of<LocationState>(context);
    final mapState = Provider.of<MapState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'नीर मंथन',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) => _controller.complete(controller),
            markers: _markers,
            circles: mapState.circles,
            zoomControlsEnabled: false,
            onTap: (LatLng position) {
              locationState.updateSelectedLocation(position);
              mapState.updateCircle(position);

              final nearestWell = findNearestStationLatLng(position);
              final distance = calculateDistance(position, nearestWell.latLng);

              setState(() {
                nearestWellName = nearestWell.name;
                nearestWellDistance = distance;
              });
            },
          ),
          _buildSearchBar(),
          if (nearestWellName.isNotEmpty) _buildNearestWellCard(),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/fullMap'),
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.fullscreen, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.water_drop, size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text('नीर मंथन', style: TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Home', () => Navigator.pop(context)),
          _buildDrawerItem(Icons.map, 'Full Map View',
                  () => Navigator.pushNamed(context, '/fullMap')),
          _buildDrawerItem(Icons.settings, 'Settings',
                  () => Navigator.pushNamed(context, '/theme')),
          const Divider(),
          _buildDrawerItem(Icons.logout, 'Logout', () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 10,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search location...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
          onSubmitted: (value) {
            // Handle location search (left for implementation)
          },
        ),
      ),
    );
  }

  Widget _buildNearestWellCard() {
    return Positioned(
      bottom: 80,
      left: 20,
      right: 20,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nearest Monitoring Station:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Name: $nearestWellName', style: const TextStyle(fontSize: 16)),
              Text('Distance: ${nearestWellDistance?.toStringAsFixed(2)} meters',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/extra',
                    arguments: {"nearestWellName": nearestWellName},
                  );
                },
                child: const Text('Predict'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
