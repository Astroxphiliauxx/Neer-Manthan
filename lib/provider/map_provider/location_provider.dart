import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationState with ChangeNotifier {
  LatLng? _selectedLocation;

  LatLng? get selectedLocation => _selectedLocation;

  void updateSelectedLocation(LatLng newLocation) {
    _selectedLocation = newLocation;
    notifyListeners();
  }
}
