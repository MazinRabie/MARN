import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/features/property/domain/entities/card/base_property_card.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/property/presentation/ui/widgets/property_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  List<BasePropertyCard> properties = [];

  @override
  void initState() {
    context.read<PropertyCubit>().getUserProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(context),
      body: BlocConsumer<PropertyCubit, PropertyState>(
        listener: (context, state) {
          if (state is PropertyGetUserPropertiesFailure) {
            buildSnackBar(context, message: state.errorMessage, isError: true);
          }
          if (state is PropertyDeleteSuccess) {
            properties.removeAt(state.index);
          }
          if (state is PropertyGetUserPropertiesSuccess) {
            properties = state.properties;
          }
        },
        buildWhen: (previous, current) {
          return current is PropertyGetUserPropertiesLoading ||
              current is PropertyGetUserPropertiesSuccess ||
              current is PropertyGetUserPropertiesFailure;
        },
        builder: (context, state) {
          if (state is PropertyGetUserPropertiesSuccess) {
            return ListView.builder(
              itemCount: properties.length,
              itemBuilder: (context, index) {
                return PropertyCard(property: properties[index], index: index);
              },
            );
          } else if (state is PropertyGetUserPropertiesLoading) {
            return Center(child: buildLoading());
          } else {
            return Center(child: Text(LocaleKeys.propertyEmptyState.tr()));
          }
        },
      ),
    );
  }
}
