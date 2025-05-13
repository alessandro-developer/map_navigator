import 'package:flutter/material.dart';

void animateToPage({required int index, required PageController pageController}) {
  pageController.jumpToPage(index);
}
