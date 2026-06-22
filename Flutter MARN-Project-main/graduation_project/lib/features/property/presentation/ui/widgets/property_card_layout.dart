import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/image_card_widget.dart';
import 'package:MARN/features/property/domain/entities/card/base_property_card.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/property/presentation/ui/widgets/love_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PropertyCardLayout extends StatefulWidget {
  final BasePropertyCard property;
  final Widget? statusChip;
  final List<Widget> extraInfoRow;
  final List<Widget> bottomInfoRow;
  final List<Widget> extraActions;

  const PropertyCardLayout({
    super.key,
    required this.property,
    this.statusChip,
    this.extraInfoRow = const [],
    this.bottomInfoRow = const [],
    this.extraActions = const [],
  });

  @override
  State<PropertyCardLayout> createState() => _PropertyCardLayoutState();
}

class _PropertyCardLayoutState extends State<PropertyCardLayout> {
  @override
  Widget build(BuildContext context) {
    return CustomGeneralContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ImageCardWidget(
                imagePath: widget.property.imagePath,
                width: double.infinity,
                height: 180,
              ),
              Positioned(
                top: 12,
                right: 12,
                child: LoveButton(
                  isLiked: widget.property.isSaved,
                  onPressed: () {
                    context.read<PropertyCubit>().toggleSaveProperty(
                      propertyId: widget.property.id,
                    );
                    setState(() {
                      widget.property.isSaved = !widget.property.isSaved;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.property.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium,
                ),
              ),
              if (widget.statusChip != null) ...[
                const SizedBox(width: 10),
                widget.statusChip!,
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "${widget.property.address} • ${widget.property.type.displayName}",
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 20,
            runSpacing: 12,
            children: [
              PropertyCardInfoItem(
                title: LocaleKeys.propertyDetailsRentLabel.tr(
                  namedArgs: {'unit': widget.property.rentalUnit.displayName},
                ),
                value: "${widget.property.price} EGP",
                isPrimary: true,
              ),
              ...widget.extraInfoRow,
              PropertyCardInfoItem(
                title: LocaleKeys.propertyDetailsRatingLabel.tr(),
                value:
                    "${widget.property.averageRating.toStringAsFixed(1)} (${widget.property.ratings})",
                icon: Icons.star_outline,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(spacing: 16, runSpacing: 8, children: widget.bottomInfoRow),
          const SizedBox(height: 14),
          Row(
            children: [
              ...widget.extraActions,
              Expanded(
                child: FilledButton(
                  onPressed: () async {
                    bool? liked = await context.push(
                      AppRoutes.viewPropertyDetailsScreen,
                      extra: ViewPropertyDetailsScreenArguments(
                        id: widget.property.id,
                      ),
                    );
                    if (liked != null) {
                      setState(() {
                        widget.property.isSaved = liked;
                      });
                    }
                  },
                  child: Text(LocaleKeys.propertyButtonsView.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PropertyCardInfoItem extends StatelessWidget {
  const PropertyCardInfoItem({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.isPrimary = false,
  });

  final String title;
  final String value;
  final IconData? icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isPrimary ? AppColors.primary : AppColors.darkGray,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
