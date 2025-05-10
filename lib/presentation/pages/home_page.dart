import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:formz/formz.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
      homeCubit.getCurrentPosition(permissionCubit: permissionCubit);

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
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: MultiBlocListener(
        listeners: [
          /// OTTENGO LA POSIZIONE INIZIALE:
          BlocListener<HomeCubit, HomeState>(
            listenWhen: (previous, current) => previous.initialMapStatus != current.initialMapStatus,
            listener:
                (context, state) => switch (state.initialMapStatus) {
                  FormzSubmissionStatus.inProgress => context.loaderOverlay.show(),
                  FormzSubmissionStatus.success => context.loaderOverlay.hide(),
                  FormzSubmissionStatus.failure => {
                    context.loaderOverlay.hide(),
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(backgroundColor: Colors.grey, content: Text('Errore ottenimento posizione iniziale'))),
                  },
                  (_) => context.loaderOverlay.hide(),
                },
          ),
        ],
        child: HomeWidget(mapController: _mapController),
      ),
    );
  }
}
