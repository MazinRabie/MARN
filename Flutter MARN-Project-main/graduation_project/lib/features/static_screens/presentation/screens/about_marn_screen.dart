import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:MARN/core/utilities/app_images.dart';
import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:MARN/core/widgets/build_footer.dart';
import 'package:MARN/core/widgets/build_header.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/features/static_screens/data/static_data/static_data_provider.dart';
import 'package:MARN/features/static_screens/presentation/widgets/build_static_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AboutMarnScreen extends StatelessWidget {
  const AboutMarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final aboutData = StaticDataProvider.getAboutMarn(context);

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAppBar(context),
              BuildHeader(
                title: LocaleKeys.staticScreensTitlesAboutMarn.tr(),
                subtitle: LocaleKeys.staticScreensSubtitlesAboutMarn.tr(),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  Assets.imagesAboutMarn,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              CustomGeneralContainer(
                child: Column(
                  children: [
                    Text(
                      LocaleKeys.staticScreensTitlesOurMission.tr(),
                      style: AppTextStyles.headlineLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      aboutData.missionText,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.staticScreensTitlesOurValues.tr(),
                style: AppTextStyles.headlineLarge,
              ),
              Text(
                LocaleKeys.staticScreensSubtitlesOurValues.tr(),
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: aboutData.values
                    .map((v) => BuildStaticCard(
                          title: v.title,
                          description: v.description,
                          icon: v.icon,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.staticScreensTitlesMeetOurTeam.tr(),
                style: AppTextStyles.headlineLarge,
              ),
              Text(
                LocaleKeys.staticScreensSubtitlesMeetOurTeam.tr(),
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: aboutData.team
                    .map((t) => BuildStaticCard(
                          title: t.title,
                          description: t.description,
                          imagePath: t.imagePath,
                          height: t.height,
                        ))
                    .toList(),
              ),
              const BuildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
