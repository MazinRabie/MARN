import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:MARN/features/property/domain/entities/property_view_entity.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/url_to_filecached.dart';
import 'package:MARN/features/property/domain/entities/property_sub_entities.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

Future<void> shareProperty(
  BuildContext context,
  PropertyViewEntity property,
) async {
  File? cachedImage;
  String? primaryPath;
  if (property.media.isNotEmpty) {
    PropertyMediaItemEntity? primaryItem;
    for (final item in property.media) {
      if (item.isPrimary) {
        primaryItem = item;
        break;
      }
    }
    primaryItem ??= property.media.first;
    primaryPath = primaryItem.path;
  }

  if (primaryPath != null && primaryPath.isNotEmpty) {
    // Show premium loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.hexagonDots(
                color: AppColors.primary,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.propertySharePreparing.tr(),
                style: const TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      cachedImage = await urlToFileCached(primaryPath);
    } catch (e) {
      debugPrint("Failed to download image for share: $e");
    } finally {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  if (context.mounted) {
    _sharePropertyTextAndImage(context, property, imageThumbnail: cachedImage);
  }
}

void _sharePropertyTextAndImage(
  BuildContext context,
  PropertyViewEntity property, {
  File? imageThumbnail,
}) {
  final id = property.id;
  final title = property.title;
  final city = property.city.displayName;
  final governorate = property.governorate.displayName;
  final price = property.price.toString();
  final rentalUnit = property.rentalUnit.displayName;
  final bedrooms = property.bedrooms.toString();
  final beds = property.beds.toString();
  final bathrooms = property.bathrooms.toString();

  final subject = LocaleKeys.propertyShareSubject.tr();
  final text = LocaleKeys.propertyShareTextTemplate.tr(
    args: [
      title,
      city,
      governorate,
      price,
      rentalUnit,
      bedrooms,
      beds,
      bathrooms,
      id.toString(),
    ],
  );

  if (imageThumbnail != null) {
    Share.shareXFiles(
      [XFile(imageThumbnail.path)],
      text: text,
      subject: subject,
    );
  } else {
    Share.share(text, subject: subject);
  }
}
