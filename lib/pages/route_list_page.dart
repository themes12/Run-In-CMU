import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:runinmor/components/template/white_container.dart';
import 'package:runinmor/types/route_list.dart';

import '../components/run/route_list_card.dart';
import '../mock_data/route_list.dart';

class RouteListPage extends StatelessWidget {
  const RouteListPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Padding(
            //   padding: const EdgeInsets.only(top: 12),
            //   child: RouteListCard(
            //     route: routeList.data[0],
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final RunRoute route = routeList.data[index];
                      return RouteListCard(
                        route: route,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 25,
                    ),
                    itemCount: routeList.data.length,
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
