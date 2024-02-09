import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uicons/uicons.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({super.key, this.backRoute});
  final String? backRoute;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xFF714DA5),
      leading: backRoute != null
          ? IconButton(
              onPressed: () {
                context.go(backRoute!);
              },
              icon: Icon(
                UIcons.regularRounded.angle_left,
                size: 18,
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
