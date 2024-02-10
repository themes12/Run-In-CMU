import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;

List<mapTool.LatLng> convertToMapToolLatLng(List<googleMap.LatLng> latLngList) {
  return latLngList
      .map((e) => mapTool.LatLng(e.latitude, e.longitude))
      .toList();
}
