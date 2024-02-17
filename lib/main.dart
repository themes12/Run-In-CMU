import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/provider/navigation_bar_provider.dart';
import 'package:runinmor/routes/route.dart';
import 'package:runinmor/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationBarProvider()),
      ],
      child: SafeArea(
        child: AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF714DA5),
          ),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'RunNaiMor',
            routerConfig: router,
            theme: buildTheme(),
          ),
        ),
      ),
    );
  }
}
