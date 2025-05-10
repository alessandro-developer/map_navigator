import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:map_navigator/business_logic.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  /// INIZIALIZZO IL PLUGIN GELOCATOR:
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;

  /// OTTENGO LA POSIZIONE INIZIALE:
  getCurrentPosition({required PermissionCubit permissionCubit}) async {
    final bool hasPermission = await permissionCubit.handlePermission();
    if (!hasPermission) {
      return;
    }

    emit(state.copyWith(initialMapStatus: FormzSubmissionStatus.inProgress));
    try {
      final Position currentPosition = await geolocatorPlatform.getCurrentPosition();
      final LatLng initialMapCenter = LatLng(currentPosition.latitude, currentPosition.longitude);

      emit(state.copyWith(initialMapStatus: FormzSubmissionStatus.success, initialMapCenter: initialMapCenter));
    } catch (e) {
      emit(state.copyWith(initialMapStatus: FormzSubmissionStatus.failure));
    }
  }

  /// INIZIALIZZO GLI STREAM:
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<CompassEvent>? _compassStreamSubscription;

  /// IMPOSTAZIONI LOCALIZZAZIONE:
  LocationSettings _getLocationSettings() {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
        intervalDuration: const Duration(seconds: 1),
        useMSLAltitude: true,
      );
    } else if (Platform.isIOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
        activityType: ActivityType.fitness,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true,
      );
    } else {
      return const LocationSettings(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 0);
    }
  }

  /// INIZIA A LEGGERE LA POSIZIONE ATTUALE:
  Future<void> startLocationUpdates({required PermissionCubit permissionCubit}) async {
    final hasPermission = await permissionCubit.handlePermission();
    if (!hasPermission) {
      return;
    }

    final locationSettings = _getLocationSettings();

    _positionStreamSubscription = geolocatorPlatform
        .getPositionStream(locationSettings: locationSettings)
        .listen(
          (Position currentLocation) {
            final LatLng currentLatLng = LatLng(currentLocation.latitude, currentLocation.longitude);

            emit(state.copyWith(currentLocation: currentLatLng));
          },
          onError: (e) {
            emit(state.copyWith(currentLocation: null));
            print("Errore durante l'ascolto della posizione: $e");
          },
          onDone: () {
            emit(state.copyWith(currentLocation: null));
            print("L'ascolto della posizione è stato completato.");
          },
          cancelOnError: true,
        );
  }

  /// STOPPA LA LETTURA DELLA POSIZIONE ATTUALE:
  Future<void> stopLocationUpdates() async {
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    emit(state.copyWith(currentLocation: null));
  }

  /// INIZIA A LEGGERE L'HEADING DELLA BUSSOLA:
  Future<void> startCompassUpdates() async {
    _compassStreamSubscription = FlutterCompass.events?.listen(
      (CompassEvent event) {
        if (event.heading != null) {
          emit(state.copyWith(currentHeading: event.heading!));
        }
      },
      onError: (e) {
        emit(state.copyWith(currentHeading: null));
        print("Errore durante l'ascolto della bussola: $e");
      },
      onDone: () {
        emit(state.copyWith(currentHeading: null));
        print("L'ascolto della bussola è stato completato.");
      },
      cancelOnError: true,
    );
  }

  /// STOPPA LA LETTURA DELL'HEADING DELLA BUSSOLA:
  Future<void> stopCompassUpdates() async {
    await _compassStreamSubscription?.cancel();
    _compassStreamSubscription = null;

    emit(state.copyWith(currentHeading: null));
  }

  /// CHIUDO GLI STREAM:
  // Chiudo gli stream di posizione e bussola quando il cubit viene chiuso per evitare perdite di memoria (garantisce che le risorse vengano rilasciate correttamente).
  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    _compassStreamSubscription?.cancel();

    return super.close();
  }
}
