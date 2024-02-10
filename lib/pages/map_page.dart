import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:location/location.dart';

import 'package:runinmor/mock_data/route_list.dart';
import 'package:runinmor/types/route_list.dart';

import '../components/template/white_container.dart';
import '../utils/map/svg_to_bitmap.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.selectedRoute});
  final String? selectedRoute;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location locationController = Location();
  static const googleMap.LatLng _pMor =
      googleMap.LatLng(18.801511835577063, 98.95176971909669);
  // late final googleMap.LatLng _pStart;
  // late final googleMap.LatLng _pEnd;
  // mapTool.LatLng? prevLocation;
  // PolylinePoints polylinePoints = PolylinePoints();
  // googleMap.LatLng? currentLocation;
  // googleMap.BitmapDescriptor? currentMarker;
  // bool isOnPath = false;
  // bool prevIsOnPath = false;
  // num _totalDistance = 0;

  googleMap.BitmapDescriptor? startMarker;
  googleMap.BitmapDescriptor? endMarker;

  Map<googleMap.PolylineId, googleMap.Polyline> polylines = {};

  late final RunRoute route;

  @override
  void initState() {
    super.initState();
    route = routeList.data
        .firstWhere((element) => element.name == widget.selectedRoute);
    generatePolylineFromPoints(route.polylinePoints);
    // getLocationUpdates()
    //     .then((_) => {generatePolylineFromPoints(route.polylinePoints)});
    // _bitmapDescriptorFromSvgAsset('asset/images/start_marker.svg')
    //     .then((value) => {startMarker = value});
    // _bitmapDescriptorFromSvgAsset('asset/images/end_marker.svg')
    //     .then((value) => {endMarker = value});
    // _bitmapDescriptorFromSvgAsset('asset/images/current_marker.svg')
    //     .then((value) => {currentMarker = value});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF714DA5),
      body: FutureBuilder(
        future: Future.wait([
          bitmapDescriptorFromSvgAsset('asset/images/start_marker.svg')
              .then((value) => {startMarker = value}),
          bitmapDescriptorFromSvgAsset('asset/images/end_marker.svg')
              .then((value) => {endMarker = value}),
        ]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return WhiteContainer(
              padding: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FluentIcons.location_24_filled,
                          color: Color(0xFF714DA5),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Text(
                            route.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF714DA5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Stack(children: [
                        googleMap.GoogleMap(
                          initialCameraPosition: const googleMap.CameraPosition(
                            target: _pMor,
                            zoom: 15,
                          ),
                          markers: {
                            googleMap.Marker(
                              markerId: const googleMap.MarkerId(
                                "_sourceLocation",
                              ),
                              icon: startMarker!,
                              position: route.startPosition,
                            ),
                            googleMap.Marker(
                              markerId: const googleMap.MarkerId(
                                "_destinationLocation",
                              ),
                              icon: endMarker!,
                              position: route.endPosition,
                            )
                          },
                          polylines:
                              Set<googleMap.Polyline>.of(polylines.values),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(109, 109),
                                backgroundColor: Color(0xFF262626),
                                shape: CircleBorder(),
                              ),
                              onPressed: () {},
                              child: Text(
                                'START',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          }
          return Text('Error');
        },
        // child: currentLocation == null
        //     ? const Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : Column(
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.symmetric(
        //               vertical: 10,
        //             ),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Icon(
        //                   FluentIcons.location_24_filled,
        //                   color: Color(0xFF714DA5),
        //                 ),
        //                 SizedBox(
        //                   width: 6,
        //                 ),
        //                 Text(
        //                   route.name,
        //                   style: TextStyle(
        //                     fontSize: 24,
        //                     fontWeight: FontWeight.w600,
        //                     color: Color(0xFF714DA5),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           // Text(isOnPath
        //           //     ? 'Total Distance: ${_totalDistance.toString()}'
        //           //     : "You're not on the route right now, Get back to it!"),
        //           Expanded(
        //             child: ClipRRect(
        //               borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(10),
        //                 topRight: Radius.circular(10),
        //               ),
        //               child: Stack(children: [
        //                 googleMap.GoogleMap(
        //                   initialCameraPosition: const googleMap.CameraPosition(
        //                     target: _pMor,
        //                     zoom: 15,
        //                   ),
        //                   markers: {
        //                     googleMap.Marker(
        //                       markerId:
        //                           const googleMap.MarkerId("_currentLocation"),
        //                       icon: currentMarker!,
        //                       position: currentLocation!,
        //                     ),
        //                     googleMap.Marker(
        //                       markerId:
        //                           const googleMap.MarkerId("_sourceLocation"),
        //                       icon: startMarker!,
        //                       position: _pStart,
        //                     ),
        //                     googleMap.Marker(
        //                       markerId: const googleMap.MarkerId(
        //                           "_destinationLocation"),
        //                       icon: endMarker!,
        //                       position: _pEnd,
        //                     )
        //                   },
        //                   polylines:
        //                       Set<googleMap.Polyline>.of(polylines.values),
        //                 ),
        //                 Align(
        //                   alignment: AlignmentDirectional.bottomCenter,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(bottom: 32),
        //                     child: ElevatedButton(
        //                       style: ElevatedButton.styleFrom(
        //                         minimumSize: Size(109, 109),
        //                         backgroundColor: Color(0xFF262626),
        //                         shape: CircleBorder(),
        //                       ),
        //                       onPressed: () {},
        //                       child: Text(
        //                         'START',
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.w600,
        //                           fontSize: 24,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ]),
        //             ),
        //           ),
        //         ],
        //       ),
      ),
    );
  }

  // Future<void> getLocationUpdates() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //
  //   _serviceEnabled = await locationController.serviceEnabled();
  //   if (_serviceEnabled) {
  //     _serviceEnabled = await locationController.requestService();
  //   } else {
  //     return;
  //   }
  //
  //   _permissionGranted = await locationController.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await locationController.requestPermission();
  //
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //
  //   locationController.onLocationChanged.listen((LocationData currentLocation) {
  //     if (currentLocation.latitude != null &&
  //         currentLocation.longitude != null) {
  //       setState(() {
  //         this.currentLocation = googleMap.LatLng(
  //             currentLocation.latitude!, currentLocation.longitude!);
  //         // print(this.currentLocation);
  //         isOnPath = mapTool.PolygonUtil.isLocationOnPath(
  //           mapTool.LatLng(
  //               currentLocation.latitude!, currentLocation.longitude!),
  //           convertToMapToolLatLng(
  //             polylinePointsList!,
  //           ),
  //           false,
  //           tolerance: 10,
  //         );
  //
  //         if (isOnPath && prevIsOnPath) {
  //           num distanceBetween = mapTool.SphericalUtil.computeDistanceBetween(
  //             mapTool.LatLng(
  //                 currentLocation.latitude!, currentLocation.longitude!),
  //             prevLocation!,
  //           );
  //           _totalDistance += distanceBetween;
  //         }
  //         prevIsOnPath = isOnPath;
  //         prevLocation = mapTool.LatLng(
  //           currentLocation.latitude!,
  //           currentLocation.longitude!,
  //         );
  //       });
  //     }
  //   });
  // }

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
