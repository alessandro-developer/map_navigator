part of 'permission_cubit.dart';

class PermissionState extends Equatable {
  final FormzSubmissionStatus permissionsStatus;
  final bool openAppSettings;
  final bool openLocationSettings;
  final bool serviceEnabled;
  final bool permissionsGranted;

  const PermissionState({
    this.permissionsStatus = FormzSubmissionStatus.initial,
    this.openAppSettings = false,
    this.openLocationSettings = false,
    this.serviceEnabled = false,
    this.permissionsGranted = false,
  });

  PermissionState copyWith({
    FormzSubmissionStatus? permissionsStatus,
    bool? openAppSettings,
    bool? openLocationSettings,
    bool? serviceEnabled,
    bool? permissionsGranted,
  }) {
    return PermissionState(
      permissionsStatus: permissionsStatus ?? this.permissionsStatus,
      openAppSettings: openAppSettings ?? this.openAppSettings,
      openLocationSettings: openLocationSettings ?? this.openLocationSettings,
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
    );
  }

  @override
  List<Object?> get props {
    return [permissionsStatus, openAppSettings, openLocationSettings, serviceEnabled, permissionsGranted];
  }
}
