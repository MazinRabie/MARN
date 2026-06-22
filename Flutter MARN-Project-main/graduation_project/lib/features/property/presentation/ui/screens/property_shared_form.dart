import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/app_bar_widget.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/my_show_dialog.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/features/property/domain/entities/property_edit_entity.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/property/presentation/ui/models/property_form_state.dart';
import 'package:MARN/features/property/presentation/ui/widgets/steps/property_amenities.dart';
import 'package:MARN/features/property/presentation/ui/widgets/steps/property_rules_step.dart';
import 'package:MARN/features/property/presentation/ui/widgets/steps/property_details.dart';
import 'package:MARN/features/property/presentation/ui/widgets/steps/property_legal_documents.dart';
import 'package:MARN/features/property/presentation/ui/widgets/steps/property_photos.dart';
import 'package:MARN/features/property/presentation/ui/widgets/steps/property_pricing.dart';
import 'package:MARN/features/property/presentation/ui/widgets/steps/step_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PropertySharedForm extends StatefulWidget {
  const PropertySharedForm({
    super.key,
    this.isEdit = false,
    this.index,
    this.propertyToEdit,
  });
  final bool isEdit;
  final int? index;
  final PropertyEditEntity? propertyToEdit;

  @override
  State<PropertySharedForm> createState() => _PropertySharedFormState();
}

class _PropertySharedFormState extends State<PropertySharedForm> {
  int currentStep = 0;

  final PageController _controller = PageController();

  final formKeyDetails = GlobalKey<FormState>();
  final formKeyAmenities = GlobalKey<FormState>();
  final formKeyPhotos = GlobalKey<FormState>();
  final formKeyPricing = GlobalKey<FormState>();
  final formKeyAvailability = GlobalKey<FormState>();
  final formKeyLegalDocuments = GlobalKey<FormState>();

  late PropertyFormState formState;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.propertyToEdit != null) {
      formState = PropertyFormState.fromEditEntity(widget.propertyToEdit!);
    } else {
      formState = PropertyFormState.empty();
    }
  }

  // ----------------------------
  // VALIDATION
  // ----------------------------
  bool validateCurrentStep() {
    switch (currentStep) {
      case 0:
        return formKeyDetails.currentState?.validate() ?? false;
      case 1:
        return formKeyAmenities.currentState?.validate() ?? false;
      case 2:
        return formKeyPhotos.currentState?.validate() ?? false;
      case 3:
        return formKeyPricing.currentState?.validate() ?? false;
      case 4:
        return formKeyAvailability.currentState?.validate() ?? false;
      case 5:
        return formKeyLegalDocuments.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  // ----------------------------
  // NAVIGATION
  // ----------------------------
  Future<void> nextStep() async {
    if (!validateCurrentStep()) return;

    if (currentStep < 5) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      await submitProperty();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  // ----------------------------
  // SUBMIT
  // ----------------------------
  Future<void> submitProperty() async {
    final bloc = context.read<PropertyCubit>();

    if (formState.isEdit) {
      bloc.editProperty(property: formState.toEditEntity());
    } else {
      await bloc.becomeOwner();
      bloc.addProperty(property: formState.toAddEntity());
    }
  }

  // ----------------------------
  // UI
  // ----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: appBarWidget(
        context,
        actions: [
          if (widget.isEdit && widget.propertyToEdit != null) ...{
            IconButton(
              onPressed: () => myShowDialog(
                context,
                title: LocaleKeys.propertyDialogsToggleActiveTitle.tr(),
                content: LocaleKeys.propertyDialogsToggleActiveContent.tr(),
                confirmText: widget.propertyToEdit!.isActive!
                    ? LocaleKeys.propertyDialogsDeactivate.tr()
                    : LocaleKeys.propertyDialogsActivate.tr(),
                onConfirm: () {
                  context.read<PropertyCubit>().togglePropertyActiveStatus(
                    propertyId: widget.propertyToEdit!.id,
                  );
                  setState(() {
                    widget.propertyToEdit!.isActive =
                        !widget.propertyToEdit!.isActive!;
                  });
                },
              ),
              icon: widget.propertyToEdit!.isActive!
                  ? const Icon(Icons.toggle_on, color: AppColors.success)
                  : const Icon(Icons.toggle_off, color: AppColors.warning),
            ),
            IconButton(
              onPressed: () => myShowDialog(
                context,
                title: LocaleKeys.propertyDialogsDeleteTitle.tr(),
                content: LocaleKeys.propertyDialogsDeleteContent.tr(),
                confirmText: LocaleKeys.propertyButtonsDelete.tr(),
                onConfirm: () {
                  context.read<PropertyCubit>().deleteProperty(
                    propertyId: widget.propertyToEdit!.id,
                    index: widget.index!,
                  );
                },
              ),
              icon: const Icon(Icons.delete, color: AppColors.error),
            ),
          },
        ],
      ),
      body: Center(
        child: CustomGeneralContainer(
          child: Column(
            children: [
              StepTitle(stepNumber: currentStep),
        
              const SizedBox(height: 10),
        
              Expanded(
                child: PageView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => currentStep = index);
                  },
                  children: [
                    PropertyDetailsStep(
                      formKey: formKeyDetails,
                      property: formState,
                    ),
                    PropertyAmenitiesStep(
                      formKey: formKeyAmenities,
                      property: formState,
                    ),
                    PropertyPhotosStep(
                      formKey: formKeyPhotos,
                      property: formState,
                    ),
                    PropertyPricingStep(
                      formKey: formKeyPricing,
                      property: formState,
                    ),
                    PropertyRulesStep(
                      formKey: formKeyAvailability,
                      property: formState,
                    ),
                    PropertyLegalDocumentsStep(
                      formKey: formKeyLegalDocuments,
                      property: formState,
                    ),
                  ],
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (currentStep > 0)
                      Expanded(
                        child: CustomGeneralButton(
                          text: LocaleKeys.propertyButtonsBack.tr(),
                          onPressed: previousStep,
                        ),
                      ),
                    if (currentStep > 0) const SizedBox(width: 10),
                    Expanded(
                      child: CustomGeneralButton(
                        text: currentStep == 5
                            ? LocaleKeys.propertyButtonsSubmit.tr()
                            : LocaleKeys.propertyButtonsNext.tr(),
                        onPressed: nextStep,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
