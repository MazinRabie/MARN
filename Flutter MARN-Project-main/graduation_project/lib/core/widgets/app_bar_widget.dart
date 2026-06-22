import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:flutter/material.dart';

AppBar appBarWidget(BuildContext context, {List<Widget>? actions}) {
  return AppBar(
    title: buildAppBar(context),
    centerTitle: true,
    elevation: 0,
    backgroundColor: AppColors.transparent,
    actions: actions,
  );
}
