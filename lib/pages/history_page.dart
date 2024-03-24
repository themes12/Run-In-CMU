/// Written by Thiti Phuttaamart 640510660

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/types/RunSummary.dart';

import '../components/home/home_stat_card.dart';
import '../components/template/white_container.dart';
import '../provider/route_provider.dart';

class HistoryAcivity extends StatelessWidget {
  const HistoryAcivity({super.key});

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
              'History',
              style: TextStyle(
                color: Color(0xFF714DA5),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Your previous runs',
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
                    future: routeProvider.loadHistory(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        final routes =
                            snapshot.data as Iterable<RunSummaryAdditional>?;
                        // print(routes);
                        if (routes == null) {
                          return Text("No data");
                        } else {
                          final data = routes.toList();
                          print(data);
                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final route = data[index];
                              return BestStatsCard(
                                name: route.name,
                                distance:
                                    (route.distance / 1000).toStringAsFixed(2),
                                pace: route.pace.toString(),
                                time: DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(route.time)),
                                imageUrl: route.img_url,
                                timestamp: route.timestamp,
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
