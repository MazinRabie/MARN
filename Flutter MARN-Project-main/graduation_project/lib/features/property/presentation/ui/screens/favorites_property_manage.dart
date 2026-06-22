import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/property/presentation/ui/widgets/property_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPropertyManage extends StatefulWidget {
  const FavoritesPropertyManage({super.key});

  @override
  State<FavoritesPropertyManage> createState() =>
      _FavoritesPropertyManageState();
}

class _FavoritesPropertyManageState extends State<FavoritesPropertyManage> {
  @override
  void initState() {
    context.read<PropertyCubit>().getSavedProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(context),
      body: BlocConsumer<PropertyCubit, PropertyState>(
        listener: (context, state) {
          if (state is PropertyGetSavedPropertiesFailure) {
            buildSnackBar(context, message: state.errorMessage, isError: true);
          }
        },
        buildWhen: (previous, current) {
          return current is PropertyGetSavedPropertiesLoading ||
              current is PropertyGetSavedPropertiesSuccess ||
              current is PropertyGetSavedPropertiesFailure;
        },
        builder: (context, state) {
          if (state is PropertyGetSavedPropertiesSuccess) {
            return ListView.builder(
              itemCount: state.properties.length,
              itemBuilder: (context, index) {
                return PropertyCard(
                  property: state.properties[index],
                  index: index,
                );
              },
            );
          } else if (state is PropertyGetSavedPropertiesLoading) {
            return Center(child: buildLoading());
          } else {
            return Center(child: Text(LocaleKeys.propertyEmptyState.tr()));
          }
        },
      ),
    );
  }
}
