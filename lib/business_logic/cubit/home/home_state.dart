part of 'home_cubit.dart';

class HomeState extends Equatable {
  final LatLng? initialMapCenter;
  final double initialMapZoom;
  final FormzSubmissionStatus initialMapStatus;
  final LatLng? currentLocation;
  final double currentHeading;
  final LatLngBounds? mapBounds;
  final bool isOut;
  final double mapZoom;
  final double mapRotation;
  final bool isUserInteracting;

  const HomeState({
    this.initialMapCenter,
    this.initialMapZoom = 18.0,
    this.initialMapStatus = FormzSubmissionStatus.initial,
    this.currentLocation,
    this.currentHeading = 0.0,
    this.mapBounds,
    this.isOut = false,
    this.mapZoom = 0.0,
    this.mapRotation = 0.0,
    this.isUserInteracting = false,
  });

  HomeState copyWith({
    LatLng? initialMapCenter,
    double? initialMapZoom,
    FormzSubmissionStatus? initialMapStatus,
    LatLng? currentLocation,
    double? currentHeading,
    LatLngBounds? mapBounds,
    bool? isOut,
    double? mapZoom,
    double? mapRotation,
    bool? isUserInteracting,
  }) {
    return HomeState(
      initialMapCenter: initialMapCenter ?? this.initialMapCenter,
      initialMapZoom: initialMapZoom ?? this.initialMapZoom,
      initialMapStatus: initialMapStatus ?? this.initialMapStatus,
      currentLocation: currentLocation ?? this.currentLocation,
      currentHeading: currentHeading ?? this.currentHeading,
      mapBounds: mapBounds ?? this.mapBounds,
      isOut: isOut ?? this.isOut,
      mapZoom: mapZoom ?? this.mapZoom,
      mapRotation: mapRotation ?? this.mapRotation,
      isUserInteracting: isUserInteracting ?? this.isUserInteracting,
    );
  }

  @override
  List<Object?> get props {
    return [
      initialMapCenter,
      initialMapZoom,
      initialMapStatus,
      currentLocation,
      currentHeading,
      mapBounds,
      isOut,
      mapZoom,
      mapRotation,
      isUserInteracting,
    ];
  }
}
