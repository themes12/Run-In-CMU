import 'package:flutter/material.dart';

import '../components/navigation/app_bar.dart';
import '../components/navigation/bottom_navigation_bar_custom.dart';

class ScaffoldWithNavigation extends StatelessWidget {
  final Widget child;
  final String? backRoute;
  const ScaffoldWithNavigation({
    super.key,
    required this.child,
    this.backRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF714DA5),
      appBar: AppBarCustom(
        backRoute: backRoute,
      ),
      bottomNavigationBar: const NavigationBarCustom(),
      body: child,
    );
  }
}
