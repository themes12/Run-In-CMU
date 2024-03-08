import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'package:runinmor/pages/count_down_page.dart';
import 'package:runinmor/types/RunSummary.dart';
import 'package:runinmor/types/route_list.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../components/run/circular_button.dart';
import '../components/template/white_container.dart';
import '../provider/route_provider.dart';
import '../utils/constant.dart';
import '../utils/map/convert_google_to_map_tool_lat_long.dart';
import '../utils/map/svg_to_bitmap.dart';

import 'package:maps_toolkit/maps_toolkit.dart' as mapTool;

class RunPage extends StatefulWidget {
  const RunPage({super.key, required this.selectedRoute});

  final String? selectedRoute;

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  Location locationController = Location();

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
  late final RouteProvider routeProvider;

  bool isPause = false;

  num prevDistance = 0;
  double pace = 0;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    routeProvider = Provider.of<RouteProvider>(context, listen: false);
    route = routeProvider.routeList
        .firstWhere((element) => element.uid == widget.selectedRoute);
    // route = routeList.data
    //     .firstWhere((element) => element.name == widget.selectedRoute);
    getLocationUpdates()
        .then((_) => {generatePolylineFromPoints(route.polylinePoints)});
    bitmapDescriptorFromSvgAsset('asset/images/start_marker.svg')
        .then((value) => {startMarker = value});
    bitmapDescriptorFromSvgAsset('asset/images/end_marker.svg')
        .then((value) => {endMarker = value});
    bitmapDescriptorFromSvgAsset('asset/images/current_marker.svg')
        .then((value) => {currentMarker = value});
    _stopWatchTimer.onStartTimer();
    calculatePace();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                // Text(isOnPath
                //     ? 'Total Distance: ${_totalDistance.toString()}'
                //     : "You're not on the route right now, Get back to it!"),
                googleMap.GoogleMap(
                  initialCameraPosition: googleMap.CameraPosition(
                    target: pMor,
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(isPause ? 0.5 : 0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 35,
                  ),
                  child: Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF262626),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    (_totalDistance / 1000).toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Kilometers',
                                    style: TextStyle(
                                      color: Color(0xFFB49AD9),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    pace == 0 ? "N/A" : pace.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Avg. Pace',
                                    style: TextStyle(
                                      color: Color(0xFFB49AD9),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ],
                              ),
                              StreamBuilder<int>(
                                  stream: _stopWatchTimer.rawTime,
                                  initialData: 3,
                                  builder: (context, snap) {
                                    final value = snap.data;
                                    String formattedTime =
                                        DateFormat('mm:ss').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        value ?? 0,
                                      ),
                                    );
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          formattedTime,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Time',
                                          style: TextStyle(
                                            color: Color(0xFFB49AD9),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircularButton(
                        color: Color(0xFF262626),
                        onPressed: () {
                          if (isPause) {
                            onStop(true);
                          } else {
                            setState(() {
                              isPause = !isPause;
                              _stopWatchTimer.onStopTimer();
                            });
                          }
                        },
                        child: Icon(
                          isPause
                              ? FluentIcons.stop_24_filled
                              : FluentIcons.pause_24_filled,
                          color: Colors.white,
                        ),
                      ),
                      isPause
                          ? SizedBox(
                              width: 45,
                            )
                          : Container(),
                      isPause
                          ? CircularButton(
                              color: Color(0xFF714DA5),
                              onPressed: () {
                                setState(() {
                                  isPause = !isPause;
                                });
                                _stopWatchTimer.onStartTimer();
                              },
                              child: Icon(
                                FluentIcons.play_24_filled,
                                color: Colors.white,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void onReachEndPosition(LocationData currentLocation) {
    final distanceToEnd = mapTool.SphericalUtil.computeDistanceBetween(
      mapTool.LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      ),
      mapTool.LatLng(
        route.endPosition.latitude,
        route.endPosition.longitude,
      ),
    );
    // if (distanceToEnd <= 10) {
    //   onStop();
    // }
    onStop(false);
  }

  Future<void> onStop(bool forceStop) async {
    // final data = RunSummary(
    //   pace: pace,
    //   distance: _totalDistance,
    //   time: _stopWatchTimer.rawTime.value,
    // );
    final data = RunSummary(
      pace: 10.00,
      distance: 1401,
      time: 650000,
      route: widget.selectedRoute!,
      uid: FirebaseAuth.instance.currentUser!.uid,
      forceStop: false,
      timestamp: Timestamp.now(),
      // forceStop: forceStop,
    );

    await routeProvider.onFinished(context, data);
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
          // onReachEndPosition(currentLocation); // calculate here
        });
      }
    });
  }

  void calculatePace() {
    _stopWatchTimer.secondTime.listen((value) {
      if (_totalDistance - prevDistance >= 100) {
        setState(() {
          pace = (value / 60) / (_totalDistance / 1000);
          prevDistance = _totalDistance;
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
