import 'package:MARN/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget buildLoading() {
  // return Center(
  //   child: CircularProgressIndicator(
  //     color: AppColors.white,
  //     strokeWidth: 5,
  //     padding: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
  //   ),
  // );
  return LoadingAnimationWidget.hexagonDots(
    color: AppColors.primary,
    size: 100,
  );
}
