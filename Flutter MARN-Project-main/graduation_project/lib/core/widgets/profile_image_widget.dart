import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/build_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileImageWidget extends StatefulWidget {
  final String? imagePath;
  final double radius;
  final bool isDeleted;
  final bool isEditable;
  final Function(File file)? onImagePicked;

  const ProfileImageWidget({
    super.key,
    required this.imagePath,
    this.radius = 25,
    this.isDeleted = false,
    this.isEditable = false,
    this.onImagePicked,
  });

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  File? _localImage;

  Future<void> _pickImage() async {
    if (!widget.isEditable) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      final file = File(picked.path);

      setState(() {
        _localImage = file;
      });

      widget.onImagePicked?.call(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageDialog(context),
      child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: AppColors.primarySoft,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ClipOval(child: _buildImage()),
            ),
            if (widget.isDeleted)
              ClipOval(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            if (widget.isEditable)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: widget.radius * 0.3,
                      color: Colors.white,
                    ),
                    onPressed: _pickImage,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (_localImage != null) {
      return Image.file(
        _localImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (widget.imagePath == null || widget.imagePath!.isEmpty) {
      return Icon(Icons.person, size: widget.radius, color: AppColors.primary);
    }
    return CachedNetworkImage(
      imageUrl: widget.imagePath!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => buildLoading(),
      errorWidget: (context, url, error) =>
          Icon(Icons.person, size: widget.radius, color: AppColors.primary),
    );
  }

  void _showImageDialog(BuildContext context) {
    if (widget.imagePath == null || widget.imagePath!.isEmpty) return;
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: InteractiveViewer(
            child: _localImage != null
                ? Image.file(_localImage!, fit: BoxFit.contain)
                : CachedNetworkImage(
                    imageUrl: widget.imagePath!,
                    fit: BoxFit.contain,
                  ),
          ),
        );
      },
    );
  }
}
