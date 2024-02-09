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
      height: const Size.fromHeight(kBottomNavigationBarHeight * 1.1).height,
      elevation: 1,
      backgroundColor: const Color(0xFFF5F5F5),
      onDestinationSelected: (int index) =>
          navigation.changePage(context, index),
      selectedIndex: navigation.currentPageIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: Icon(
            UIcons.regularRounded.home,
            color: const Color(0xFF522693),
          ),
          icon: Icon(
            UIcons.regularRounded.home,
            color: const Color(0xFFB1B1B1),
          ),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            UIcons.regularRounded.running,
            color: const Color(0xFF522693),
          ),
          icon: Icon(
            UIcons.regularRounded.running,
            color: const Color(0xFFB1B1B1),
          ),
          label: 'Run',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            UIcons.regularRounded.stats,
            color: const Color(0xFF522693),
          ),
          icon: Icon(
            UIcons.regularRounded.stats,
            color: const Color(0xFFB1B1B1),
          ),
          label: 'Activity',
        ),
      ],
    );

    // @override
    // Widget build(BuildContext context) {
    //   final navigation = Provider.of<NavigationBarProvider>(context);
    //
    //   return BottomNavigationBar(
    //     backgroundColor: const Color(0xFFF5F5F5),
    //     elevation: 0,
    //     selectedFontSize: 15,
    //     unselectedFontSize: 15,
    //     type: BottomNavigationBarType.fixed,
    //     currentIndex: navigation.currentPageIndex,
    //     onTap: (index) => navigation.changePage(index),
    //     unselectedLabelStyle: const TextStyle(
    //       color: Color(0xFFB1B1B1),
    //       fontWeight: FontWeight.w400,
    //     ),
    //     unselectedItemColor: const Color(0xFFB1B1B1),
    //     unselectedIconTheme: const IconThemeData(
    //       color: Color(0xFFB1B1B1),
    //     ),
    //     selectedLabelStyle: const TextStyle(
    //       color: Color(0xFF522693),
    //       fontWeight: FontWeight.w400,
    //     ),
    //     selectedItemColor: const Color(0xFF522693),
    //     selectedIconTheme: const IconThemeData(
    //       color: Color(0xFF522693),
    //     ),
    //     items: [
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           UIcons.regularRounded.home,
    //         ),
    //         activeIcon: Icon(
    //           UIcons.regularRounded.home,
    //         ),
    //         label: 'Home',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           UIcons.regularRounded.running,
    //         ),
    //         activeIcon: Icon(
    //           UIcons.regularRounded.running,
    //         ),
    //         label: 'Run',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(
    //           UIcons.regularRounded.stats,
    //         ),
    //         activeIcon: Icon(
    //           UIcons.regularRounded.stats,
    //         ),
    //         label: 'Activity',
    //       ),
    //     ],
    //   );
  }
}
