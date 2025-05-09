import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:map_navigator/app.dart';
import 'package:map_navigator/business_logic.dart';

void main() async {
  await _initialization();

  Bloc.observer = DebugBloc();

  runApp(MultiBlocProvider(providers: _topLevelProviders(), child: App()));
}

Future<void> _initialization() async {
  /// SYSTEM SECTION:
  WidgetsFlutterBinding.ensureInitialized();
  for (var renderView in RendererBinding.instance.renderViews) {
    renderView.automaticSystemUiAdjustment = false;
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

/// BLOC SECTION:
List<BlocProvider> _topLevelProviders() {
  return [
    BlocProvider<PermissionCubit>(create: (BuildContext context) => PermissionCubit(), lazy: false),
    BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit(), lazy: false),
  ];
}
