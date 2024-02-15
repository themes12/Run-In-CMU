import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:location/location.dart';

import 'package:runinmor/mock_data/route_list.dart';
import 'package:runinmor/pages/count_down_page.dart';
import 'package:runinmor/types/route_list.dart';

import '../components/template/white_container.dart';
import '../utils/map/convert_google_to_map_tool_lat_long.dart';
import '../utils/map/svg_to_bitmap.dart';

import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;

class RunPage extends StatefulWidget {
  const RunPage({super.key, required this.selectedRoute});

  static const googleMap.LatLng _pMor =
      googleMap.LatLng(18.801511835577063, 98.95176971909669);
  final String? selectedRoute;

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  Location locationController = Location();
  static const googleMap.LatLng _pMor =
      googleMap.LatLng(18.801511835577063, 98.95176971909669);

  mapTool.LatLng? prevLocation;

  PolylinePoints polylinePoints = PolylinePoints();
  googleMap.LatLng? currentLocation;

  googleMap.BitmapDescriptor? startMarker;
  googleMap.BitmapDescriptor? endMarker;
  googleMap.BitmapDescriptor? currentMarker;
  List<googleMap.LatLng>? polylinePointsList;
  bool isOnPath = false;
  bool prevIsOnPath = false;

  Map<googleMap.PolylineId, googleMap.Polyline> polylines = {};
  num _totalDistance = 0;
  late final RunRoute route;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    route = routeList.data
        .firstWhere((element) => element.name == widget.selectedRoute);

    getLocationUpdates()
        .then((_) => {generatePolylineFromPoints(route.polylinePoints)});
    bitmapDescriptorFromSvgAsset('asset/images/start_marker.svg')
        .then((value) => {startMarker = value});
    bitmapDescriptorFromSvgAsset('asset/images/end_marker.svg')
        .then((value) => {endMarker = value});
    bitmapDescriptorFromSvgAsset('asset/images/current_marker.svg')
        .then((value) => {currentMarker = value});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Text(isOnPath
                    ? 'Total Distance: ${_totalDistance.toString()}'
                    : "You're not on the route right now, Get back to it!"),
                Expanded(
                  child: googleMap.GoogleMap(
                    initialCameraPosition: googleMap.CameraPosition(
                      target: _pMor,
                      zoom: 15,
                    ),
                    markers: {
                      googleMap.Marker(
                        markerId: googleMap.MarkerId("_currentLocation"),
                        icon: currentMarker!,
                        position: currentLocation!,
                      ),
                      googleMap.Marker(
                        markerId: googleMap.MarkerId("_sourceLocation"),
                        icon: startMarker!,
                        position: route.startPosition,
                      ),
                      googleMap.Marker(
                        markerId: googleMap.MarkerId("_destinationLocation"),
                        icon: endMarker!,
                        position: route.endPosition,
                      )
                    },
                    polylines: Set<googleMap.Polyline>.of(polylines.values),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationController.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          this.currentLocation = googleMap.LatLng(
              currentLocation.latitude!, currentLocation.longitude!);
          // print(this.currentLocation);
          isOnPath = mapTool.PolygonUtil.isLocationOnPath(
            mapTool.LatLng(
                currentLocation.latitude!, currentLocation.longitude!),
            convertToMapToolLatLng(
              route.polylinePoints,
            ),
            false,
            tolerance: 10,
          );

          if (isOnPath && prevIsOnPath) {
            num distanceBetween = mapTool.SphericalUtil.computeDistanceBetween(
              mapTool.LatLng(
                  currentLocation.latitude!, currentLocation.longitude!),
              prevLocation!,
            );
            _totalDistance += distanceBetween;
          }
          prevIsOnPath = isOnPath;
          prevLocation = mapTool.LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }

  void generatePolylineFromPoints(List<googleMap.LatLng> polylineCoordinates) {
    googleMap.PolylineId id = googleMap.PolylineId("poly");
    googleMap.Polyline polyline = googleMap.Polyline(
      polylineId: id,
      color: Colors.lightBlue,
      points: polylineCoordinates,
      width: 3,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }
}
