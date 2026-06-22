import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class BuildFooter extends StatelessWidget {
  const BuildFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// COPYRIGHT
          Text(
            LocaleKeys.commonCopyright.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.metadata,
          ),

          const SizedBox(height: 12),

          /// LINKS
          Wrap(
            alignment: WrapAlignment.center,
            spacing: width < 400 ? 12 : 24,
            children: [
              _FooterLink(
                title: LocaleKeys.staticAboutMarn.tr(),
                route: AppRoutes.aboutMarnScreen,
              ),
              _FooterLink(
                title: LocaleKeys.staticHowItWorks.tr(),
                route: AppRoutes.howItWorksScreen,
              ),
              _FooterLink(
                title: LocaleKeys.staticFaq.tr(),
                route: AppRoutes.faqScreen,
              ),
              _FooterLink(
                title: LocaleKeys.staticPrivacyPolicy.tr(),
                route: AppRoutes.privacyPolicyScreen,
              ),
              _FooterLink(
                title: LocaleKeys.staticTermsOfUse.tr(),
                route: AppRoutes.termsOfUseScreen,
              ),
              _FooterLink(
                title: LocaleKeys.staticContactUs.tr(),
                route: AppRoutes.contactScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String title;
  final String route;

  const _FooterLink({required this.title, required this.route});
  static const List<String> staticRoutes = [
    AppRoutes.aboutMarnScreen,
    AppRoutes.howItWorksScreen,
    AppRoutes.faqScreen,
    AppRoutes.privacyPolicyScreen,
    AppRoutes.termsOfUseScreen,
    AppRoutes.contactScreen,
  ];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (staticRoutes.contains(ModalRoute.of(context)?.settings.name)) {
          // Navigator.pushReplacementNamed(context, route);
          context.pushReplacement(route);
        } else {
          // Navigator.pushNamed(context, route);
          context.push(route);
        }
      },
      child: Text(title, style: AppTextStyles.metadata),
    );
  }
}
