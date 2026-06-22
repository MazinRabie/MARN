import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/property/presentation/ui/screens/property_shared_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PropertyCubit, PropertyState>(
      listener: (context, state) {
        if (state is PropertyAddSuccess) {
          context.go(AppRoutes.mainLayoutScreen);
          buildSnackBar(context, message: state.message, isError: false);
        } else if (state is PropertyAddFailure) {
          buildSnackBar(context, message: state.errorMessage, isError: true);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            PropertySharedForm(),
            if (state is PropertyAddLoading) Center(child: buildLoading()),
          ],
        );
      },
    );
  }
}
