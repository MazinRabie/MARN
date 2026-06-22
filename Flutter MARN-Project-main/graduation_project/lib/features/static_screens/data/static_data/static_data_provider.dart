import 'package:MARN/features/static_screens/data/models/about_marn_model.dart';
import 'package:MARN/features/static_screens/data/models/expansion_model.dart';
import 'package:MARN/features/static_screens/data/models/how_it_works_model.dart';
import 'package:MARN/features/static_screens/data/static_data/about_marn_data_en.dart'
    as about_en;
import 'package:MARN/features/static_screens/data/static_data/about_marn_data_ar.dart'
    as about_ar;
import 'package:MARN/features/static_screens/data/static_data/faq_data_en.dart'
    as faq_en;
import 'package:MARN/features/static_screens/data/static_data/faq_data_ar.dart'
    as faq_ar;
import 'package:MARN/features/static_screens/data/static_data/how_it_works_data_en.dart'
    as how_en;
import 'package:MARN/features/static_screens/data/static_data/how_it_works_data_ar.dart'
    as how_ar;
import 'package:MARN/features/static_screens/data/static_data/privacy_policy_data_en.dart'
    as pp_en;
import 'package:MARN/features/static_screens/data/static_data/privacy_policy_data_ar.dart'
    as pp_ar;
import 'package:MARN/features/static_screens/data/static_data/term_of_use_data_en.dart'
    as tou_en;
import 'package:MARN/features/static_screens/data/static_data/term_of_use_data_ar.dart'
    as tou_ar;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StaticDataProvider {
  static bool isArabic(BuildContext context) =>
      context.locale.languageCode == 'ar';

  static List<ExpansionModel> getGeneralOverview(BuildContext context) {
    return isArabic(context)
        ? faq_ar.generalOverviewAr
        : faq_en.generalOverviewEn;
  }

  static List<ExpansionModel> getAccountAndRegistration(BuildContext context) {
    return isArabic(context)
        ? faq_ar.accountAndRegistrationAr
        : faq_en.accountAndRegistrationEn;
  }

  static List<ExpansionModel> getIdentityVerification(BuildContext context) {
    return isArabic(context)
        ? faq_ar.identityVerificationAr
        : faq_en.identityVerificationEn;
  }

  static List<ExpansionModel> getSearchingForProperties(BuildContext context) {
    return isArabic(context)
        ? faq_ar.searchingForPropertiesAr
        : faq_en.searchingForPropertiesEn;
  }

  static List<ExpansionModel> getListingAPropertyOwners(BuildContext context) {
    return isArabic(context)
        ? faq_ar.listingAPropertyOwnersAr
        : faq_en.listingAPropertyOwnersEn;
  }

  static List<ExpansionModel> getBookingAndRequests(BuildContext context) {
    return isArabic(context)
        ? faq_ar.bookingAndRequestsAr
        : faq_en.bookingAndRequestsEn;
  }

  static List<ExpansionModel> getRoommateMatching(BuildContext context) {
    return isArabic(context)
        ? faq_ar.roommateMatchingAr
        : faq_en.roommateMatchingEn;
  }

  static List<ExpansionModel> getAiRecommendationsAndChatbot(
    BuildContext context,
  ) {
    return isArabic(context)
        ? faq_ar.aiRecommendationsAndChatbotAr
        : faq_en.aiRecommendationsAndChatbotEn;
  }

  static List<ExpansionModel> getDigitalContractsAndBlockchain(
    BuildContext context,
  ) {
    return isArabic(context)
        ? faq_ar.digitalContractsAndBlockchainAr
        : faq_en.digitalContractsAndBlockchainEn;
  }

  static List<ExpansionModel> getPayments(BuildContext context) {
    return isArabic(context) ? faq_ar.paymentsAr : faq_en.paymentsEn;
  }

  static List<ExpansionModel> getCommunicationAndNotifications(
    BuildContext context,
  ) {
    return isArabic(context)
        ? faq_ar.communicationAndNotificationsAr
        : faq_en.communicationAndNotificationsEn;
  }

  static List<ExpansionModel> getRatingsReviewsAndReporting(
    BuildContext context,
  ) {
    return isArabic(context)
        ? faq_ar.ratingsReviewsAndReportingAr
        : faq_en.ratingsReviewsAndReportingEn;
  }

  static List<ExpansionModel> getAdminAndPlatformGovernance(
    BuildContext context,
  ) {
    return isArabic(context)
        ? faq_ar.adminAndPlatformGovernanceAr
        : faq_en.adminAndPlatformGovernanceEn;
  }

  static List<ExpansionModel> getTechnicalStackAndArchitecture(
    BuildContext context,
  ) {
    return isArabic(context)
        ? faq_ar.technicalStackAndArchitectureAr
        : faq_en.technicalStackAndArchitectureEn;
  }

  static List<ExpansionModel> getFutureImprovements(BuildContext context) {
    return isArabic(context)
        ? faq_ar.futureImprovementsAr
        : faq_en.futureImprovementsEn;
  }

  static List<ExpansionModel> getPrivacyPolicy(BuildContext context) {
    return isArabic(context)
        ? pp_ar.privacyPolicyDataAr
        : pp_en.privacyPolicyDataEn;
  }

  static List<ExpansionModel> getTermsOfUse(BuildContext context) {
    return isArabic(context)
        ? tou_ar.termsOfUseDataAr
        : tou_en.termsOfUseDataEn;
  }

  static String getPrivacyPolicyLastUpdated(BuildContext context) {
    return isArabic(context)
        ? pp_ar.privacyPolicyLastUpdatedAr
        : pp_en.privacyPolicyLastUpdatedEn;
  }

  static String getTermsOfUseLastUpdated(BuildContext context) {
    return isArabic(context)
        ? tou_ar.termsOfUseLastUpdatedAr
        : tou_en.termsOfUseLastUpdatedEn;
  }

  static AboutMarnData getAboutMarn(BuildContext context) {
    return isArabic(context)
        ? about_ar.aboutMarnDataAr
        : about_en.aboutMarnDataEn;
  }

  static HowItWorksData getHowItWorks(BuildContext context) {
    return isArabic(context)
        ? how_ar.howItWorksDataAr
        : how_en.howItWorksDataEn;
  }
}
