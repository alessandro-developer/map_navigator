part of 'home_cubit.dart';

class HomeState extends Equatable {
  final LatLng initialMapCenter;
  final double initialMapZoom;
  final LatLng? currentLocation;
  final double currentHeading;

  const HomeState({
    this.initialMapCenter = const LatLng(38.93489044265242, 8.932107927301267),
    this.initialMapZoom = 18,
    this.currentLocation,
    this.currentHeading = 0.0,
  });

  HomeState copyWith({LatLng? initialMapCenter, double? initialMapZoom, LatLng? currentLocation, double? currentHeading}) {
    return HomeState(
      initialMapCenter: initialMapCenter ?? this.initialMapCenter,
      initialMapZoom: initialMapZoom ?? this.initialMapZoom,
      currentLocation: currentLocation ?? this.currentLocation,
      currentHeading: currentHeading ?? this.currentHeading,
    );
  }

  @override
  List<Object?> get props => [initialMapCenter, initialMapZoom, currentLocation, currentHeading];
}
