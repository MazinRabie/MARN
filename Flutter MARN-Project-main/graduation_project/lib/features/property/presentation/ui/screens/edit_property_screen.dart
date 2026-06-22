import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/property/domain/entities/property_edit_entity.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/property/presentation/ui/screens/property_shared_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPropertyScreen extends StatefulWidget {
  final int id;
  final int index;
  const EditPropertyScreen({super.key, required this.id, required this.index});

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyCubit>().getPropertyForEdit(propertyId: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PropertyCubit, PropertyState>(
      listener: (context, state) {
        if (state is PropertyGetPropertyForEditFailure) {
          buildSnackBar(context, message: state.errorMessage, isError: true);
        } else if (state is PropertyEditSuccess) {
          buildSnackBar(context, message: state.message, isError: false);
          Navigator.of(context).pop();
        } else if (state is PropertyToggleActiveSuccess) {
          buildSnackBar(context, message: state.message, isError: false);
        } else if (state is PropertyEditFailure) {
          buildSnackBar(context, message: state.errorMessage, isError: true);
        } else if (state is PropertyToggleActiveFailure) {
          buildSnackBar(context, message: state.errorMessage, isError: true);
        } else if (state is PropertyDeleteSuccess) {
          buildSnackBar(context, message: state.message, isError: false);
          context.read<PropertyCubit>().getUserProperties();
          context.read<PropertyCubit>().getSavedProperties();
          Navigator.of(context).pop();
        } else if (state is PropertyDeleteFailure) {
          buildSnackBar(context, message: state.errorMessage, isError: true);
        }
      },

      buildWhen: (previous, current) {
        return current is! PropertyToggleActiveSuccess &&
            current is! PropertyToggleActiveFailure &&
            current is! PropertyToggleActiveLoading &&
            current is! PropertyDeleteSuccess &&
            current is! PropertyDeleteFailure &&
            current is! PropertyDeleteLoading;
      },

      builder: (context, state) {
        bool hasLoadedData = false;
        PropertyEditEntity? loadedProperty;
        if (state is PropertyGetPropertyForEditSuccess) {
          hasLoadedData = true;
          loadedProperty = state.property;
        } else if (state is PropertyEditLoading ||
            state is PropertyEditFailure ||
            state is PropertyEditSuccess ||
            state is PropertyDeleteSuccess) {
          hasLoadedData = true;
          loadedProperty = null;
        }

        if (hasLoadedData) {
          return Stack(
            children: [
              PropertySharedForm(
                isEdit: true,
                propertyToEdit: loadedProperty,
                index: widget.index,
              ),
              if (state is PropertyEditLoading) Center(child: buildLoading()),
            ],
          );
        }

        return Scaffold(body: Center(child: buildLoading()));
      },
    );
  }
}
