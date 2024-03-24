/// Written by Thiti Phuttaamart 640510660
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationBarProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentPageIndex = 0;

  int get currentPageIndex => _currentPageIndex;

  void changePage(BuildContext context, int index) {
    _currentPageIndex = index;
    notifyListeners();

    if (index == 0) {
      context.goNamed('Home');
      // context.pushNamed('Home');
    } else if (index == 1) {
      // context.pushNamed('RouteList');
      context.goNamed('RouteList');
      // context.pushNamed('RouteList', queryParameters: {'backRoute': '/'}); // with back button
    } else if (index == 2) {
      // context.pushNamed('Ar');
      context.goNamed('History');
      // context.pushNamed('RouteList', queryParameters: {'backRoute': '/'}); // with back button
    } else {
      // _auth.signOut();
      // _currentPageIndex = 0;
      context.push('/404');
    }
  }
}
