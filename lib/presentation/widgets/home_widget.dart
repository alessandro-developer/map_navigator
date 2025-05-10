import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:map_navigator/business_logic.dart';

class HomeWidget extends StatelessWidget {
  final MapController mapController;

  const HomeWidget({required this.mapController, super.key});

  @override
  Widget build(BuildContext context) {
    // Cubit:
    final HomeCubit homeCubit = context.read<HomeCubit>();

    return Stack(
      children: <Widget>[
        /// VISUALIZZO LA MAPPA:
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.initialMapCenter == null) {
              return Container();
            }

            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: state.initialMapCenter!,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                initialZoom: state.initialMapZoom,
                onPositionChanged: (camera, hasGesture) {
                  /// OTTENGO LO ZOOM DELLA MAPPA:
                  homeCubit.getMapZoom(mapZoom: camera.zoom);

                  /// OTTENGO LA ROTAZIONE DELLA MAPPA:
                  homeCubit.getMapRotation(mapRotation: camera.rotation);

                  /// VERIFICO SE L'UTENTE INTERAGISCE CON LA MAPPA:
                  homeCubit.isUserInteracting(isUserInteracting: hasGesture);
                },
              ),
              children: <Widget>[
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'dev.fleaflet.flutter_map.example'),
                MarkerLayer(
                  markers: <Marker>[
                    Marker(
                      child: Transform.rotate(
                        angle: state.currentHeading != 0.0 ? (state.currentHeading * math.pi / 180) : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.location_north_fill, size: 20, color: Colors.white),
                        ),
                      ),
                      height: 35,
                      width: 35,
                      point: state.currentLocation!,
                      rotate: false,
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        /// VISUALIZZO LA POSIZIONE ATTUALE:
        BlocBuilder<HomeCubit, HomeState>(
          builder:
              (context, state) => Positioned(
                right: 20,
                bottom: 50,
                child: GestureDetector(
                  onTap: () => mapController.move(state.currentLocation!, 19.5),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 2), color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(CupertinoIcons.location_north, size: 25, color: Colors.blueAccent),
                  ),
                ),
              ),
        ),
      ],
    );
  }
}
