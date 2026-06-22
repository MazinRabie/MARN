import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/widgets/enum_select_field.dart.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/core/widgets/date_picker_field.dart';
import 'package:MARN/core/widgets/profile_image_widget.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_setting_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController phoneController;
  late final TextEditingController bioController;
  File? profileImage;
  String? profileImagePath;
  EnumItem selectedCountry = EnumItem.empty;
  EnumItem selectedLanguage = EnumItem.empty;
  EnumItem selectedGender = EnumItem.empty;
  DateTime? dateOfBirth;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    bioController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileSettingCubit>().getProfileSettingsInfo();
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    bioController.dispose();
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<ProfileSettingCubit>().editBasicProfile(
                  firstName: firstNameController.text.trim(),
                  lastName: lastNameController.text.trim(),
                  phoneNumber: phoneController.text.trim(),
                  dateOfBirth: dateOfBirth,
                  bio: bioController.text.trim(),
                  profileImage: profileImage,
                  country: selectedCountry,
                  language: selectedLanguage,
                  gender: selectedGender,
                );
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
              setState(() {
                firstNameController.text = data.firstName;
                lastNameController.text = data.lastName;
                phoneController.text = data.phoneNumber ?? "";
                dateOfBirth = DateTime.tryParse(data.dateOfBirth ?? "");
                profileImagePath = data.profileImage;
                bioController.text = data.bio ?? "";
                selectedGender = data.gender;
                selectedCountry = data.country;
                selectedLanguage = data.language;
              });
            }
            if (state is SettingsError) {
              buildSnackBar(
                context,
                message: state.errorMessage,
                isError: true,
              );
            }
            if (state is EditBasicProfileSuccess) {
              buildSnackBar(context, message: state.message, isError: false);
              context.read<ProfileCubit>().getMyProfile();
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
                            ProfileImageWidget(
                              imagePath: profileImagePath,
                              radius: 80,
                              isEditable: true,
                              onImagePicked: (file) {
                                profileImage = file;
                                profileImagePath = file.path;
                              },
                            ),

                            const SizedBox(height: 20),

                            CustomTextFormField(
                              controller: firstNameController,
                              hintText: LocaleKeys.profilePlaceholdersFirstName
                                  .tr(),
                              labelText: LocaleKeys.profilePlaceholdersFirstName
                                  .tr(),
                              type: CustomTextFormFieldType.name,
                            ),

                            CustomTextFormField(
                              controller: lastNameController,
                              hintText: LocaleKeys.profilePlaceholdersLastName
                                  .tr(),
                              labelText: LocaleKeys.profilePlaceholdersLastName
                                  .tr(),
                              type: CustomTextFormFieldType.name,
                            ),

                            CustomTextFormField(
                              controller: phoneController,
                              hintText: LocaleKeys.profilePlaceholdersPhone
                                  .tr(),
                              labelText: LocaleKeys.profilePlaceholdersPhone
                                  .tr(),
                              type: CustomTextFormFieldType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys
                                      .profileValidationPhoneRequired
                                      .tr();
                                }
                                return null;
                              },
                            ),

                            EnumSelectField(
                              labelText: LocaleKeys.profilePlaceholdersGender
                                  .tr(),
                              enumType: EnumType.gender,
                              initialValue: selectedGender,
                              onChanged: (value) {
                                if (value != null) selectedGender = value;
                              },
                            ),

                            FormField<DateTime>(
                              initialValue: dateOfBirth,
                              validator: (value) {
                                if (value == null) {
                                  return LocaleKeys.profileValidationDobRequired
                                      .tr();
                                }
                                return null;
                              },
                              builder: (FormFieldState<DateTime> state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DatePickerField(
                                      hintText: LocaleKeys.profileInfoDob.tr(),
                                      labelText: LocaleKeys.profileInfoDob.tr(),
                                      initialValue: dateOfBirth,
                                      onDateSelected: (date) {
                                        state.didChange(date);
                                        dateOfBirth = date;
                                      },
                                    ),
                                    if (state.hasError)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                        ),
                                        child: Text(
                                          state.errorText!,
                                          style: const TextStyle(
                                            color: AppColors.error,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),

                            CustomTextFormField(
                              controller: bioController,
                              hintText: LocaleKeys.profilePlaceholdersBio.tr(),
                              labelText: LocaleKeys.profilePlaceholdersBio.tr(),
                              type: CustomTextFormFieldType.text,
                              maxLines: 4,
                            ),

                            const SizedBox(height: 10),

                            EnumSelectField(
                              labelText: LocaleKeys.profilePlaceholdersLanguage
                                  .tr(),
                              enumType: EnumType.languages,
                              initialValue: selectedLanguage,
                              onChanged: (value) {
                                if (value != null) selectedLanguage = value;
                              },
                            ),

                            const SizedBox(height: 10),

                            EnumSelectField(
                              labelText: LocaleKeys.profilePlaceholdersCountry
                                  .tr(),
                              enumType: EnumType.countries,
                              initialValue: selectedCountry,
                              onChanged: (value) {
                                if (value != null) selectedCountry = value;
                              },
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
