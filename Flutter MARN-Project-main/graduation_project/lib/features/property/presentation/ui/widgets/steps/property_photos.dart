import 'dart:io';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:MARN/core/widgets/image_card_widget.dart';
import 'package:MARN/features/property/presentation/ui/models/property_form_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PropertyPhotosStep extends StatefulWidget {
  const PropertyPhotosStep({
    super.key,
    required this.formKey,
    required this.property,
  });
  final PropertyFormState property;
  final GlobalKey<FormState> formKey;

  @override
  State<PropertyPhotosStep> createState() => _PropertyPhotosStepState();
}

class _PropertyPhotosStepState extends State<PropertyPhotosStep> {
  bool showErrorPrimaryImage = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final totalMediaCount =
        widget.property.existingMedia.length +
        widget.property.addedMediaFiles.length;
    double boxWidth = MediaQuery.of(context).size.width * 0.35;

    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormField<File>(
              initialValue: widget.property.newPrimaryImage,
              validator: (value) {
                if (value == null &&
                    widget.property.existingPrimaryImageUrl == null) {
                  return LocaleKeys.propertyFormPhotosPrimaryRequired.tr();
                }
                return null;
              },
              builder: (state) {
                return ImageCardWidget(
                  imagePath:
                      widget.property.newPrimaryImage?.path ??
                      widget.property.existingPrimaryImageUrl,
                  labelText: LocaleKeys.propertyFormPhotosPrimaryLabel.tr(),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.25,
                  isEditable: true,
                  isRequired: true,
                  showError: state.hasError,
                  errorText: state.errorText ?? "",
                  onImagePicked: (file) {
                    widget.property.newPrimaryImage = file;
                    state.didChange(file);
                    setState(() {});
                  },
                );
              },
            ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                // Render Existing Media
                ...widget.property.existingMedia.map((media) {
                  return ImageCardWidget(
                    key: ValueKey(media.id),
                    imagePath: media.path,
                    width: boxWidth,
                    height: boxWidth,
                    isDeleteButton: true,
                    onDelete: () {
                      setState(() {
                        widget.property.removedMediaIds.add(media.id);
                        widget.property.existingMedia.remove(media);
                      });
                    },
                  );
                }).toList(),

                // Render Added Media
                ...widget.property.addedMediaFiles.map((file) {
                  return ImageCardWidget(
                    key: ValueKey(file.path),
                    imagePath: file.path,
                    width: boxWidth,
                    height: boxWidth,
                    isDeleteButton: true,
                    onDelete: () {
                      setState(() {
                        widget.property.addedMediaFiles.remove(file);
                      });
                    },
                  );
                }).toList(),

                // Add new media button
                if (totalMediaCount < 8)
                  ImageCardWidget(
                    width: boxWidth,
                    height: boxWidth,
                    isAddButton: true,
                    onImagePicked: (file) {
                      if (widget.property.addedMediaFiles
                          .map((e) => e.path)
                          .contains(file.path)) {
                        buildSnackBar(
                          context,
                          message: LocaleKeys.propertyFormPhotosAlreadyAdded
                              .tr(),
                        );
                        return;
                      }
                      setState(() {
                        widget.property.addedMediaFiles.add(file);
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
