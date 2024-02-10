import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RunRouteList {
  final List<RunRoute> data;

  RunRouteList({
    required this.data,
  });

  RunRouteList copyWith({
    List<RunRoute>? data,
  }) =>
      RunRouteList(
        data: data ?? this.data,
      );

  factory RunRouteList.fromRawJson(String str) =>
      RunRouteList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RunRouteList.fromJson(Map<String, dynamic> json) => RunRouteList(
        data:
            List<RunRoute>.from(json["data"].map((x) => RunRoute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class RunRoute {
  final String name;
  final String difficulty;
  final String imgUrl;
  final LatLng startPosition;
  final LatLng endPosition;
  final List<LatLng> polylinePoints;

  RunRoute({
    required this.name,
    required this.difficulty,
    required this.imgUrl,
    required this.startPosition,
    required this.endPosition,
    required this.polylinePoints,
  });

  RunRoute copyWith({
    String? name,
    String? difficulty,
    String? imgUrl,
    LatLng? startPosition,
    LatLng? endPosition,
    List<LatLng>? polylinePoints,
  }) =>
      RunRoute(
        name: name ?? this.name,
        difficulty: difficulty ?? this.difficulty,
        imgUrl: imgUrl ?? this.imgUrl,
        startPosition: startPosition ?? this.startPosition,
        endPosition: endPosition ?? this.endPosition,
        polylinePoints: polylinePoints ?? this.polylinePoints,
      );

  factory RunRoute.fromRawJson(String str) =>
      RunRoute.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RunRoute.fromJson(Map<String, dynamic> json) => RunRoute(
        name: json["name"],
        difficulty: json["difficulty"],
        imgUrl: json["img_url"],
        startPosition: LatLng(
          json["start_position"]["latitude"],
          json["start_position"]["longitude"],
        ),
        endPosition: LatLng(
          json["end_position"]["latitude"],
          json["end_position"]["longitude"],
        ),
        polylinePoints: PolylinePoints()
            .decodePolyline(json["polylineString"])
            .map((value) => LatLng(value.latitude, value.longitude))
            .toList(),
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
      };
}
