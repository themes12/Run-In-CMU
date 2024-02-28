import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:location/location.dart';
import 'package:runinmor/components/run/circular_button.dart';

import 'package:runinmor/mock_data/route_list.dart';
import 'package:runinmor/pages/count_down_page.dart';
import 'package:runinmor/types/route_list.dart';

import '../components/template/white_container.dart';
import '../utils/constant.dart';
import '../utils/map/svg_to_bitmap.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.selectedRoute});
  final String? selectedRoute;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location locationController = Location();

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return WhiteContainer(
              padding: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FluentIcons.location_24_filled,
                          color: Color(0xFF714DA5),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Expanded(
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
                      child: Stack(
                        children: [
                          googleMap.GoogleMap(
                            initialCameraPosition:
                                const googleMap.CameraPosition(
                              target: pMor,
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
                            child: CircularButton(
                              color: Color(0xFF262626),
                              onPressed: () {
                                context.pushNamed(
                                  'CountDown',
                                  queryParameters: {
                                    'duration': '3',
                                    "selectedRoute": widget.selectedRoute,
                                  },
                                );
                              },
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Text('Error');
          }
        },
      ),
    );
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
