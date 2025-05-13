part of 'home_navigation_cubit.dart';

class HomeNavigationState extends Equatable {
  final StatusOfHomePages statusOfHomePages;

  const HomeNavigationState({this.statusOfHomePages = StatusOfHomePages.home});

  HomeNavigationState copyWith({StatusOfHomePages? statusOfHomePages}) {
    return HomeNavigationState(statusOfHomePages: statusOfHomePages ?? this.statusOfHomePages);
  }

  @override
  List<Object?> get props => [statusOfHomePages];
}
