import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:runinmor/pages/home_page.dart';
import 'package:runinmor/pages/map_page.dart';

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
            // This screen is displayed on the ShellRoute's Navigator.
            GoRoute(
              name: "Map",
              path: 'map',
              builder: (BuildContext context, GoRouterState state) {
                return const MapPage();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
