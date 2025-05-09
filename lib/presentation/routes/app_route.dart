import 'package:flutter/material.dart';

import 'package:map_navigator/presentation.dart';

class AppRoute {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    late final Widget page;

    switch (routeSettings.name) {
      case settingsRoute:
        page = const SettingsPage();
        break;

      case homeRoute:
        page = const HomePage();
        break;

      default:
        return null;
    }

    return PageRouteBuilder(
      pageBuilder:
          (context, animation, secondaryAnimation) => PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, dynamic) {
              if (didPop) {
                return;
              }
            },
            child: page,
          ),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    );
  }
}
