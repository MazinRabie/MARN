import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/ui/screens/contract.dart';
import 'package:MARN/core/services/service_locator.dart';
import 'package:MARN/features/auth/presentation/ui/screens/confirm_email_screen.dart';
import 'package:MARN/features/auth/presentation/ui/screens/reset_password_screen.dart';
import 'package:MARN/features/chatboot/presentation/ui/screens/chat_boot_screen.dart';
import 'package:MARN/features/chatboot/presentation/state_management/cubit/assistant_cubit.dart';
import 'package:MARN/features/dashboard/presentation/ui/screens/owner_dash_board_screen.dart';
import 'package:MARN/features/profile/domain/repositories/profile_repo.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:MARN/features/profile/presentation/ui/screens/profile_screen.dart';
import 'package:MARN/features/profile/presentation/ui/screens/change_password_screen.dart';
import 'package:MARN/features/profile/presentation/ui/screens/edit_profile_screen.dart';
import 'package:MARN/features/profile/presentation/ui/screens/edit_roommate_preferences_screen.dart';
import 'package:MARN/features/profile/presentation/ui/screens/identity_verification_screen.dart';
import 'package:MARN/features/profile/presentation/ui/screens/toggle_two_factor_auth_screen.dart';
import 'package:MARN/features/property/presentation/ui/screens/add_property_screen.dart';
import 'package:MARN/features/property/presentation/ui/screens/edit_property_screen.dart';
import 'package:MARN/features/property/presentation/ui/screens/favorites_property_manage.dart';
import 'package:MARN/features/property/presentation/ui/screens/my_properties.dart';
import 'package:MARN/features/property/presentation/ui/screens/view_property_details_manager_screen.dart';
import 'package:MARN/features/static_screens/presentation/screens/about_marn_screen.dart';
import 'package:MARN/features/static_screens/presentation/screens/contact_screen.dart';
import 'package:MARN/features/static_screens/presentation/screens/error404_screen.dart';
import 'package:MARN/features/static_screens/presentation/screens/how_it_works_screen.dart';
import 'package:MARN/features/static_screens/presentation/screens/privacy_policy_screen.dart';
import 'package:MARN/features/static_screens/presentation/screens/terms_of_use_screen.dart';
import 'package:MARN/features/static_screens/presentation/screens/faq_screen.dart';
import 'package:MARN/features/auth/presentation/ui/screens/forgot_password_screen.dart';
import 'package:MARN/features/auth/presentation/ui/screens/login_screen.dart';
import 'package:MARN/features/auth/presentation/ui/screens/signup_screen.dart';
import 'package:MARN/features/auth/presentation/ui/screens/two_factor_auth_screen.dart';
import 'package:MARN/features/auth/presentation/ui/screens/splash_screen.dart';
import 'package:MARN/features/main_layout/presentation/ui/screens/main_page.dart';
import 'package:MARN/features/main_layout/presentation/ui/screens/setting_screen.dart';
import 'package:MARN/features/chat/presentation/ui/screens/chat_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

List<GoRoute> routes = [
  // error screen
  GoRoute(
    path: AppRoutes.error404Screen,
    builder: (context, state) => const Error404Screen(),
  ),

  // splash screen
  GoRoute(
    path: AppRoutes.splashScreen,
    builder: (context, state) => SplashScreen(),
  ),

  // auth screens
  GoRoute(
    path: AppRoutes.loginScreen,
    builder: (context, state) => LoginScreen(),
  ),
  GoRoute(
    path: AppRoutes.signUpScreen,
    builder: (context, state) => SignUpScreen(),
  ),
  GoRoute(
    path: AppRoutes.twoFactorAuthScreen,
    builder: (context, state) {
      if (state.extra is! TwoFactorAuthArguments) {
        return const Error404Screen();
      }
      final args = state.extra as TwoFactorAuthArguments;
      return TwoFactorAuthScreen(
        email: args.email,
        password: args.password,
        rememberMe: args.rememberMe,
      );
    },
  ),
  GoRoute(
    path: AppRoutes.forgotPasswordScreen,
    builder: (context, state) => ForgotPasswordScreen(),
  ),
  GoRoute(
    path: AppRoutes.confirmEmailScreen,
    builder: (context, state) {
      final userId = state.uri.queryParameters['userId'];
      final token = state.uri.queryParameters['token'];
      return ConfirmEmailScreen(userId: userId!, token: token!);
    },
  ),
  GoRoute(
    path: AppRoutes.resetPasswordScreen,
    builder: (context, state) {
      final email = state.uri.queryParameters['email'];
      final token = state.uri.queryParameters['token'];
      return ResetPasswordScreen(email: email!, token: token!);
    },
  ),

  // static screens
  GoRoute(
    path: AppRoutes.aboutMarnScreen,
    builder: (context, state) => AboutMarnScreen(),
  ),
  GoRoute(
    path: AppRoutes.contactScreen,
    builder: (context, state) => ContactScreen(),
  ),
  GoRoute(path: AppRoutes.faqScreen, builder: (context, state) => FAQScreen()),
  GoRoute(
    path: AppRoutes.howItWorksScreen,
    builder: (context, state) => HowItWorksScreen(),
  ),
  GoRoute(
    path: AppRoutes.privacyPolicyScreen,
    builder: (context, state) => PrivacyPolicyScreen(),
  ),
  GoRoute(
    path: AppRoutes.termsOfUseScreen,
    builder: (context, state) => TermsOfUseScreen(),
  ),

  // mainLayoutScreen
  GoRoute(
    path: AppRoutes.mainLayoutScreen,
    builder: (context, state) => MainLayoutScreen(),
    routes: [
      // settingScreen
      GoRoute(
        path: AppPaths.settingScreen,
        builder: (context, state) => SettingScreen(),
        routes: [
          GoRoute(
            path: AppPaths.changePasswordScreen,
            builder: (context, state) => ChangePasswordScreen(),
          ),
          GoRoute(
            path: AppPaths.toggleTwoFactorAuthScreen,
            builder: (context, state) => const ToggleTwoFactorAuthScreen(),
          ),
          GoRoute(
            path: AppPaths.editRoommatePreferencesScreen,
            builder: (context, state) => EditRoommatePreferencesScreen(),
          ),
          GoRoute(
            path: AppPaths.identityVerificationScreen,
            builder: (context, state) => IdentityVerificationScreen(),
          ),
          GoRoute(
            path: AppPaths.editProfileScreen,
            builder: (context, state) => EditProfileScreen(),
          ),
        ],
      ),

      // listChatsScreen
      GoRoute(
        path: AppPaths.listChatsScreen,
        builder: (context, state) => MainLayoutScreen(initialIndex: 3),
        routes: [
          // chatScreen
          GoRoute(
            path: AppPaths.chatScreen,
            builder: (context, state) {
              String? userId;
              bool? isOnline;
              if (state.extra is ChatScreenArguments) {
                userId = (state.extra as ChatScreenArguments).userId;
                isOnline = (state.extra as ChatScreenArguments).isOnline;
              } else if (state.pathParameters['id'] != null) {
                userId = state.pathParameters['id'];
              }
              if (userId == null || userId == ':id') {
                return const Error404Screen();
              }
              return BlocProvider(
                create: (_) =>
                    ProfileCubit(profileRepo: getIt<ProfileRepo>())
                      ..getUserProfile(userId: userId!),
                child: ChatScreen(userId: userId, isOnline: isOnline),
              );
            },
          ),
        ],
      ),

      // profileScreen
      GoRoute(
        path: AppPaths.profileScreen,
        builder: (context, state) {
          String? userId;
          if (state.extra is ProfileScreenArguments) {
            userId = (state.extra as ProfileScreenArguments).userId;
          } else if (state.pathParameters['id'] != null) {
            userId = state.pathParameters['id'];
          }
          final resolvedUserId = (userId == ':id' || userId == null)
              ? null
              : userId;
          if (resolvedUserId != null) {
            return BlocProvider(
              create: (_) =>
                  ProfileCubit(profileRepo: getIt<ProfileRepo>())
                    ..getUserProfile(userId: resolvedUserId),
              child: ProfileScreen(userId: resolvedUserId),
            );
          }
          return const ProfileScreen();
        },
      ),

      // viewPropertyDetailsScreen
      GoRoute(
        path: AppPaths.viewPropertyDetailsScreen,
        builder: (context, state) {
          int? id;
          if (state.extra is ViewPropertyDetailsScreenArguments) {
            id = (state.extra as ViewPropertyDetailsScreenArguments).id;
          } else if (state.pathParameters['id'] != null) {
            id = int.tryParse(state.pathParameters['id']!);
          }
          if (id == null) {
            return const Error404Screen();
          }
          return ViewPropertyDetailsManagerScreen(id: id);
        },
      ),

      // addPropertyManageScreen
      GoRoute(
        path: AppPaths.addPropertyManageScreen,
        builder: (context, state) => AddPropertyScreen(),
      ),

      // myPropertiesScreen
      GoRoute(
        path: AppPaths.myPropertiesScreen,
        builder: (context, state) => MyPropertiesScreen(),
      ),

      // favoritesPropertyManageScreen
      GoRoute(
        path: AppPaths.favoritesPropertyManageScreen,
        builder: (context, state) => FavoritesPropertyManage(),
      ),

      // editPropertyManageScreen
      GoRoute(
        path: AppPaths.editPropertyManageScreen,
        builder: (context, state) {
          int? id;
          int index = 0;
          if (state.extra is EditPropertyScreenArguments) {
            final args = state.extra as EditPropertyScreenArguments;
            id = args.id;
            index = args.index;
          } else if (state.pathParameters['id'] != null) {
            id = int.tryParse(state.pathParameters['id']!);
          }
          if (id == null) {
            return const Error404Screen();
          }
          return EditPropertyScreen(id: id, index: index);
        },
      ),

      // renterDashboardScreen
      GoRoute(
        path: AppPaths.renterDashboardScreen,
        builder: (context, state) => MainLayoutScreen(initialIndex: 0),
      ),

      // ownerDashboardScreen
      GoRoute(
        path: AppPaths.ownerDashboardScreen,
        builder: (context, state) => OwnerDashBoardScreen(),
      ),

      // contractScreen
      GoRoute(
        path: AppPaths.contractScreen,
        builder: (context, state) {
          int? contractId;
          if (state.extra is ContractScreenArguments) {
            contractId = (state.extra as ContractScreenArguments).contractId;
          } else if (state.pathParameters['id'] != null) {
            contractId = int.tryParse(state.pathParameters['id']!);
          }
          if (contractId == null) {
            return const Error404Screen();
          }
          return ContractScreen(contractId: contractId);
        },
      ),

      // chatbot Screen
      GoRoute(
        path: AppPaths.chatBootScreen,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AssistantCubit>()..getSessions(),
          child: const ChatBootScreen(),
        ),
      ),

      // roommateScreen
      GoRoute(
        path: AppPaths.roommateScreen,
        builder: (context, state) => MainLayoutScreen(initialIndex: 2),
      ),
    ],
  ),
];

// arguments classes
class ContractScreenArguments {
  final int contractId;
  ContractScreenArguments({required this.contractId});
}

class TwoFactorAuthArguments {
  final String email;
  final String password;
  final bool rememberMe;
  TwoFactorAuthArguments({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

class ChatScreenArguments {
  final String userId;
  final bool? isOnline;
  ChatScreenArguments({required this.userId, this.isOnline});
}

class ViewPropertyDetailsScreenArguments {
  final int id;
  ViewPropertyDetailsScreenArguments({required this.id});
}

class EditPropertyScreenArguments {
  final int id;
  final int index;
  EditPropertyScreenArguments({required this.id, required this.index});
}

class ProfileScreenArguments {
  final String? userId;
  ProfileScreenArguments({this.userId});
}
