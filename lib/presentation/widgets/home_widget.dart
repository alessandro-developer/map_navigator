import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:map_navigator/business_logic.dart';
import 'package:map_navigator/presentation.dart';

class HomeWidget extends StatelessWidget {
  final MapController mapController;

  const HomeWidget({required this.mapController, super.key});

  @override
  Widget build(BuildContext context) {
    // Cubit:
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final HomeNavigationCubit homeNavigationCubit = context.read<HomeNavigationCubit>();

    return Stack(
      children: <Widget>[
        /// VISUALIZZO LA MAPPA:
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.initialMapCenter == null || state.mapBounds == null) {
              return Container();
            }

            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                cameraConstraint: CameraConstraint.contain(bounds: state.mapBounds!),
                initialCenter: state.initialMapCenter!,
                interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                initialZoom: state.initialMapZoom,
                maxZoom: 19.5,
                minZoom: state.initialMapZoom - 1,
                onMapReady: () => mapController.move(state.initialMapCenter!, state.initialMapZoom),
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
                    if (state.currentLocation != null && state.isOut == false)
                      Marker(
                        child: Transform.rotate(
                          angle: state.currentHeading != 0.0 ? (state.currentHeading * math.pi / 180) : 0,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorPalette.white, width: 2),
                              color: ColorPalette.blueLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(CupertinoIcons.location_north_fill, size: 20, color: ColorPalette.white),
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

        /// TASTO RICERCA POI:
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Positioned(
              child: GestureDetector(
                onTap: () => homeNavigationCubit.changeHomePage(3),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: ColorPalette.white,
                    border: Border.all(color: ColorPalette.grey, width: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 0, 5),
                        child: Icon(CupertinoIcons.search, color: CupertinoColors.secondaryLabel, size: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                        child: Text('Cerca punto di interesse', style: CustomTextStyle.s15w500(ColorPalette.grey)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        /// TASTO LA LISTA POI:
        BlocBuilder<HomeCubit, HomeState>(
          builder:
              (context, state) => Positioned(
                left: 20,
                bottom: 50,
                child: GestureDetector(
                  onTap: () => homeNavigationCubit.changeHomePage(1),
                  child: SvgPicture.asset('assets/images/icons/icon_list_blue.svg', height: 60),
                ),
              ),
        ),

        /// TASTO POSIZIONE ATTUALE:
        BlocBuilder<HomeCubit, HomeState>(
          builder:
              (context, state) => Positioned(
                right: 20,
                bottom: 50,
                child: GestureDetector(
                  onTap:
                      (state.currentLocation != null && state.isOut == false)
                          ? () => mapController.move(state.currentLocation!, 19.5)
                          : () => showCupertinoDialog(
                            context: context,
                            builder:
                                (BuildContext context) => CupertinoAlertDialog(
                                  title: Text('Attenzione'),
                                  content: Text('Questa funzionalità è disponibile esclusivamente all\'interno della mappa.'),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      isDestructiveAction: true,
                                      child: Text('Chiudi', style: CustomTextStyle.s17w600(ColorPalette.blueLight)),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                          ),
                  child: SvgPicture.asset('assets/images/icons/icon_position_blue.svg', height: 60),
                ),
              ),
        ),
      ],
    );
  }
}
