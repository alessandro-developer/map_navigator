import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:map_navigator/presentation.dart';

class App extends StatelessWidget {
  App({super.key});

  final appRouter = AppRoute();
  final navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder:
          (context, child) => LoaderOverlay(
            overlayColor: ColorPalette.black.withValues(alpha: 0.2),
            overlayWidgetBuilder: (_) => Center(child: CupertinoActivityIndicator(color: ColorPalette.white, radius: 15)),
            child: child!,
          ),
      initialRoute: settingsRoute,
      navigatorKey: navKey,
      onGenerateRoute: appRouter.onGenerateRoute,
      title: 'Map Navigator',
    );
  }
}
