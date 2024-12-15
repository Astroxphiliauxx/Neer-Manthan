import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'nearestWell.dart';


final List<Map<String, dynamic>> stations = [
{"id": 1, "name":"W15445","latitude":26.85833333,"longitude":77.6},
{"id": 2, "name":"W14607","latitude":27.02361111,"longitude":77.85},
{"id": 3, "name":"W22132","latitude":27.09166667,"longitude":77.67777778},
{"id": 4, "name":"W15443","latitude":27.17083333,"longitude":77.96666667},
{"id": 5, "name":"W14604","latitude":26.81666667,"longitude":77.45},
{"id": 6, "name":"W29717","latitude":27.09166667,"longitude":77.66833333},
{"id": 7, "name":"W15452","latitude":27,"longitude":77.96833333},
{"id": 8, "name":"W15439","latitude":27.23333333,"longitude":77.83333333},
{"id": 9, "name":"W15447","latitude":26.83333333,"longitude":78.70333333},
{"id": 10, "name":"W14595","latitude":26.89305556,"longitude":78.49722222},
{"id": 11, "name":"W15441","latitude":27.17833333,"longitude":77.81833333},
{"id": 12, "name":"W14608","latitude":26.961111117,"longitude":77.75222222},
{"id": 13, "name":"W18176","latitude":26.93333333,"longitude":77.76666667},
{"id": 14, "name":"W21801","latitude":27.07944444,"longitude":77.65833333},
{"id": 15, "name":"W14601","latitude":27.09166667,"longitude":77.66833333},
{"id": 16, "name":"W15442","latitude":27.11666667,"longitude":77.925},
{"id": 17, "name": "W15438","latitude":27.21944444,"longitude":77.84722222},
{"id": 18, "name":"W15449","latitude":26.94166667,"longitude":77.84166667},
{"id": 19, "name":"W15451","latitude":26.94166667,"longitude":77.92777778},
{"id": 20, "name":"W15444","latitude":27.3,"longitude":78.19444444},
{"id": 21, "name":"W14596","latitude":26.90166667,"longitude":78.475},
{"id": 22, "name":"W14602","latitude":26.8375,"longitude":77.49027778},
{"id": 23, "name":"W15440","latitude":27.13333333,"longitude":77.7625},
{"id": 24, "name":"W14609","latitude":27.04166667,"longitude":78.25},
{"id": 25, "name":"W14594","latitude":27.07388889,"longitude":77.98333333},
{"id": 26, "name":"W14593","latitude":27.14555556,"longitude":77.77},
{"id": 27, "name":"W14597","latitude":27.32083333,"longitude":78.1875},
{"id": 28, "name":"W14606","latitude":27.31166667,"longitude":78.02666667},
{"id": 29, "name":"W14610","latitude":27.10833333,"longitude":78.15833333},
{"id": 30, "name":"W14598","latitude":27.23333333,"longitude":78.2},
{"id": 31, "name":"W14600","latitude":27.03166667,"longitude":78.125},
{"id": 32, "name":"W15450","latitude":26.88472222,"longitude":78.37916667},
{"id": 33, "name":"W15446","latitude":26.9,"longitude":77.675},
{"id": 34, "name":"W15448","latitude":26.83,"longitude":78.7},
{"id": 35, "name":"W14605","latitude":26.86527778,"longitude":78.58611111},


];

double calculateDistance(LatLng selected, LatLng station) {
  return Geolocator.distanceBetween(
    selected.latitude,
    selected.longitude,
    station.latitude,
    station.longitude,
  );
}

WellLocation findNearestStationLatLng(LatLng selected) {
  double minDistance = double.infinity;
  LatLng? nearestLatLng;
  String nearestWellName = '';

  for (var station in stations) {
    final double latitude = station["latitude"].toDouble();
    final double longitude = station["longitude"].toDouble();

    final distance = calculateDistance(
      selected,
      LatLng(latitude, longitude),
    );

    if (distance < minDistance) {
      minDistance = distance;
      nearestLatLng = LatLng(latitude, longitude);
      nearestWellName = station["name"];
    }
  }

  return WellLocation(latLng: nearestLatLng!, name: nearestWellName);


}

