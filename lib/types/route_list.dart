/// Generated from Quicktype
/// Edited by Thiti Phuttaamart 640510660
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RunRoute {
  final String name;
  final String difficulty;
  final String imgUrl;
  final LatLng startPosition;
  final LatLng endPosition;
  final List<LatLng> polylinePoints;
  final String uid;

  RunRoute({
    required this.name,
    required this.difficulty,
    required this.imgUrl,
    required this.startPosition,
    required this.endPosition,
    required this.polylinePoints,
    required this.uid,
  });

  RunRoute copyWith({
    String? name,
    String? difficulty,
    String? imgUrl,
    LatLng? startPosition,
    LatLng? endPosition,
    List<LatLng>? polylinePoints,
    String? uid,
  }) =>
      RunRoute(
        name: name ?? this.name,
        difficulty: difficulty ?? this.difficulty,
        imgUrl: imgUrl ?? this.imgUrl,
        startPosition: startPosition ?? this.startPosition,
        endPosition: endPosition ?? this.endPosition,
        polylinePoints: polylinePoints ?? this.polylinePoints,
        uid: uid ?? this.uid,
      );

  // factory RunRoute.fromRawJson(String str) =>
  //     RunRoute.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RunRoute.fromJson(Map<String, dynamic> json, String uid) => RunRoute(
        name: json["name"],
        difficulty: json["difficulty"],
        imgUrl: json["img_url"],
        startPosition: LatLng(
          (json["start_position"] as GeoPoint).latitude,
          (json["start_position"] as GeoPoint).longitude,
        ),
        endPosition: LatLng(
          (json["end_position"] as GeoPoint).latitude,
          (json["end_position"] as GeoPoint).longitude,
        ),
        polylinePoints: PolylinePoints()
            .decodePolyline(json["polyline"])
            .map((value) => LatLng(value.latitude, value.longitude))
            .toList(),
        uid: uid,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "difficulty": difficulty,
        "img_url": imgUrl,
        "start_position": {
          "latitude": startPosition.latitude,
          "longitude": startPosition.longitude
        },
        "end_position": {
          "latitude": endPosition.latitude,
          "longitude": endPosition.longitude,
        },
        "uid": uid,
      };
}
