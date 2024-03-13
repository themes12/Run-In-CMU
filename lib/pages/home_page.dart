import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/provider/route_provider.dart';
import 'package:runinmor/provider/user_provider.dart';

import '../components/home/home_stat_card.dart';
import '../components/home/total_stat_card.dart';
import '../components/template/white_container.dart';
import '../provider/navigation_bar_provider.dart';
import '../types/RunSummary.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<NavigationBarProvider>(context, listen: false);
    final RouteProvider routeProvider = Provider.of<RouteProvider>(context, listen: false);
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF714DA5),
      body: WhiteContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ready to run?',
                style: TextStyle(
                  color: Color(0xFF714DA5),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Icon(
                      FluentIcons.calendar_28_regular,
                      color: Color(0xFF7A7A7A),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      DateFormat("d MMMM y").format(DateTime.now()),
                      style: TextStyle(
                        color: Color(0xFF7A7A7A),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 36),
                child: Column(
                  children: [
                    Text(
                      'Best stats',
                      style: TextStyle(
                        color: Color(0xFF714DA5),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Add the BestStatsCard widget here
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    // Add the BestStatsCard widget here
                      FutureBuilder(
                        future: routeProvider.loadOverallBestStats(),
                        builder: (BuildContext context, AsyncSnapshot<RunSummaryAdditional?> snapshot) {
                          if(snapshot.connectionState == ConnectionState.done) {
                            final data= snapshot.data;
                            if(data != null) {
                              return BestStatsCard(
                                name: data.name,
                                distance: (data.distance / 1000).toStringAsFixed(2),
                                pace: data.pace.toStringAsFixed(2),
                                time: DateFormat('mm:ss').format(DateTime.fromMillisecondsSinceEpoch(data.time)),
                                imageUrl: data.img_url,
                                timestamp: data.timestamp,
                              );
                            }else {
                              return Text("no data");
                            }
                          }
                          return CircularProgressIndicator();
                        },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 36),
                child: Column(
                  children: [
                    Text(
                      'Total stats',
                      style: TextStyle(
                        color: Color(0xFF714DA5),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Add the BestStatsCard widget here
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    // Add the BestStatsCard widget here
                    FutureBuilder(

                      future: userProvider.loadUserInformation(),
                      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                        if(snapshot.connectionState == ConnectionState.done){
                          return Consumer<UserProvider>(
                            builder: (BuildContext context, UserProvider value, Widget? child) {
                              return TotalStatsCard(
                                distance: (userProvider.userInformation?["total_distance"] ?? 0).toString(),
                                pace: (((userProvider.userInformation?["total_time"] ?? 1) as int)/((userProvider.userInformation?["total_distance"] ?? 0) as int)).toStringAsFixed(2),
                                time: (userProvider.userInformation?["total_time"] ?? 0).toString(),
                              );
                            },
                          );
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
