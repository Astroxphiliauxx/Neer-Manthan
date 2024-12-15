import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState with ChangeNotifier {
  Set<Circle> _circles = {};

  Set<Circle> get circles => _circles;

  void updateCircle(LatLng position) {
    _circles = {
      Circle(
        circleId: const CircleId('highlighted_area'),
        center: position,
        radius: 2000,
        strokeColor: Colors.red,
        strokeWidth: 3,
        fillColor: Colors.red.withOpacity(0.2),
      ),
    };
    notifyListeners();
  }
}