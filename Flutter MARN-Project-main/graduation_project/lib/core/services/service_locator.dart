import 'package:MARN/core/enums/data/enum_repository.dart';
import 'package:MARN/core/enums/cubit/enum_cubit.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/services/report_service.dart';
import 'package:MARN/features/chatboot/data/data_sources/assistant_service.dart';
import 'package:MARN/features/chatboot/data/data_sources/api_assistant_service.dart';
import 'package:MARN/features/chatboot/domain/repositories/assistant_repository.dart';
import 'package:MARN/features/chatboot/data/repositories/assistant_repository_impl.dart';
import 'package:MARN/features/chatboot/presentation/state_management/cubit/assistant_cubit.dart';
import 'package:MARN/features/static_screens/data/support_service.dart';
import 'package:MARN/features/auth/data/data_sources/api_auth_service.dart';
import 'package:MARN/features/auth/data/data_sources/auth_service.dart';
import 'package:MARN/features/auth/data/repositories/auth_repo_imple.dart';
import 'package:MARN/features/auth/domain/repositories/auth_repo.dart';
import 'package:MARN/features/auth/presentation/state_management/cubit/auth_cubit.dart';
import 'package:MARN/features/chat/data/data_sources/chat_service.dart';
import 'package:MARN/features/chat/data/data_sources/chat_service_impl.dart';
import 'package:MARN/features/chat/data/data_sources/message_service.dart';
import 'package:MARN/features/chat/data/data_sources/message_service_impl.dart';
import 'package:MARN/features/chat/data/repositories/chat_repo_imple.dart';
import 'package:MARN/features/chat/data/repositories/message_repo_imple.dart';
import 'package:MARN/features/chat/domain/repositories/chat_repo.dart';
import 'package:MARN/features/chat/domain/repositories/message_repo.dart';
import 'package:MARN/features/chat/presentation/state_management/cubit/message_cubit.dart';
import 'package:MARN/features/dashboard/data/data_sources/dashboard_service.dart';
import 'package:MARN/features/dashboard/data/data_sources/dashboard_service_impl.dart';
import 'package:MARN/features/main_layout/data/data_sources/notifications_impl.dart';
import 'package:MARN/features/main_layout/data/data_sources/notifications_service.dart';
import 'package:MARN/features/dashboard/data/repositories/dashboard_repo_impl.dart';
import 'package:MARN/features/main_layout/data/repositories/notification_repo_impl.dart';
import 'package:MARN/features/dashboard/domain/repositories/dashboard_repo.dart';
import 'package:MARN/features/main_layout/domain/repositories/notification_repo.dart';
import 'package:MARN/features/dashboard/presentation/state_management/cubit/dashboard_cubit.dart';
import 'package:MARN/features/main_layout/presentation/state_management/cubit/notification_cubit.dart';
import 'package:MARN/features/profile/data/data_sources/api_profile_service.dart';
import 'package:MARN/features/profile/data/data_sources/profile_service.dart';
import 'package:MARN/features/profile/data/repositories/profile_repo_impl.dart';
import 'package:MARN/features/profile/domain/repositories/profile_repo.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_cubit.dart';
import 'package:MARN/features/profile/presentation/state_management/cubit/profile_setting_cubit.dart';
import 'package:MARN/features/booking_contracts_payments/data/data_sources/api_booking_contract_request_service.dart';
import 'package:MARN/features/property/data/data_sources/api_property_service.dart';
import 'package:MARN/features/booking_contracts_payments/data/data_sources/booking_contract_request_service.dart';
import 'package:MARN/features/property/data/data_sources/property_service.dart';
import 'package:MARN/features/booking_contracts_payments/data/repositories/booking_contract_repo_impl.dart';
import 'package:MARN/features/property/data/repositories/property_repo_impl.dart';
import 'package:MARN/features/booking_contracts_payments/domain/repositories/booking_contract_repo.dart';
import 'package:MARN/features/property/domain/repositories/property_repo.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/booking_contract_cubit.dart';
import 'package:MARN/features/booking_contracts_payments/data/data_sources/api_payment_service.dart';
import 'package:MARN/features/booking_contracts_payments/data/data_sources/payment_service.dart';
import 'package:MARN/features/booking_contracts_payments/data/repositories/payment_repo_impl.dart';
import 'package:MARN/features/booking_contracts_payments/domain/repositories/payment_repo.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/payment_cubit.dart';
import 'package:MARN/features/property/presentation/state_management/cubit/property_cubit.dart';
import 'package:MARN/features/main_layout/data/data_sources/roommate_service.dart';
import 'package:MARN/features/main_layout/data/data_sources/api_roommate_service.dart';
import 'package:MARN/features/main_layout/domain/repositories/roommate_repo.dart';
import 'package:MARN/features/main_layout/data/repositories/roommate_repo_impl.dart';
import 'package:MARN/features/main_layout/presentation/state_management/cubit/roommate_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Networking
  getIt.registerSingleton<Dio>(
    Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );
  getIt.registerSingleton<ApiService>(ApiService(getIt<Dio>()));

  // Report Service
  getIt.registerLazySingleton<ReportService>(
    () => ReportService(getIt<ApiService>()),
  );

  // Support Service
  getIt.registerLazySingleton<SupportService>(
    () => SupportService(getIt<ApiService>()),
  );

  // Enum Feature
  getIt.registerLazySingleton<EnumRepository>(
    () => EnumRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<EnumCubit>(
    () => EnumCubit(getIt<EnumRepository>()),
  );

  // Auth Feature
  getIt.registerLazySingleton<AuthService>(
    () => ApiAuthService(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(authService: getIt<AuthService>()),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(authRepo: getIt<AuthRepo>()),
  );

  /// Chat Feature
  // api service
  getIt.registerLazySingleton<ChatService>(
    () => ChatServiceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ChatRepo>(
    () => ChatRepoImpl(chatService: getIt<ChatService>()),
  );
  // signalr service
  getIt.registerLazySingleton<MessageService>(
    () => MessageServiceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<MessageRepo>(
    () => MessageRepoImpl(messageService: getIt<MessageService>()),
  );
  getIt.registerLazySingleton<MessageCubit>(
    () => MessageCubit(
      messageRepo: getIt<MessageRepo>(),
      chatRepo: getIt<ChatRepo>(),
    ),
  );

  // Profile Feature
  getIt.registerLazySingleton<ProfileService>(
    () => ApiProfileService(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(profileService: getIt<ProfileService>()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(profileRepo: getIt<ProfileRepo>()),
  );
  getIt.registerLazySingleton<ProfileSettingCubit>(
    () => ProfileSettingCubit(profileRepo: getIt<ProfileRepo>()),
  );

  // Notifications Feature
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationsServiceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<NotificationRepo>(
    () =>
        NotificationRepoImpl(notificationService: getIt<NotificationService>()),
  );
  getIt.registerLazySingleton<NotificationCubit>(
    () => NotificationCubit(notificationRepo: getIt<NotificationRepo>()),
  );

  // Property Feature
  getIt.registerLazySingleton<PropertyService>(
    () => ApiPropertyService(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<PropertyRepo>(
    () => PropertyRepoImpl(propertyService: getIt<PropertyService>()),
  );
  getIt.registerFactory<PropertyCubit>(
    () => PropertyCubit(propertyRepo: getIt<PropertyRepo>()),
  );

  // Booking Feature
  getIt.registerLazySingleton<BookingContractRequestService>(
    () => ApiBookingContractRequestService(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<BookingContractRepo>(
    () => BookingContractRepoImpl(
      bookingRequestService: getIt<BookingContractRequestService>(),
    ),
  );
  getIt.registerFactory<BookingContractCubit>(
    () => BookingContractCubit(bookingRepo: getIt<BookingContractRepo>()),
  );

  // Payment Feature
  getIt.registerLazySingleton<PaymentService>(
    () => ApiPaymentService(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<PaymentRepo>(
    () => PaymentRepoImpl(paymentService: getIt<PaymentService>()),
  );
  getIt.registerFactory<PaymentCubit>(
    () => PaymentCubit(paymentRepo: getIt<PaymentRepo>()),
  );

  // Dashboard Feature
  getIt.registerLazySingleton<DashboardService>(
    () => DashboardServiceImpl(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<DashboardRepo>(
    () => DashboardRepoImpl(dashboardService: getIt<DashboardService>()),
  );
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(dashboardRepo: getIt<DashboardRepo>()),
  );

  // Roommate Feature
  getIt.registerLazySingleton<RoommateService>(
    () => ApiRoommateService(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RoommateRepo>(
    () => RoommateRepoImpl(roommateService: getIt<RoommateService>()),
  );
  getIt.registerFactory<RoommateCubit>(
    () => RoommateCubit(roommateRepo: getIt<RoommateRepo>()),
  );

  // Chatbot Feature
  getIt.registerLazySingleton<AssistantService>(
    () => ApiAssistantService(apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AssistantRepository>(
    () => AssistantRepositoryImpl(assistantService: getIt<AssistantService>()),
  );
  getIt.registerFactory<AssistantCubit>(
    () => AssistantCubit(assistantRepository: getIt<AssistantRepository>()),
  );
}
