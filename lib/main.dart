import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/provider/auth_provider.dart';
import 'package:runinmor/provider/navigation_bar_provider.dart';
import 'package:runinmor/provider/route_provider.dart';
import 'package:runinmor/provider/user_provider.dart';
import 'package:runinmor/routes/route.dart';
import 'package:runinmor/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationBarProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => RouteProvider()),
      ],
      child: SafeArea(
        child: AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF714DA5),
          ),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Run Nai Mor',
            routerConfig: router,
            theme: buildTheme(),
          ),
        ),
      ),
    );
  }
}
