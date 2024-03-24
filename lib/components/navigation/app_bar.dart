/// Written by Thiti Phuttaamart 640510660
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/navigation_bar_provider.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({super.key, this.backRoute});
  final String? backRoute;

  @override
  Widget build(BuildContext context) {
    final navigation = Provider.of<NavigationBarProvider>(context);
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xFF714DA5),
      leading: backRoute != null
          ? IconButton(
              onPressed: () {
                navigation.changePage(context, 0);
              },
              icon: Icon(
                FluentIcons.chevron_left_24_regular,
                color: Colors.white,
              ),
            )
          : null,
      title: const Text(
        "RunNaiMor",
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      ),
      // title: const Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text(
      //       "RunNaiMor",
      //       style: TextStyle(
      //         color: Colors.white,
      //         fontSize: 28,
      //         fontWeight: FontWeight.w600,
      //       ),
      //     ),
      //     SizedBox(
      //       width: 4,
      //     ),
      //     // Icon(
      //     //   Icons.directions_run_rounded,
      //     //   size: 32,
      //     //   color: Colors.white,
      //     // ),
      //   ],
      // ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
