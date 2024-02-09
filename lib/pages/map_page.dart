import 'dart:math';
import 'dart:ui'
    as ui; // imported as ui to prevent conflict between ui.Image and the Image widget

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location locationController = Location();
  static const googleMap.LatLng _pMor =
      googleMap.LatLng(18.801511835577063, 98.95176971909669);
  static const googleMap.LatLng _pStart =
      googleMap.LatLng(18.805316075802878, 98.95043909327538);
  static const googleMap.LatLng _pEnd = googleMap.LatLng(18.8039, 98.9523);

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    polylinePointsList = getPolyline();
    getLocationUpdates()
        .then((_) => {generatePolylineFromPoints(polylinePointsList!)});
    _bitmapDescriptorFromSvgAsset('asset/images/start_marker.svg')
        .then((value) => {startMarker = value});
    _bitmapDescriptorFromSvgAsset('asset/images/end_marker.svg')
        .then((value) => {endMarker = value});
    _bitmapDescriptorFromSvgAsset('asset/images/current_marker.svg')
        .then((value) => {currentMarker = value});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      initialCameraPosition: const googleMap.CameraPosition(
                        target: _pMor,
                        zoom: 15,
                      ),
                      markers: {
                        googleMap.Marker(
                          markerId:
                              const googleMap.MarkerId("_currentLocation"),
                          icon: currentMarker!,
                          position: currentLocation!,
                        ),
                        googleMap.Marker(
                          markerId: const googleMap.MarkerId("_sourceLocation"),
                          icon: startMarker!,
                          position: _pStart,
                        ),
                        googleMap.Marker(
                          markerId:
                              const googleMap.MarkerId("_destinationLocation"),
                          icon: endMarker!,
                          position: _pEnd,
                        )
                      },
                      polylines: Set<googleMap.Polyline>.of(polylines.values),
                    ),
                  ),
                ],
              ),
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
              polylinePointsList!,
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

  List<mapTool.LatLng> convertToMapToolLatLng(
      List<googleMap.LatLng> latLngList) {
    return latLngList
        .map((e) => mapTool.LatLng(e.latitude, e.longitude))
        .toList();
  }

  List<googleMap.LatLng> getPolyline() {
    List<googleMap.LatLng> result = polylinePoints
        .decodePolyline(
            "_|wqBmf}zQIi@sDqDWLwDIWDWHoC~DaAl@IpCIT?XRJQZ[ZQx@G`@Kr@Nt@hAhBd@DbAEnCQjAGhA?^Dj@Fh@Cb@K`AWj@@vCm@FG^?Gu@@q@Pm@Zi@^QXG?s@b@QV]^y@Fq@r@eDb@{@`@}@K_@yGuC")
        .map((value) => googleMap.LatLng(value.latitude, value.longitude))
        .toList();
    return result;
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

  Future<googleMap.BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
    String assetName, [
    Size size = const Size(15, 15),
  ]) async {
    final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);

    double devicePixelRatio =
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    int width = (size.width * devicePixelRatio).toInt();
    int height = (size.height * devicePixelRatio).toInt();

    final scaleFactor = min(
      width / pictureInfo.size.width,
      height / pictureInfo.size.height,
    );

    final recorder = ui.PictureRecorder();

    ui.Canvas(recorder)
      ..scale(scaleFactor)
      ..drawPicture(pictureInfo.picture);

    final rasterPicture = recorder.endRecording();

    final image = rasterPicture.toImageSync(width, height);
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;

    return googleMap.BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }
}
