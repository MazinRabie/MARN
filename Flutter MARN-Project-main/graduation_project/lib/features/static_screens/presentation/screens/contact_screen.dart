import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/services/service_locator.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:MARN/core/widgets/build_footer.dart';
import 'package:MARN/core/widgets/build_header.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_text_form_field.dart';
import 'package:MARN/features/static_screens/data/support_service.dart';
import 'package:MARN/features/static_screens/presentation/widgets/build_static_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final supportService = getIt<SupportService>();
      final response = await supportService.contactUs(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          buildSnackBar(
            context,
            message:
                response.data["message"] ??
                LocaleKeys.staticScreensMessagesMessageSentSuccess.tr(),
            isError: false,
          );
          // Clear form fields
          _fullNameController.clear();
          _emailController.clear();
          _phoneNumberController.clear();
          _subjectController.clear();
          _messageController.clear();
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      if (mounted) {
        buildSnackBar(
          context,
          message: LocaleKeys.staticScreensMessagesMessageSentError.tr(),
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAppBar(context),
              BuildHeader(
                title: LocaleKeys.staticScreensTitlesContactUs.tr(),
                subtitle: LocaleKeys.staticScreensSubtitlesContactUs.tr(),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  BuildStaticCard(
                    title: LocaleKeys.staticScreensLabelsPhone.tr(),
                    description: "01009961729",
                    icon: Icons.phone,
                  ),
                  BuildStaticCard(
                    title: LocaleKeys.staticScreensLabelsEmail.tr(),
                    description: "marn@gmail.com",
                    icon: Icons.email,
                  ),
                  BuildStaticCard(
                    title: LocaleKeys.staticScreensLabelsLocation.tr(),
                    description: LocaleKeys.staticScreensLabelsLocationValue.tr(),
                    icon: Icons.location_on,
                  ),
                  BuildStaticCard(
                    title: LocaleKeys.staticScreensLabelsWhatsapp.tr(),
                    description: "01009961729",
                    icon: Icons.message,
                  ),
                ],
              ),
              CustomGeneralContainer(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: _fullNameController,
                        labelText: LocaleKeys.staticScreensPlaceholdersFullName.tr(),
                        hintText: LocaleKeys.staticScreensPlaceholdersFullName.tr(),
                        type: CustomTextFormFieldType.name,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return LocaleKeys.staticScreensValidationFullNameRequired.tr();
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: _emailController,
                        labelText: LocaleKeys.staticScreensPlaceholdersEmailAddress.tr(),
                        hintText: LocaleKeys.staticScreensPlaceholdersEmailAddress.tr(),
                        type: CustomTextFormFieldType.email,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return LocaleKeys.staticScreensValidationEmailRequired.tr();
                          }
                          final emailRegExp = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegExp.hasMatch(value.trim())) {
                            return LocaleKeys.staticScreensValidationEmailInvalid.tr();
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: _phoneNumberController,
                        labelText: LocaleKeys.staticScreensPlaceholdersPhoneNumber.tr(),
                        hintText: "+201012345678",
                        type: CustomTextFormFieldType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return LocaleKeys.staticScreensValidationPhoneNumberRequired.tr();
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: _subjectController,
                        labelText: LocaleKeys.staticScreensPlaceholdersSubject.tr(),
                        hintText: LocaleKeys.staticScreensPlaceholdersSubject.tr(),
                        type: CustomTextFormFieldType.name,
                        prefixIcon: Icons.subject,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return LocaleKeys.staticScreensValidationSubjectRequired.tr();
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: _messageController,
                        labelText: LocaleKeys.staticScreensPlaceholdersMessage.tr(),
                        hintText: LocaleKeys.staticScreensPlaceholdersMessage.tr(),
                        type: CustomTextFormFieldType.name,
                        prefixIcon: Icons.message,
                        maxLines: 10,
                        minLines: 6,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return LocaleKeys.staticScreensValidationMessageRequired.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      CustomGeneralButton(
                        text: LocaleKeys.staticScreensButtonsSendMessage.tr(),
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _submitForm,
                      ),
                    ],
                  ),
                ),
              ),
              const BuildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
