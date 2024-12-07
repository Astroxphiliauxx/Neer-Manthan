import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocationState with ChangeNotifier {
  LatLng? _selectedLocation;

  LatLng? get selectedLocation => _selectedLocation;


  Future<void> updateSelectedLocation(LatLng location) async {
    _selectedLocation = location;
    notifyListeners();
  }


}
