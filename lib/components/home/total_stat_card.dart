import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TotalStatsCard extends StatelessWidget {
  final String distance;
  final String pace;
  final String time;

  const TotalStatsCard({
    Key? key,
    required this.distance,
    required this.pace,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.4,
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            color: Color(0xFF6B5886),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FluentIcons.run_24_regular,
                    color: Color(0xFFFFFFFF),
                    size: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$distance',
                    style: TextStyle(
                      fontSize: 48,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Kilometres',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFEFEFEF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 0.7,
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            color: Color(0xFFB49AD9),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FluentIcons.notebook_20_regular,
                        color: Color(0xFFFFFFFF),
                        size: 40,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$pace',
                        style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Avg. Pace',
                        style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFEFEFEF),),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),

        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 0.7,

          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            color: Color(0xFFC6B4DF),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FluentIcons.timer_24_regular,
                          color: Color(0xFFFFFFFF),
                          size: 40,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$time',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFEFEFEF),),
                        ),
                      ],
                    )
                  ],
                ),
            ),
          ),
        ),

      ],
    );
  }
}
