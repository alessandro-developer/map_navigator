import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:map_navigator/business_logic.dart';
import 'package:map_navigator/presentation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  StreamSubscription<HomeState>? _homeStateSubscription;

  @override
  void initState() {
    super.initState();

    final PermissionCubit permissionCubit = context.read<PermissionCubit>();
    final HomeCubit homeCubit = context.read<HomeCubit>();

    if (permissionCubit.state.permissionsGranted == true) {
      homeCubit.startLocationUpdates(permissionCubit: permissionCubit);
      homeCubit.startCompassUpdates();
    }
  }

  @override
  void dispose() {
    _homeStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Home Page')), body: HomeWidget(mapController: _mapController));
  }
}
