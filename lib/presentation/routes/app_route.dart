import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:map_navigator/business_logic.dart';
import 'package:map_navigator/presentation.dart';

class AppRoute {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    late final Widget page;

    switch (routeSettings.name) {
      case settingsRoute:
        page = const SettingsPage();
        break;

      case homeRoute:
        page = MultiBlocProvider(
          providers: <BlocProvider>[
            BlocProvider<HomeNavigationCubit>(create: (context) => HomeNavigationCubit()),
            BlocProvider<HomeCubit>(create: (context) => HomeCubit(), lazy: false),
          ],
          child: HomePage(),
        );
        break;

      case profileRoute:
        page = const ProfilePage();
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
