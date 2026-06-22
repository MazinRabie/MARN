import 'dart:async';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/services/service_locator.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_gradient.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/features/auth/data/data_sources/auth_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:MARN/core/enums/cubit/enum_cubit.dart';
import 'package:MARN/core/enums/data/enum_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeApp());
  }

  Future<void> _initializeApp() async {
    // 1. Check if enums are cached locally
    final locale = EasyLocalization.of(context)?.locale ?? const Locale('en');
    final hasCache = await getIt<EnumRepository>().hasCachedData(locale.languageCode);

    // If enums are already cached, use a short 3s timeout.
    // If not (first run after clean), give the sleeping server 20 seconds to wake up (cold start) and download/cache them!
    final timeoutDuration = hasCache ? const Duration(seconds: 3) : const Duration(seconds: 20);

    try {
      await context
          .read<EnumCubit>()
          .loadEnums(language: locale.languageCode, forceRefresh: false)
          .timeout(timeoutDuration);
    } catch (e) {
      debugPrint('Error loading enums in Splash Screen: $e');
    }

    // 2. Check session validity while ensuring splash is visible for at least 1 second
    final startTime = DateTime.now();
    final isSessionValid = await getIt<AuthService>().checkSessionValidity();
    final elapsed = DateTime.now().difference(startTime);

    final remainingDelay = const Duration(seconds: 1) - elapsed;
    if (remainingDelay > Duration.zero) {
      await Future.delayed(remainingDelay);
    }

    if (mounted) {
      if (isSessionValid) {
        context.go(AppRoutes.mainLayoutScreen);
      } else {
        context.go(AppRoutes.loginScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo "M"
            Container(
              padding: EdgeInsets.all(size.width * 0.02),
              decoration: BoxDecoration(
                gradient: AppGradient.logoGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withAlpha(64), // 0.25 alpha
                    blurRadius: 50,
                    offset: const Offset(0, 25),
                    spreadRadius: -12,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/logo_outline.png",
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
              ),
            ),

            SizedBox(height: size.height * 0.05),

            // Text "MARN"
            Text('MARN', style: AppTextStyles.logoText),

            SizedBox(height: size.height * 0.02),

            // Subtitle
            Text(
              LocaleKeys.findYourPerfectHome.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.logoSubtitle,
            ),

            SizedBox(height: size.height * 0.05),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(AppColors.primary),
                const SizedBox(width: 8),
                _buildDot(AppColors.primaryLight),
                const SizedBox(width: 8),
                _buildDot(AppColors.primarySoft),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
