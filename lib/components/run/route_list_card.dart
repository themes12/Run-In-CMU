import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runinmor/types/route_list.dart';

class RouteListCard extends StatelessWidget {
  const RouteListCard({
    super.key,
    required this.route,
  });

  final RunRoute route;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              route.imgUrl,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 28,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        route.difficulty,
                        style: const TextStyle(
                          color: Color(0xFFEBB800),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          route.name,
                          style: const TextStyle(
                            color: Color(0xFF171717),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Ink(
                          width: 32,
                          height: 32,
                          decoration: const ShapeDecoration(
                            color: Color(0xFF262626),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: Icon(
                              FluentIcons.chevron_right_12_regular,
                              size: 18,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              context.goNamed(
                                'Map',
                                queryParameters: {
                                  'backRoute': '/route-list',
                                  'selectedRoute': route.name,
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}