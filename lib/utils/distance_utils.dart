import 'dart:math' show cos, sqrt, asin;

import 'package:latlong/latlong.dart';

class DistanceUtils {
  /// Calculate direct distance between two points in kilometers
  static double calculateDistance(LatLng latLng1, LatLng latLng2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((latLng2.latitude - latLng1.latitude) * p) / 2 +
        c(latLng1.latitude * p) *
            c(latLng2.latitude * p) *
            (1 - c((latLng2.longitude - latLng1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }
}
