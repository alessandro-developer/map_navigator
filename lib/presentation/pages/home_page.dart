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
  final PageController _pageController = PageController();
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
    // Cubit:
    final HomeNavigationCubit homeNavigationCubit = context.read<HomeNavigationCubit>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.blueLight,
        centerTitle: true,
        leading: BlocBuilder<HomeNavigationCubit, HomeNavigationState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(profileRoute, (Route<dynamic> route) => false),
              child: Icon(Icons.person_rounded, color: ColorPalette.white, size: 31),
            );
          },
        ),
        title: GestureDetector(
          onTap: () => homeNavigationCubit.changeHomePage(0),
          child: Text('LOGO', style: CustomTextStyle.s31w500(ColorPalette.white)),
        ),
        titleSpacing: 0,
        toolbarHeight: 80,
      ),
      backgroundColor: ColorPalette.white,
      body: MultiBlocListener(
        listeners: [
          /// HOME NAVIGATION:
          BlocListener<HomeNavigationCubit, HomeNavigationState>(
            listenWhen: (prevState, currState) => prevState.statusOfHomePages != currState.statusOfHomePages,
            listener:
                (context, state) => Future.delayed(
                  const Duration(milliseconds: 0),
                  () => animateToPage(index: state.statusOfHomePages.index, pageController: _pageController),
                ),
          ),

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
                      ..showSnackBar(SnackBar(backgroundColor: ColorPalette.grey, content: Text('Errore ottenimento posizione iniziale'))),
                  },
                  (_) => context.loaderOverlay.hide(),
                },
          ),
        ],
        child: Center(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[HomeWidget(mapController: _mapController), ListPOIWidget(), SearchPOIWidget()],
          ),
        ),
      ),
    );
  }
}
