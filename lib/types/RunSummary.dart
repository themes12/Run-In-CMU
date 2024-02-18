class RunSummary {
  final double pace;
  final num distance;
  final int time;

  RunSummary({
    required this.pace,
    required this.distance,
    required this.time,
  });

  RunSummary copyWith({
    double? pace,
    double? distance,
    int? time,
  }) =>
      RunSummary(
        pace: pace ?? this.pace,
        distance: distance ?? this.distance,
        time: time ?? this.time,
      );
}
