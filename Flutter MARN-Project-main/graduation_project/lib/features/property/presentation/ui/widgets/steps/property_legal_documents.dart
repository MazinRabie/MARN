import 'dart:io';

import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/widgets/image_card_widget.dart';
import 'package:MARN/features/property/presentation/ui/models/property_form_state.dart';
import 'package:flutter/material.dart';

class PropertyLegalDocumentsStep extends StatefulWidget {
  const PropertyLegalDocumentsStep({
    super.key,
    required this.formKey,
    required this.property,
  });
  final PropertyFormState property;
  final GlobalKey<FormState> formKey;

  @override
  State<PropertyLegalDocumentsStep> createState() =>
      _PropertyLegalDocumentsStepState();
}

class _PropertyLegalDocumentsStepState
    extends State<PropertyLegalDocumentsStep> {
  File? proofOfOwnership;

  @override
  void initState() {
    super.initState();
    proofOfOwnership = widget.property.newProofOfOwnership;
  }

  @override
  Widget build(BuildContext context) {
    widget.property.newProofOfOwnership = proofOfOwnership;
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormField<File>(
              initialValue: proofOfOwnership,
              validator: (value) {
                if (value == null &&
                    widget.property.existingProofOfOwnershipUrl == null) {
                  return LocaleKeys.propertyFormLegalProofRequired.tr();
                }
                return null;
              },
              builder: (state) {
                return ImageCardWidget(
                  imagePath:
                      proofOfOwnership?.path ??
                      widget.property.existingProofOfOwnershipUrl,
                  labelText: LocaleKeys.propertyFormLegalProofLabel.tr(),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.5,
                  isEditable: true,
                  isRequired: true,
                  showError: state.hasError,
                  errorText: state.errorText ?? "",
                  onImagePicked: (file) {
                    proofOfOwnership = file;
                    widget.property.newProofOfOwnership = file;
                    state.didChange(file);
                    setState(() {});
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
