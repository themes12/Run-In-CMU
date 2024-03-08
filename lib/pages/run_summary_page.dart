import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMap;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/components/run/circular_button.dart';

import 'package:runinmor/pages/count_down_page.dart';
import 'package:runinmor/types/RunSummary.dart';
import 'package:runinmor/types/route_list.dart';

import '../components/template/white_container.dart';
import '../provider/route_provider.dart';
import '../utils/constant.dart';
import '../utils/map/svg_to_bitmap.dart';

class RunSummaryPage extends StatefulWidget {
  const RunSummaryPage({
    super.key,
    required this.selectedRoute,
    required this.runSummary,
  });
  final String? selectedRoute;
  final RunSummary runSummary;

  @override
  State<RunSummaryPage> createState() => _RunSummaryPageState();
}

class _RunSummaryPageState extends State<RunSummaryPage> {
  Location locationController = Location();

  googleMap.BitmapDescriptor? startMarker;
  googleMap.BitmapDescriptor? endMarker;

  Map<googleMap.PolylineId, googleMap.Polyline> polylines = {};

  late final RunRoute route;
  late final RouteProvider routeProvider;

  @override
  void initState() {
    super.initState();
    routeProvider = Provider.of<RouteProvider>(context, listen: false);
    route = routeProvider.routeList
        .firstWhere((element) => element.uid == widget.selectedRoute);
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
                            myLocationButtonEnabled: false,
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
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: FloatingActionButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    backgroundColor: const Color(0xFF714DA5),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await routeProvider.calculateFilter(
                                        context,
                                        widget.runSummary,
                                      ); // calculate filter here
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF262626),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 32,
                                      ),
                                      child: Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  (widget.runSummary.distance /
                                                          1000)
                                                      .toStringAsFixed(2),
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Kilometers',
                                                  style: TextStyle(
                                                    color: Color(0xFFB49AD9),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  widget.runSummary.pace
                                                      .toStringAsFixed(2),
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Avg. Pace',
                                                  style: TextStyle(
                                                    color: Color(0xFFB49AD9),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  DateFormat('mm:ss').format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                      widget.runSummary.time,
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Time',
                                                  style: TextStyle(
                                                    color: Color(0xFFB49AD9),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
