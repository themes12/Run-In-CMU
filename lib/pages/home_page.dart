import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../components/home/home_stat_card.dart';
import '../components/template/white_container.dart';
import '../provider/navigation_bar_provider.dart';
import 'home_stat_card.dart'; // Import the BestStatsCard widget


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation =
        Provider.of<NavigationBarProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF714DA5),
      body: WhiteContainer(
        child: const Column(
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
                    '9 February 2024',
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
                  const BestStatsCard(
                    name: 'Aung Keaw',
                    distance: '2.64 Km',
                    pace: '11\'59"',
                    time: '31:04',
                  ),

                ],
              ),
            ),
          ],
        ),
        // child: Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     const Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           'Ready to run?',
        //           style: TextStyle(
        //             color: Color(0xFF714DA5),
        //             fontSize: 24,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //         Padding(
        //           padding: EdgeInsets.only(top: 6),
        //           child: Row(
        //             children: [
        //               Icon(
        //                 FluentIcons.calendar_28_regular,
        //                 color: Color(0xFF7A7A7A),
        //               ),
        //               SizedBox(
        //                 width: 10,
        //               ),
        //               Text(
        //                 '9 February 2024',
        //                 style: TextStyle(
        //                   color: Color(0xFF7A7A7A),
        //                   fontSize: 18,
        //                   fontWeight: FontWeight.w400,
        //                 ),
        //               )
        //             ],
        //           ),
        //         )
        //       ],
        //     ),
        //     Material(
        //       color: Colors.transparent,
        //       child: Ink(
        //         decoration: const ShapeDecoration(
        //           color: Color(0xFF262626),
        //           shape: CircleBorder(),
        //         ),
        //         child: IconButton(
        //           icon: const Icon(
        //             FluentIcons.run_24_regular,
        //           ),
        //           color: Colors.white,
        //           onPressed: () {
        //             navigation.changePage(context, 1);
        //           },
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
