import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:MARN/core/widgets/build_footer.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Error404Screen extends StatelessWidget {
  const Error404Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAppBar(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              CustomGeneralContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("404", style: AppTextStyles.headlineLarge),
                    Text(
                      LocaleKeys.staticScreensTitlesPageNotFound.tr(),
                      style: AppTextStyles.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.staticScreensSubtitlesPageNotFound.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    CustomGeneralButton(
                      text: LocaleKeys.staticScreensButtonsBackToHome.tr(),
                      onPressed: () {
                        context.go(AppRoutes.splashScreen);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.20),
              const BuildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
