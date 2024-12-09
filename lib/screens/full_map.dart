import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../provider/map_provider/circle_outline_map_provider.dart';
import 'package:http/http.dart' as http;


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
            ), //search bar

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
                        title: Text(_placesList[index]['description']), onTap: () async {
                        print("Selected location: ${_placesList[index]['description']}");
                        _searchController.text = _placesList[index]['description'];
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
