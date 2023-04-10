import 'package:address_app/route/app_route.dart';
import 'package:address_app/style/color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRoute _appRoute = AppRoute();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Address',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorTheme,
      ),
      onGenerateRoute: _appRoute.onGenerateRoute,
    );
  }
}
