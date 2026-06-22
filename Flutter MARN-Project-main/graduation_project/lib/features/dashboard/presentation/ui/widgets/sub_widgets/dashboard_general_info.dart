import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';

import 'package:flutter/material.dart';

class DashboardGeneralInfo extends StatelessWidget {
  final EnumItem? accountStatus;

  const DashboardGeneralInfo({super.key, required this.accountStatus});

  @override
  Widget build(BuildContext context) {
    if (accountStatus == null) return const SliverToBoxAdapter();

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      color: AppColors.shadow,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      accountStatus?.name.toLowerCase() == 'verified'
                          ? Icons.check
                          : Icons.warning,
                      color: accountStatus?.name.toLowerCase() == 'verified'
                          ? AppColors.success
                          : AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        LocaleKeys.dashboardStatusAccountStatus.tr(
                          namedArgs: {
                            'status': accountStatus!.displayName.isNotEmpty
                                ? accountStatus!.displayName
                                : accountStatus!.name
                          },
                        ),
                        style: AppTextStyles.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
