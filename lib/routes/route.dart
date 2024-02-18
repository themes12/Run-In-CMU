import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:runinmor/pages/home_page.dart';
import 'package:runinmor/pages/map_page.dart';
import 'package:runinmor/pages/route_list_page.dart';

import '../pages/ar_page.dart';
import '../pages/scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavigation(
          backRoute: state.uri.queryParameters['backRoute'],
          child: child,
        );
      },
      routes: [
        // This screen is displayed on the ShellRoute's Navigator.
        GoRoute(
          name: "Home",
          path: '/',
          builder: (context, state) {
            return const HomePage();
          },
          routes: <RouteBase>[
            GoRoute(
              name: "RouteList",
              path: 'route-list',
              builder: (BuildContext context, GoRouterState state) {
                return const RouteListPage();
              },
            ),
            GoRoute(
              name: "Map",
              path: 'map',
              builder: (BuildContext context, GoRouterState state) {
                return MapPage(
                  selectedRoute: state.uri.queryParameters['selectedRoute'],
                );
              },
            ),
            GoRoute(
              name: "AR", // Name of the route
              path: 'ar7', // Path to navigate to AR page
              builder: (BuildContext context, GoRouterState state) {
                return ARPage();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
