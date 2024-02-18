import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runinmor/types/route_list.dart';

class BestStatsCard extends StatelessWidget {
  final String name;
  final String distance;
  final String pace;
  final String time;

  const BestStatsCard({
    Key? key,
    required this.name,
    required this.distance,
    required this.pace,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background color instead of image
            Container(
              color: const Color(0xFFF2F2F2),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 28,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xFF171717),
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Distance: $distance',
                        style: const TextStyle(
                          color: Color(0xFF171717),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Pace: $pace',
                        style: const TextStyle(
                          color: Color(0xFF171717),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Time: $time',
                        style: const TextStyle(
                          color: Color(0xFF171717),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
