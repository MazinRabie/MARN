enum EnumType {
  gender("genders"),
  countries("countries"),
  languages("languages"),
  propertyTypes("propertyTypes"),
  amenityTypes("amenityTypes"),
  rentalUnits("rentalUnits"),
  propertyStatuses("propertyStatuses"),
  educationLevels("educationLevels"),
  fieldsOfStudy("fieldsOfStudy"),
  guestsFrequencies("guestsFrequencies"),
  sharingLevels("sharingLevels"),
  sleepSchedules("sleepSchedules"),
  workSchedules("workSchedules"),
  contractStatuses("contractStatuses"),
  paymentFrequencies("paymentFrequencies"),
  paymentStatuses("paymentStatuses"),
  paymentScheduleStatuses("paymentScheduleStatuses"),
  reportStatuses("reportStatuses"),
  reportableTypes("reportableTypes"),
  reportModerationActionTypes("reportModerationActionTypes"),
  accountStatuses("accountStatuses"),
  propertyAvailabilities("propertyAvailabilities"),
  notificationUserTypes("notificationUserTypes"),
  notificationTypes("notificationTypes"),
  notificationActionTypes("notificationActionTypes"),
  serviceResultTypes("serviceResultTypes"),
  userActivityTypes("userActivityTypes"),
  contractAnchoringStatuses("contractAnchoringStatuses"),
  roommateSearchStatuses("roommateSearchStatuses"),
  adminAnalyticsReportFormats("adminAnalyticsReportFormats"),
  adminAnalyticsReportScopes("adminAnalyticsReportScopes"),
  adminAnalyticsReportPeriods("adminAnalyticsReportPeriods"),
  cities("cities"),
  governorates("governorates"),
  propertySortByOptions("propertySortByOptions");

  final String value;
  const EnumType(this.value);

  static EnumType? fromString(String key) {
    try {
      return EnumType.values.firstWhere((e) => e.value == key);
    } catch (_) {
      return null;
    }
  }
}