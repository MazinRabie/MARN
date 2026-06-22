import 'dart:io';
import 'package:MARN/core/widgets/url_to_filecached.dart';
import 'package:MARN/core/widgets/image_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_setting_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController arabicAddressController;
  late final TextEditingController arabicFullNameController;
  late final TextEditingController nationalIDNumberController;

  File? frontIdImage;
  String? frontIdImagePath;

  File? backIdImage;
  String? backIdImagePath;

  bool showErrorIdFront = false;
  bool showErrorIdBack = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    arabicAddressController = TextEditingController();
    arabicFullNameController = TextEditingController();
    nationalIDNumberController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileSettingCubit>().getProfileSettingsInfo();
    });
  }

  @override
  void dispose() {
    arabicAddressController.dispose();
    arabicFullNameController.dispose();
    nationalIDNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(
        context,
        actions: [
          IconButton(
            onPressed: () async {
              if (frontIdImage == null) {
                setState(() {
                  showErrorIdFront = true;
                });
              } else {
                setState(() {
                  showErrorIdFront = false;
                });
              }
              if (backIdImage == null) {
                setState(() {
                  showErrorIdBack = true;
                });
              } else {
                setState(() {
                  showErrorIdBack = false;
                });
              }

              if (_formKey.currentState!.validate()) {
                if ((frontIdImage != null || frontIdImagePath != null) &&
                    (backIdImage != null || backIdImagePath != null)) {
                  context.read<ProfileSettingCubit>().editIdentityProfile(
                    frontIdImage:
                        frontIdImage ??
                        await urlToFileCached(frontIdImagePath!),
                    backIdImage:
                        backIdImage ?? await urlToFileCached(backIdImagePath!),
                    nationalIDNumber: nationalIDNumberController.text.trim(),
                    arabicFullName: arabicFullNameController.text.trim(),
                    arabicAddress: arabicAddressController.text.trim(),
                  );
                }
              }
            },
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<ProfileSettingCubit, ProfileSettingState>(
          listener: (context, state) {
            if (state is GetProfileSettingsInfoLoaded) {
              final data = state.profileSettingsEntity;

              arabicAddressController.text = data.arabicAddress ?? "";
              arabicFullNameController.text = data.arabicFullName ?? "";
              nationalIDNumberController.text = data.nationalIDNumber ?? "";
              frontIdImagePath = data.frontIdPhoto;
              backIdImagePath = data.backIdPhoto;
            }
            if (state is SettingsError) {
              buildSnackBar(
                context,
                message: state.errorMessage,
                isError: true,
              );
            }
            if (state is EditIdentityProfileSuccess) {
              buildSnackBar(context, message: state.message, isError: false);
            }
          },
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: CustomGeneralContainer(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              alignment: WrapAlignment.center,
                              children: [
                                ImageCardWidget(
                                  imagePath: frontIdImagePath,
                                  labelText: LocaleKeys.profileVerificationFrontIdCard.tr(),
                                  width: 300,
                                  height: 175,
                                  isEditable: true,
                                  isRequired: true,
                                  showError: showErrorIdFront,
                                  errorText: LocaleKeys.profileVerificationFrontIdRequired.tr(),
                                  onImagePicked: (file) {
                                    frontIdImage = file;
                                    frontIdImagePath = file.path;
                                  },
                                ),
                                ImageCardWidget(
                                  imagePath: backIdImagePath,
                                  labelText: LocaleKeys.profileVerificationBackIdCard.tr(),
                                  width: 300,
                                  height: 175,
                                  isEditable: true,
                                  isRequired: true,
                                  showError: showErrorIdBack,
                                  errorText: LocaleKeys.profileVerificationBackIdRequired.tr(),
                                  onImagePicked: (file) {
                                    backIdImage = file;
                                    backIdImagePath = file.path;
                                  },
                                ),
                              ],
                            ),
                  
                            const SizedBox(height: 20),
                  
                            CustomTextFormField(
                              controller: arabicAddressController,
                              hintText: LocaleKeys.profileVerificationArabicAddress.tr(),
                              labelText: LocaleKeys.profileVerificationArabicAddress.tr(),
                              type: CustomTextFormFieldType.name,
                            ),
                  
                            CustomTextFormField(
                              controller: arabicFullNameController,
                              hintText: LocaleKeys.profileVerificationArabicFullName.tr(),
                              labelText: LocaleKeys.profileVerificationArabicFullName.tr(),
                              type: CustomTextFormFieldType.name,
                            ),
                  
                            CustomTextFormField(
                              controller: nationalIDNumberController,
                              hintText: LocaleKeys.profileVerificationNationalId.tr(),
                              labelText: LocaleKeys.profileVerificationNationalId.tr(),
                              prefixIcon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys.profileVerificationNationalIdRequired.tr();
                                }
                                if (value.length != 14) {
                                  return LocaleKeys.profileVerificationNationalIdLength.tr();
                                }
                                return null;
                              },
                              type: CustomTextFormFieldType.number,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                if (state is SettingsLoading) Center(child: buildLoading()),
              ],
            );
          },
        ),
      ),
    );
  }
}
