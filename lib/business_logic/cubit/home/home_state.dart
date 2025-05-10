part of 'home_cubit.dart';

class HomeState extends Equatable {
  final LatLng? initialMapCenter;
  final double initialMapZoom;
  final FormzSubmissionStatus initialMapStatus;
  final LatLng? currentLocation;
  final double currentHeading;

  const HomeState({
    this.initialMapCenter,
    this.initialMapZoom = 18.0,
    this.initialMapStatus = FormzSubmissionStatus.initial,
    this.currentLocation,
    this.currentHeading = 0.0,
  });

  HomeState copyWith({
    LatLng? initialMapCenter,
    double? initialMapZoom,
    FormzSubmissionStatus? initialMapStatus,
    LatLng? currentLocation,
    double? currentHeading,
  }) {
    return HomeState(
      initialMapCenter: initialMapCenter ?? this.initialMapCenter,
      initialMapZoom: initialMapZoom ?? this.initialMapZoom,
      initialMapStatus: initialMapStatus ?? this.initialMapStatus,
      currentLocation: currentLocation ?? this.currentLocation,
      currentHeading: currentHeading ?? this.currentHeading,
    );
  }

  @override
  List<Object?> get props {
    return [initialMapCenter, initialMapZoom, initialMapStatus, currentLocation, currentHeading];
  }
}
