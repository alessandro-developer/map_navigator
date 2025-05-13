import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:map_navigator/business_logic.dart';

class ListPOIWidget extends StatelessWidget {
  const ListPOIWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Cubit:
    final HomeNavigationCubit homeNavigationCubit = context.read<HomeNavigationCubit>();

    return Stack(
      children: <Widget>[
        /// TASTO LA LISTA POI:
        BlocBuilder<HomeCubit, HomeState>(
          builder:
              (context, state) => Positioned(
                left: 20,
                bottom: 50,
                child: GestureDetector(
                  onTap: () => homeNavigationCubit.changeHomePage(0),
                  child: SvgPicture.asset('assets/images/icons/icon_map_blue.svg', height: 60),
                ),
              ),
        ),
      ],
    );
  }
}
