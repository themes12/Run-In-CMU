/// Written by Thiti Phuttaamart 640510660
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/components/template/white_container.dart';
import 'package:runinmor/provider/route_provider.dart';
import 'package:runinmor/types/route_list.dart';

import '../components/run/route_list_card.dart';

class RouteListPage extends StatelessWidget {
  const RouteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xFF714DA5),
      body: WhiteContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ready to run?',
              style: TextStyle(
                color: Color(0xFF714DA5),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Choose your running route',
                style: TextStyle(
                  color: Color(0xFF969696),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: FutureBuilder(
                    future: routeProvider.loadRouteList(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        final routes = snapshot.data as Iterable<RunRoute>?;
                        if (routes == null) {
                          return Text("No data");
                        } else {
                          final data = routes.toList();
                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final route = data[index];
                              return RouteListCard(
                                route: route,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(
                              height: 25,
                            ),
                            itemCount: data.length,
                          );
                        }
                      } else {
                        return const Center(
                          child: Text("No data"),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
