import 'package:MARN/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BottomNavigationBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: LocaleKeys.mainLayoutNavDashboard.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: LocaleKeys.mainLayoutNavHome.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline_rounded),
            label: LocaleKeys.mainLayoutNavRoommate.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            label: LocaleKeys.mainLayoutNavChat.tr(),
          ),
        ],
      ),
    );
  }
}
