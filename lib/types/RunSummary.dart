import 'package:cloud_firestore/cloud_firestore.dart';

class RunSummary {
  final double pace;
  final num distance;
  final int time;
  final String route;
  final String uid;
  final bool forceStop;
  final Timestamp timestamp;

  RunSummary({
    required this.pace,
    required this.distance,
    required this.time,
    required this.route,
    required this.uid,
    required this.forceStop,
    required this.timestamp,
  });

  RunSummary copyWith({
    double? pace,
    double? distance,
    int? time,
    String? route,
    String? uid,
    bool? forceStop,
    Timestamp? timestamp,
  }) =>
      RunSummary(
        pace: pace ?? this.pace,
        distance: distance ?? this.distance,
        time: time ?? this.time,
        route: route ?? this.route,
        uid: uid ?? this.uid,
        forceStop: forceStop ?? this.forceStop,
        timestamp: timestamp ?? this.timestamp,
      );

  factory RunSummary.fromJson(Map<String, dynamic> json) => RunSummary(
        pace: json["pace"],
        distance: json["distance"],
        time: json["time"],
        route: json["route"],
        uid: json["uid"],
        forceStop: json["forceStop"] == "true" ? true : false,
        timestamp: json["timestamp"],
      );
}

class RunSummaryAdditional {
  final double pace;
  final num distance;
  final int time;
  final String route;
  final String uid;
  final bool isForceStop;
  final String name;
  final Timestamp timestamp;
  final String img_url;

  RunSummaryAdditional({
    required this.pace,
    required this.distance,
    required this.time,
    required this.route,
    required this.uid,
    required this.isForceStop,
    required this.name,
    required this.timestamp,
    required this.img_url,
  });

  RunSummaryAdditional copyWith({
    double? pace,
    double? distance,
    int? time,
    String? route,
    String? uid,
    bool? isForceStop,
    String? name,
    Timestamp? timestamp,
    String? img_url,
  }) =>
      RunSummaryAdditional(
        pace: pace ?? this.pace,
        distance: distance ?? this.distance,
        time: time ?? this.time,
        route: route ?? this.route,
        uid: uid ?? this.uid,
        isForceStop: isForceStop ?? this.isForceStop,
        name: name ?? this.name,
        timestamp: timestamp ?? this.timestamp,
        img_url: img_url ?? this.img_url,
      );

  factory RunSummaryAdditional.fromJson(
    Map<String, dynamic> json,
    String name,
    String img_url,
  ) =>
      RunSummaryAdditional(
        pace: json["pace"],
        distance: json["distance"],
        time: json["time"],
        route: json["route"],
        uid: json["uid"],
        isForceStop: json["isForceStop"],
        name: name,
        timestamp: json["timestamp"],
        img_url: img_url,
      );
}
