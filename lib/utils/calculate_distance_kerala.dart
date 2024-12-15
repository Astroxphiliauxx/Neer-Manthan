import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final List<Map<String, dynamic>> stations1 = [
  {"id":1 ,"name": "W23134", "latitude":9.28222222, "longitude":76.60972222},
  {"id":2 ,"name": "W23142", "latitude":9.3, "longitude":76.54416667},
  {"id":3 ,"name": "W23143", "latitude":9.30055556, "longitude":76.63444444},
  {"id":4 ,"name": "W23147", "latitude":9.31666667, "longitude":76.6275},
  {"id":5 ,"name": "W23148", "latitude":9.31916667, "longitude":76.545},
  {"id":6 ,"name": "W23151", "latitude":9.325, "longitude":76.58222222},
  {"id":7 ,"name": "W23157", "latitude":9.34722222, "longitude":76.60138889},
  {"id":8 ,"name": "W23125", "latitude":9.25, "longitude":76.4275},
  {"id":9 ,"name": "W23128", "latitude":9.25166667, "longitude":76.45194444},
  {"id":10,"name": "W23133", "latitude":9.27222222, "longitude":76.48027778},

];

double calculateDistance1(LatLng selected, LatLng station) {
  return Geolocator.distanceBetween(
    selected.latitude,
    selected.longitude,
    station.latitude,
    station.longitude,
  );
}

LatLng findNearestStationLatLng1(LatLng selected)  {
  double minDistance = double.infinity;
  LatLng? nearestLatLng;

  for (var station in stations1) {
    final double latitude = station["latitude"].toDouble();
    final double longitude = station["longitude"].toDouble();

    final distance = calculateDistance1(
      selected,
      LatLng(latitude, longitude),
    );

    if (distance < minDistance) {
      minDistance = distance;
      nearestLatLng = LatLng(latitude, longitude);
    }
  }
  return nearestLatLng!;
}