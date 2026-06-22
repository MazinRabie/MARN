import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:MARN/core/widgets/build_footer.dart';
import 'package:MARN/core/widgets/build_header.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_icon.dart';
import 'package:MARN/features/static_screens/data/static_data/static_data_provider.dart';
import 'package:MARN/features/static_screens/presentation/widgets/expansion_list_of_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final termsOfUseList = StaticDataProvider.getTermsOfUse(context);
    final lastUpdated = StaticDataProvider.getTermsOfUseLastUpdated(context);

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAppBar(context),
              BuildHeader(
                title: LocaleKeys.staticScreensTitlesTermsOfUse.tr(),
                subtitle: LocaleKeys.staticScreensSubtitlesTermsOfUse.tr(),
                date: LocaleKeys.staticScreensLastUpdated.tr(args: [lastUpdated]),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ExpansionListItemWidget(list: termsOfUseList),
                    const SizedBox(height: 16),
                    CustomGeneralContainer(
                      child: Column(
                        children: [
                          const CustomIcon(iconData: Icons.question_mark_rounded),
                          BuildHeader(
                            title: LocaleKeys.staticScreensTitlesQuestionsAboutTerms.tr(),
                            subtitle:
                                LocaleKeys.staticScreensSubtitlesQuestionsAboutTerms.tr(),
                          ),
                          const SizedBox(height: 20),
                          CustomGeneralButton(
                            text: LocaleKeys.staticScreensButtonsContactSupport.tr(),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const BuildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
