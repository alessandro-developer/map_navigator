import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:map_navigator/data.dart';

part 'home_navigation_state.dart';

class HomeNavigationCubit extends Cubit<HomeNavigationState> {
  final Map<int, StatusOfHomePages> pageMap = {
    0: StatusOfHomePages.home,
    1: StatusOfHomePages.listPOI,
    2: StatusOfHomePages.searchPOI,
    3: StatusOfHomePages.detailsPOI,
  };

  HomeNavigationCubit() : super(const HomeNavigationState());

  void changeHomePage(int index) {
    emit(state.copyWith(statusOfHomePages: pageMap[index]));
  }
}
