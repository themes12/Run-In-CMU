import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/navigation/app_bar.dart';
import '../components/navigation/bottom_navigation_bar_custom.dart';
import '../provider/navigation_bar_provider.dart';

class ScaffoldWithNavigation extends StatelessWidget {
  final Widget child;
  final String? backRoute;
  // final String? isHideNavigationBar;
  const ScaffoldWithNavigation({
    super.key,
    required this.child,
    this.backRoute,
    // this.isHideNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF714DA5),
      appBar: AppBarCustom(
        backRoute: backRoute,
      ),
      bottomNavigationBar: NavigationBarCustom(),
      // bottomNavigationBar: isHideNavigationBar == null
      //     ? const NavigationBarCustom()
      //     : Container(),
      body: child,
    );
  }
}
