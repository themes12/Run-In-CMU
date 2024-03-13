import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class BestStatsCard extends StatelessWidget {
  final String name;
  final String distance;
  final String pace;
  final String time;
  final String imageUrl;
  final Timestamp timestamp;

  const BestStatsCard({
    Key? key,
    required this.name,
    required this.distance,
    required this.pace,
    required this.time,
    required this.imageUrl,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 4.0), // Adjust offsets as needed
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Color(0xFFF4F4F4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'asset/images/route_list_card_placeholder.png',
                        width: 180,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5,),
                      child: Column(
                        children: [
                          Text(
                            DateFormat.yMd().format(timestamp.toDate()),
                            style: const TextStyle(
                              color: Color(0xFF262626),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Color(0xFF7A7A7A),
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ]
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding as needed
                    child: Column(
                      children: [
                        Text(
                          '$distance',
                          style: const TextStyle(
                            color: Color(0xFF714DA5),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Km',
                          style: const TextStyle(
                            color: Color(0xFF7A7A7A),
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0), // Adjust padding as needed
                    child: Column(
                      children: [
                        Text(
                          '$pace',
                          style: const TextStyle(
                            color: Color(0xFF714DA5),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Avg. Pace',
                          style: const TextStyle(
                            color: Color(0xFF7A7A7A),
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding as needed
                    child: Column(
                      children: [
                        Text(
                          '$time',
                          style: const TextStyle(
                            color: Color(0xFF714DA5),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Time (Minutes)',
                          style: const TextStyle(
                            color: Color(0xFF17A7A7A),
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}