import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(PermissionState());

  /// INIZIALIZZO IL PLUGIN GELOCATOR:
  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;

  /// GESTISCO I PERMESSI:
  Future<bool> handlePermission() async {
    emit(state.copyWith(permissionsStatus: FormzSubmissionStatus.inProgress));

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await geolocatorPlatform.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(permissionsStatus: FormzSubmissionStatus.failure, serviceEnabled: false, openAppSettings: false, openLocationSettings: true),
        );

        return false;
      }

      permission = await geolocatorPlatform.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await geolocatorPlatform.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              permissionsStatus: FormzSubmissionStatus.failure,
              permissionsGranted: false,
              openAppSettings: true,
              openLocationSettings: false,
            ),
          );

          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            permissionsStatus: FormzSubmissionStatus.failure,
            permissionsGranted: false,
            openAppSettings: true,
            openLocationSettings: false,
          ),
        );

        return false;
      }

      emit(state.copyWith(permissionsStatus: FormzSubmissionStatus.success, serviceEnabled: true, permissionsGranted: true));
      return true;
    } catch (e) {
      emit(state.copyWith(permissionsStatus: FormzSubmissionStatus.failure));
      return false;
    }
  }

  /// APRO IMPOSTAZIONI APP:
  Future<void> openAppSettings() async {
    await geolocatorPlatform.openAppSettings();
  }

  /// APRO IMPOSTAZIONI POSIZIONE DISPOSITIVO:
  Future<void> openLocationSettings() async {
    await geolocatorPlatform.openLocationSettings();
  }
}
