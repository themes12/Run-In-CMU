import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runinmor/types/RunSummary.dart';

import '../types/route_list.dart';

class RouteProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Iterable<RunRoute> _routeList = [];
  Iterable<RunRoute> get routeList => _routeList;

  Iterable<RunSummaryAdditional> _historyList = [];
  Iterable<RunSummaryAdditional> get historyList => _historyList;

  Future<Iterable<RunRoute>?> loadRouteList() async {
    try {
      final snapshot = await _db.collection("routes").get();
      _routeList = snapshot.docs.map(
        (e) => RunRoute.fromJson(
          e.data(),
          e.id,
        ),
      );
      return _routeList;
    } catch (e) {
      return null;
    }
  }

  Future<Iterable<RunSummaryAdditional>?> loadHistory() async {
    try {
      final routeList = await loadRouteList();
      final snapshot = await _db
          .collection("histories")
          .where("uid", isEqualTo: _auth.currentUser!.uid)
          .orderBy("timestamp", descending: true)
          .get();
      _historyList = snapshot.docs.map(
        (e) {
          final route = routeList!
              .firstWhereOrNull((element) => element.uid == e.data()["route"]);
          if (route != null) {
            return RunSummaryAdditional.fromJson(
              e.data(),
              route.name,
              route.imgUrl,
            );
          } else {
            return RunSummaryAdditional.fromJson(
              e.data(),
              "Unknown Route",
              "https://i.imgur.com/yIqluuS.png",
            );
          }
        },
      );
      return _historyList;
    } catch (e) {
      return null;
    }
  }

  Future<void> onFinished(BuildContext context, RunSummary runSummary) async {
    await _db.collection("histories").add(
      {
        "pace": runSummary.pace,
        "time": runSummary.time,
        "distance": runSummary.distance,
        "uid": _auth.currentUser!.uid,
        "route": runSummary.route,
        "isForceStop": runSummary.forceStop,
        "timestamp": FieldValue.serverTimestamp(),
      },
    );

    await _db.collection("users").doc(_auth.currentUser!.uid).update({
      "total_distance": FieldValue.increment((runSummary.distance / 1000).toInt()),
      "total_time": FieldValue.increment(DateTime.fromMillisecondsSinceEpoch(
        runSummary.time,
      ).minute),
    });

    if (context.mounted) {
      context.goNamed(
        'RunSummary',
        queryParameters: {
          'selectedRoute': runSummary.route,
          'backRoute': '/',
        },
        extra: runSummary,
      );
    }
  }

  Future<RunSummaryAdditional?> loadOverallBestStats() async {
    try {
      await loadRouteList();
      final snapshot = await _db
          .collection("histories")
          .where("uid", isEqualTo: _auth.currentUser!.uid)
          .orderBy("pace", descending: true)
          .limit(1)
          .get();
      final route = routeList
          .firstWhereOrNull((element) => element.uid == snapshot.docs[0].data()["route"]);
      if(snapshot.docs.isEmpty) {
        return null;
      }
      if (route != null) {
        return RunSummaryAdditional.fromJson(
          snapshot.docs[0].data(),
          route.name,
          route.imgUrl,
        );
      } else {
        return RunSummaryAdditional.fromJson(
          snapshot.docs[0].data(),
          "Unknown Route",
          "https://i.imgur.com/yIqluuS.png",
        );
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<RunSummary?> loadRouteBestStats(RunSummary runSummary) async {
    try {
      final snapshot = await _db
          .collection("histories")
          .where("route", isEqualTo: runSummary.route)
          .where("uid", isEqualTo: _auth.currentUser!.uid)
          .orderBy("pace", descending: true)
          .limit(1)
          .get();
      if(snapshot.docs.isEmpty) {
        return null;
      }
      return RunSummary.fromJson(snapshot.docs[0].data());
    } catch (e) {
      return null;
    }
  }

  Future<void> calculateFilter(
      BuildContext context, RunSummary runSummary) async {
    print("status ${runSummary.forceStop}");
    String filter = "";
    final bestStat = await loadRouteBestStats(runSummary);
    print("bestStat ${bestStat!.pace} ${runSummary.pace}");

    if (bestStat == null || runSummary.pace > bestStat.pace) {
      filter = "Newrecord";
    } else if (runSummary.pace < bestStat.pace || runSummary.forceStop) {
      filter = "Nicetry";
    } else if (runSummary.pace == bestStat.pace) {
      filter = "Normal";
    }

    print("fiiler $filter");

    if (context.mounted) {
      context.goNamed(
        'Ar',
        queryParameters: {
          'filter': filter,
          'backRoute': '/',
        },
      );
    }
  }
}
