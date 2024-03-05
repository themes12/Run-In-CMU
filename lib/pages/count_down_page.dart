import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountDownPage extends StatefulWidget {
  const CountDownPage({super.key, required this.selectedRoute});

  final String? selectedRoute;

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(4),
  ); // Create instance.

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) {
      if (value <= 1200) {
        context.goNamed(
          // context.pushNamed(
          'Run',
          queryParameters: {
            "selectedRoute": widget.selectedRoute,
          },
        );
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    _stopWatchTimer.onStartTimer();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7450a8),
              Color(0xFF522693),
            ],
            stops: [0, 0.6],
          ),
        ),
        child: StreamBuilder<int>(
          stream: _stopWatchTimer.secondTime,
          initialData: 3,
          builder: (context, snap) {
            final value = snap.data;
            return Center(
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 128,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
