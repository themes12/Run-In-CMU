import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationBarProvider extends ChangeNotifier {
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
    } else if (index == 3) {
      // context.pushNamed('Ar');
      context.goNamed('Ar');
      // context.pushNamed('RouteList', queryParameters: {'backRoute': '/'}); // with back button
    } else {
      _currentPageIndex = 0;
      context.push('/404');
    }
  }
}
