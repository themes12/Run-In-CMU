import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uicons/uicons.dart';

import '../../provider/navigation_bar_provider.dart';

class NavigationBarCustom extends StatelessWidget {
  const NavigationBarCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationBarProvider>(context);

    return NavigationBar(
      indicatorColor: Colors.transparent,
      height: const Size.fromHeight(kBottomNavigationBarHeight).height,
      elevation: 1,
      backgroundColor: const Color(0xFFF5F5F5),
      onDestinationSelected: (int index) =>
          navigation.changePage(context, index),
      selectedIndex: navigation.currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(
            FluentIcons.home_24_regular,
            color: Color(0xFF522693),
          ),
          icon: Icon(
            FluentIcons.home_24_regular,
            color: Color(0xFFB1B1B1),
          ),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            FluentIcons.run_24_regular,
            color: Color(0xFF522693),
          ),
          icon: Icon(
            FluentIcons.run_24_regular,
            color: Color(0xFFB1B1B1),
          ),
          label: 'Run',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            FluentIcons.calendar_data_bar_24_regular,
            color: Color(0xFF522693),
          ),
          icon: Icon(
            FluentIcons.calendar_data_bar_24_regular,
            color: Color(0xFFB1B1B1),
          ),
          label: 'Activity',
        ),
      ],
    );
  }
}
