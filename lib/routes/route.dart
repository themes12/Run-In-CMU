import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/pages/count_down_page.dart';
import 'package:runinmor/pages/history_page.dart';
import 'package:runinmor/pages/home_page.dart';
import 'package:runinmor/pages/login_page.dart';
import 'package:runinmor/pages/map_page.dart';
import 'package:runinmor/pages/route_list_page.dart';
import 'package:runinmor/pages/run_page.dart';
import 'package:runinmor/pages/run_summary_page.dart';
import 'package:runinmor/pages/setup_user_page.dart';
import 'package:runinmor/provider/auth_provider.dart';
import 'package:runinmor/provider/user_provider.dart';
import 'package:runinmor/types/RunSummary.dart';

import '../pages/ar_page.dart';
import '../pages/login_page.dart';
import '../pages/scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final auth = AuthProvider();
final user = UserProvider();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavigation(
          backRoute: state.uri.queryParameters['backRoute'],
          // isHideNavigationBar: state.uri.queryParameters['isHideNavigationBar'],
          child: child,
        );
      },
      routes: [
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
              name: "RunSummary",
              path: 'run-summary',
              builder: (BuildContext context, GoRouterState state) {
                RunSummary data = state.extra as RunSummary;
                return RunSummaryPage(
                  selectedRoute: state.uri.queryParameters['selectedRoute'],
                  runSummary: data,
                );
              },
            ),
            GoRoute(
              name: "Ar",
              path: 'ar',
              builder: (BuildContext context, GoRouterState state) {
                return ARPage(
                  filter: state.uri.queryParameters['filter'],
                );
              },
            ),
            GoRoute(
              name: "History",
              path: 'history',
              builder: (BuildContext context, GoRouterState state) {
                return HistoryAcivity();
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: "CountDown",
      path: '/countdown',
      builder: (BuildContext context, GoRouterState state) {
        return CountDownPage(
          selectedRoute: state.uri.queryParameters['selectedRoute'],
        );
      },
    ),
    GoRoute(
      name: "Run",
      path: '/run',
      builder: (BuildContext context, GoRouterState state) {
        return RunPage(
          selectedRoute: state.uri.queryParameters['selectedRoute'],
        );
      },
    ),
    GoRoute(
      name: "Login",
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginPage();
      },
    ),
    GoRoute(
      name: "SetupUser",
      path: '/setup-user',
      builder: (BuildContext context, GoRouterState state) {
        return SetupUserPage();
      },
    ),
  ],
  // redirect to the login page if the user is not logged in
  redirect: (BuildContext context, GoRouterState state) async {
    // if the user is not logged in, they need to login
    final bool loggedIn = auth.user != null;
    final bool loggingIn = state.matchedLocation == '/login';
    if (!loggedIn) {
      return '/login';
    }

    // if the user is logged in but still on the login page, send them to
    // the home page
    final userData = await user.loadUserInformation();

    if (userData == null) {
      return '/setup-user';
    }

    if (loggingIn) {
      return '/';
    }

    // no need to redirect at all
    return null;
  },

  // changes on the listenable will cause the router to refresh it's route
  // refreshListenable: Listenable.merge([auth, user]),
  refreshListenable: auth,
);
