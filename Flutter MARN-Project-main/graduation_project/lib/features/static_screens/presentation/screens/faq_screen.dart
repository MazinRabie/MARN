import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/build_appbar.dart';
import 'package:MARN/core/widgets/build_footer.dart';
import 'package:MARN/core/widgets/build_header.dart';
import 'package:MARN/core/widgets/custom_general_button.dart';
import 'package:MARN/core/widgets/custom_general_container.dart';
import 'package:MARN/core/widgets/custom_icon.dart';
import 'package:MARN/core/widgets/search_widget.dart';
import 'package:MARN/features/static_screens/data/static_data/static_data_provider.dart';
import 'package:MARN/features/static_screens/presentation/manager/faq_search_controller.dart';
import 'package:MARN/features/static_screens/presentation/widgets/expansion_list_of_item_widget.dart';
import 'package:MARN/features/static_screens/presentation/widgets/head_line_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});
  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final Map<String, GlobalKey> itemKeys = {};
  void searchFAQ(String value) {
    FAQSearchController.searchFAQ(
      query: value.trim(),
      itemKeys: itemKeys,
      allItems: [
        ...StaticDataProvider.getGeneralOverview(context),
        ...StaticDataProvider.getAccountAndRegistration(context),
        ...StaticDataProvider.getIdentityVerification(context),
        ...StaticDataProvider.getSearchingForProperties(context),
        ...StaticDataProvider.getListingAPropertyOwners(context),
        ...StaticDataProvider.getBookingAndRequests(context),
        ...StaticDataProvider.getRoommateMatching(context),
        ...StaticDataProvider.getAiRecommendationsAndChatbot(context),
        ...StaticDataProvider.getDigitalContractsAndBlockchain(context),
        ...StaticDataProvider.getPayments(context),
        ...StaticDataProvider.getCommunicationAndNotifications(context),
        ...StaticDataProvider.getRatingsReviewsAndReporting(context),
        ...StaticDataProvider.getAdminAndPlatformGovernance(context),
        ...StaticDataProvider.getTechnicalStackAndArchitecture(context),
        ...StaticDataProvider.getFutureImprovements(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final generalOverview = StaticDataProvider.getGeneralOverview(context);
    final accountAndRegistration = StaticDataProvider.getAccountAndRegistration(
      context,
    );
    final identityVerification = StaticDataProvider.getIdentityVerification(
      context,
    );
    final searchingForProperties = StaticDataProvider.getSearchingForProperties(
      context,
    );
    final listingAPropertyOwners = StaticDataProvider.getListingAPropertyOwners(
      context,
    );
    final bookingAndRequests = StaticDataProvider.getBookingAndRequests(
      context,
    );
    final roommateMatching = StaticDataProvider.getRoommateMatching(context);
    final aiRecommendationsAndChatbot =
        StaticDataProvider.getAiRecommendationsAndChatbot(context);
    final digitalContractsAndBlockchain =
        StaticDataProvider.getDigitalContractsAndBlockchain(context);
    final payments = StaticDataProvider.getPayments(context);
    final communicationAndNotifications =
        StaticDataProvider.getCommunicationAndNotifications(context);
    final ratingsReviewsAndReporting =
        StaticDataProvider.getRatingsReviewsAndReporting(context);
    final adminAndPlatformGovernance =
        StaticDataProvider.getAdminAndPlatformGovernance(context);
    final technicalStackAndArchitecture =
        StaticDataProvider.getTechnicalStackAndArchitecture(context);
    final futureImprovements = StaticDataProvider.getFutureImprovements(
      context,
    );

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              buildAppBar(context),
              BuildHeader(
                title: LocaleKeys.staticScreensTitlesFaq.tr(),
                subtitle: LocaleKeys.staticScreensSubtitlesFaq.tr(),
              ),
              SearchWidget(
                hintText: LocaleKeys.staticScreensPlaceholdersSearchFaq.tr(),
                onPressed: searchFAQ,
                controller: searchController,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HeadLineWidget(
                      title: LocaleKeys.staticScreensTitlesFaqGeneralOverview
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: generalOverview,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys
                          .staticScreensTitlesFaqAccountAndRegistration
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: accountAndRegistration,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys
                          .staticScreensTitlesFaqIdentityVerification
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: identityVerification,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys
                          .staticScreensTitlesFaqSearchingForProperties
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: searchingForProperties,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys
                          .staticScreensTitlesFaqListingAPropertyOwners
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: listingAPropertyOwners,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys.staticScreensTitlesFaqBookingAndRequests
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: bookingAndRequests,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys.staticScreensTitlesFaqRoommateMatching
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: roommateMatching,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys
                          .staticScreensTitlesFaqAiRecommendationsAndChatbot
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: aiRecommendationsAndChatbot,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys
                          .staticScreensTitlesFaqDigitalContractsAndBlockchain
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: digitalContractsAndBlockchain,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys.staticScreensTitlesFaqPayments.tr(),
                    ),
                    ExpansionListItemWidget(itemKeys: itemKeys, list: payments),
                    HeadLineWidget(
                      title: LocaleKeys
                          .staticScreensTitlesFaqCommunicationAndNotifications
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: communicationAndNotifications,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys
                          .staticScreensTitlesFaqRatingsReviewsAndReporting
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: ratingsReviewsAndReporting,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys
                          .staticScreensTitlesFaqAdminAndPlatformGovernance
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: adminAndPlatformGovernance,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys
                          .staticScreensTitlesFaqTechnicalStackAndArchitecture
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: technicalStackAndArchitecture,
                    ),
                    HeadLineWidget(
                      title: LocaleKeys.staticScreensTitlesFaqFutureImprovements
                          .tr(),
                    ),
                    ExpansionListItemWidget(
                      itemKeys: itemKeys,
                      list: futureImprovements,
                    ),
                    const SizedBox(height: 16),
                    CustomGeneralContainer(
                      child: Column(
                        children: [
                          const CustomIcon(
                            iconData: Icons.question_mark_rounded,
                          ),
                          BuildHeader(
                            title: LocaleKeys
                                .staticScreensTitlesStillHaveQuestions
                                .tr(),
                            subtitle: LocaleKeys
                                .staticScreensSubtitlesStillHaveQuestions
                                .tr(),
                          ),
                          const SizedBox(height: 20),
                          CustomGeneralButton(
                            text: LocaleKeys.staticScreensButtonsContactSupport
                                .tr(),
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
