import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:MARN/core/widgets/build_footer.dart';
import 'package:MARN/core/widgets/build_header.dart';
import 'package:MARN/core/widgets/custom_divider.dart';
import 'package:MARN/features/static_screens/data/static_data/static_data_provider.dart';
import 'package:MARN/features/static_screens/presentation/widgets/build_static_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final howItWorksData = StaticDataProvider.getHowItWorks(context);

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAppBar(context),
              BuildHeader(
                title: LocaleKeys.staticScreensTitlesHowItWorks.tr(),
                subtitle: LocaleKeys.staticScreensSubtitlesHowItWorks.tr(),
              ),
              const SizedBox(height: 16),
              CustomDivider(text: LocaleKeys.staticScreensTitlesFaqForTenants.tr()),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: howItWorksData.forTenants
                    .map((item) => BuildStaticCard(
                          title: item.title,
                          description: item.description,
                          icon: item.icon,
                          height: item.height,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              CustomDivider(text: LocaleKeys.staticScreensTitlesFaqForPropertyOwners.tr()),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: howItWorksData.forOwners
                    .map((item) => BuildStaticCard(
                          title: item.title,
                          description: item.description,
                          icon: item.icon,
                          height: item.height,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              CustomDivider(text: LocaleKeys.staticScreensTitlesWhyChooseUs.tr()),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: howItWorksData.whyChooseUs
                    .map((item) => BuildStaticCard(
                          title: item.title,
                          description: item.description,
                          icon: item.icon,
                          height: item.height,
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
