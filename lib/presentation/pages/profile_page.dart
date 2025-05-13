import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:map_navigator/presentation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.blueLight,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (Route<dynamic> route) => false),
          child: Icon(CupertinoIcons.back, color: ColorPalette.white, size: 31),
        ),
        title: GestureDetector(
          onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (Route<dynamic> route) => false),
          child: Text('PROFILO', style: CustomTextStyle.s31w500(ColorPalette.white)),
        ),
        titleSpacing: 0,
        toolbarHeight: 80,
      ),
      backgroundColor: ColorPalette.white,
      body: ProfileWidget(),
    );
  }
}
