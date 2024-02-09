import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runinmor/provider/navigation_bar_provider.dart';
import 'package:runinmor/route/route.dart';
import 'package:runinmor/theme/theme.dart';

void main() {
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
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'RunNaiMor',
          routerConfig: router,
          theme: buildTheme(),
        ),
      ),
    );
  }
}
