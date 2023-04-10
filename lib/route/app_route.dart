import 'package:address_app/page/address/view/edit_address.dart';
import 'package:flutter/material.dart';

import '../component/bottom_bar/bottom_nav.dart';

class AppRoute {
  Route onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BottomNavBar());
      // case '/edit':
      //   return MaterialPageRoute(builder: (_) => EditAddress());
      default:
        return MaterialPageRoute(builder: (_) => BottomNavBar());
    }
  }
}
