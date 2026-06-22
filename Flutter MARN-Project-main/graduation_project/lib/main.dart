import 'package:MARN/core/routes/app_router.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/core/theme/app_gradient.dart';
import 'package:MARN/core/services/service_locator.dart';
import 'package:MARN/core/theme/app_theme.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:MARN/features/chat/presentation/state_management/cubit/message_cubit.dart';
import 'package:MARN/features/dashboard/presentation/state_management/cubit/dashboard_cubit.dart';
import 'package:MARN/features/main_layout/presentation/state_management/cubit/notification_cubit.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_setting_cubit.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/payment_cubit.dart';
import 'package:MARN/core/enums/cubit/enum_cubit.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/main_layout/presentation/state_management/cubit/roommate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:MARN/core/utilities/api_keys.dart';
import 'firebase_options.dart';

import 'package:MARN/core/localization/language_manager.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();
  await SharedPreferencesHelper.init();
  setupServiceLocator();
  await getIt<EnumCubit>().loadEnums(forceRefresh: true);
  Stripe.publishableKey = ApiKeys.stripePublicKey;
  final initialLocale = await LanguageManager.getInitialLocale();

  runApp(
    EasyLocalization(
      supportedLocales: LanguageManager.getSupportedLocales(),
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: initialLocale,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: getIt<EnumCubit>()),
          BlocProvider(create: (_) => getIt<AuthCubit>()),
          BlocProvider(create: (_) => getIt<ProfileCubit>()),
          BlocProvider(create: (_) => getIt<MessageCubit>()),
          BlocProvider(create: (_) => getIt<ProfileSettingCubit>()),
          BlocProvider(create: (_) => getIt<NotificationCubit>()),
          BlocProvider(create: (_) => getIt<PropertyCubit>()),
          BlocProvider(create: (_) => getIt<BookingContractCubit>()),
          BlocProvider(create: (_) => getIt<DashboardCubit>()),
          BlocProvider(create: (_) => getIt<PaymentCubit>()),
          BlocProvider(create: (_) => getIt<RoommateCubit>()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'MARN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            gradient: AppGradient.primaryGradient,
          ),
          child: child,
        );
      },
    );
  }
}
