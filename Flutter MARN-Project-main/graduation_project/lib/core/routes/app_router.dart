import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/features/static_screens/presentation/screens/error404_screen.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    routes: routes,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn =
          SharedPreferencesHelper.getString(LocalStorageVariables.token) !=
          null;

      final location = state.uri.path;

      final publicPrefixes = [
        AppRoutes.aboutMarnScreen,
        AppRoutes.contactScreen,
        AppRoutes.error404Screen,
        AppRoutes.faqScreen,
        AppRoutes.howItWorksScreen,
        AppRoutes.privacyPolicyScreen,
        AppRoutes.termsOfUseScreen,
        AppRoutes.splashScreen,
        AppRoutes.resetPasswordScreen,
        AppRoutes.confirmEmailScreen,
        AppRoutes.signUpScreen,
        AppRoutes.loginScreen,
        AppRoutes.forgotPasswordScreen,
        AppRoutes.twoFactorAuthScreen,
        AppRoutes.profileScreen,
        AppRoutes.viewPropertyDetailsScreen,
      ];

      final isPublic = publicPrefixes.any((path) {
        final basePath = path.split('/:').first;
        return location == basePath || location.startsWith('$basePath/');
      });

      if (!isLoggedIn && !isPublic) {
        return AppRoutes.loginScreen;
      }

      return null;
    },
    errorBuilder: (context, state) {
      return const Error404Screen();
    },
  );
}
