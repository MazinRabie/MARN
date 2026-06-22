// https://marn-six.vercel.app
abstract class AppRoutes {
  // static screens
  static const aboutMarnScreen = "/about";
  static const contactScreen = "/contact";
  static const error404Screen = "/error404Screen";
  static const faqScreen = '/faq';
  static const howItWorksScreen = "/how-it-works";
  static const privacyPolicyScreen = "/privacy";
  static const termsOfUseScreen = "/terms";

  // auth screens
  static const splashScreen = "/splash";
  static const resetPasswordScreen = "/reset-password";
  static const confirmEmailScreen = "/confirm-email";
  static const signUpScreen = "/signup";
  static const loginScreen = "/login";
  static const forgotPasswordScreen = "/forgot-password";
  static const twoFactorAuthScreen = "/otp-verification";

  // main screens
  static const mainLayoutScreen = "/";

  // setting screens
  static const settingScreen = "/profile-settings";

  // chat screens
  static const listChatsScreen = "/messages";
  static const chatScreen = "/messages/rental-request/:id";

  // profile screens
  static const profileScreen = "/user/:id";
  static const editProfileScreen = "/profile-settings/editProfile";
  static const changePasswordScreen = "/profile-settings/changePassword";
  static const toggleTwoFactorAuthScreen =
      "/profile-settings/toggleTwoFactorAuthScreen";
  static const identityVerificationScreen =
      "/profile-settings/identityVerificationScreen";
  static const editRoommatePreferencesScreen =
      "/profile-settings/editRoommatePreferencesScreen";

  // property screens
  static const addPropertyManageScreen = "/add-property";
  static const myPropertiesScreen = "/property-by-owner/:id";
  static const viewPropertyDetailsScreen = "/property/:id";
  static const favoritesPropertyManageScreen = "/favoritesPropertyManageScreen";
  static const editPropertyManageScreen = "/edit-property/:id";

  // dashboard screens
  static const renterDashboardScreen = "/tenant-dashboard";
  static const ownerDashboardScreen = "/owner-dashboard";

  // contract screen
  static const contractScreen = "/contract/:id";

  // chatbot screen
  static const chatBootScreen = "/chatbot";

  // roommate screen
  static const roommateScreen = "/roommateScreen";
}

abstract class AppPaths {
  // static screens
  static const aboutMarnScreen = "about";
  static const contactScreen = "contact";
  static const error404Screen = "error404Screen";
  static const faqScreen = 'faq';
  static const howItWorksScreen = "how-it-works";
  static const privacyPolicyScreen = "privacy";
  static const termsOfUseScreen = "terms";

  // auth screens
  static const splashScreen = "splash";
  static const resetPasswordScreen = "reset-password";
  static const confirmEmailScreen = "confirm-email";
  static const signUpScreen = "signup";
  static const loginScreen = "login";
  static const forgotPasswordScreen = "forgot-password";
  static const twoFactorAuthScreen = "otp-verification";

  // main screens
  static const mainLayoutScreen = "/";

  // setting screens
  static const settingScreen = "profile-settings";

  // chat screens
  static const listChatsScreen = "messages";
  static const chatScreen = "rental-request/:id";

  // profile screens
  static const profileScreen = "user/:id";
  static const editProfileScreen = "editProfile";
  static const changePasswordScreen = "changePassword";
  static const toggleTwoFactorAuthScreen = "toggleTwoFactorAuthScreen";
  static const identityVerificationScreen = "identityVerificationScreen";
  static const editRoommatePreferencesScreen = "editRoommatePreferencesScreen";

  // property screens
  static const addPropertyManageScreen = "add-property";
  static const myPropertiesScreen = "property-by-owner/:id";
  static const viewPropertyDetailsScreen = "property/:id";
  static const favoritesPropertyManageScreen = "favoritesPropertyManageScreen";
  static const editPropertyManageScreen = "edit-property/:id";

  // dashboard screens
  static const renterDashboardScreen = "tenant-dashboard";
  static const ownerDashboardScreen = "owner-dashboard";

  // contract screen
  static const contractScreen = "contract/:id";

  // chatbot screen
  static const chatBootScreen = "chatbot";

  // roommate screen
  static const roommateScreen = "roommateScreen";
}
