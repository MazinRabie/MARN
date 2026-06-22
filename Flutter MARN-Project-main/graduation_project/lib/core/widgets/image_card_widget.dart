import 'dart:io';

import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class ImageCardWidget extends StatefulWidget {
  final String? imagePath;
  final double width;
  final double height;
  final String? labelText;
  final bool isEditable;
  final bool isAddButton;
  final bool isRequired;
  final bool isDeleteButton;
  final Function()? onDelete;
  final bool showError;
  final String? errorText;
  final BoxFit? fit;

  final Function(File file)? onImagePicked;

  const ImageCardWidget({
    super.key,
    this.imagePath,
    this.width = 220,
    this.height = 140,
    this.labelText,
    this.isEditable = false,
    this.isRequired = false,
    this.showError = false,
    this.isAddButton = false,
    this.isDeleteButton = false,
    this.onDelete,
    this.errorText,
    this.onImagePicked,
    this.fit,
  });

  @override
  State<ImageCardWidget> createState() => _ImageCardWidgetState();
}

class _ImageCardWidgetState extends State<ImageCardWidget> {
  File? _localImage;

  bool get _hasImage =>
      _localImage != null ||
      (widget.imagePath != null && widget.imagePath!.isNotEmpty);

  Future<void> _pickImage() async {
    if (!widget.isEditable && !widget.isAddButton) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (picked != null) {
      final file = File(picked.path);

      setState(() {
        _localImage = file;
      });

      widget.onImagePicked?.call(file);
    }
  }

  void _openFullImage() {
    final path = _localImage?.path ?? widget.imagePath;

    if (path == null || path.isEmpty) return;

    final isNetwork = path.startsWith('http') || path.startsWith('https');

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: InteractiveViewer(
            child: isNetwork
                ? CachedNetworkImage(imageUrl: path)
                : Image.file(File(path)),
          ),
        );
      },
    );
  }

  Widget _buildImage() {
    /// 1. Local image (picked)
    if (_localImage != null) {
      return Image.file(
        _localImage!,
        fit: widget.fit ?? BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    /// 2. No image
    if (widget.imagePath == null || widget.imagePath!.isEmpty) {
      return Container(
        color: AppColors.primarySoft,
        child: const Center(
          child: Icon(Icons.credit_card, size: 42, color: Colors.grey),
        ),
      );
    }

    /// 3. Detect network vs local path
    final path = widget.imagePath!;
    final isNetwork = path.startsWith('http') || path.startsWith('https');

    /// 4. Network image
    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: widget.fit ?? BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => buildLoading(),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.broken_image)),
      );
    }

    /// 5. Local file path
    return Image.file(
      File(path),
      fit: widget.fit ?? BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.isRequired && widget.showError && !_hasImage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelText != null
            ? Text(widget.labelText!, style: AppTextStyles.bodyLarge)
            : const SizedBox(),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _openFullImage,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasError ? Colors.red : Colors.grey.shade300,
                width: hasError ? 2 : 1,
              ),
            ),
            child:
                /// Add button
                widget.isAddButton
                ? GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.add,
                        size: 64,
                        color: Colors.black,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox.expand(child: _buildImage()),
                      ),

                      /// Edit button
                      if (widget.isEditable)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      /// Delete button
                      if (widget.isDeleteButton)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: GestureDetector(
                            onTap: widget.onDelete,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),

        /// Error message (زي TextFormField validation)
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 8),
            child: Text(
              widget.errorText ?? LocaleKeys.validationIdCardImageRequired.tr(),
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
