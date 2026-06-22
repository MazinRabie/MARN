import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:MARN/core/routes/app_routes.dart';
import 'package:MARN/core/routes/routes.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/payment_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// 🔹 Gets the dynamic emoji based on notification type ID or name fallback.
String getNotificationEmoji(EnumItem? type) {
  if (type == null) return "📢";
  switch (type.id) {
    case 0:
      return "📢"; // General
    case 1:
      return "💬"; // NewMessage
    case 2:
      return "📅"; // NewBookingRequest
    case 3:
      return "❌"; // BookingRequestCanceled
    case 4:
      return "🚫"; // BookingRequestRejected
    case 5:
      return "⭐"; // NewReview
    case 6:
      return "📜"; // ContractStarted
    case 7:
      return "⚠️"; // ContractCanceled
    case 8:
      return "✍️"; // ContractSigned
    case 9:
      return "✅"; // ContractCompleted
    case 10:
      return "💵"; // UpcomingPayment
    case 11:
      return "💰"; // PaymentArrived
    case 12:
      return "⏳"; // DelayedPayment
    case 13:
      return "🎉"; // PaymentSuccessful
    case 14:
      return "❌"; // PaymentFailed
    case 15:
      return "📥"; // PaymentReceived
    case 16:
      return "🏦"; // AvailableForWithdrawal
    case 17:
      return "🔗"; // ConnectAccountSuccess
    case 18:
      return "🛑"; // ConnectAccountFailed
    case 19:
      return "💸"; // WithdrawSuccess
    case 20:
      return "❌"; // WithdrawFailed
    case 21:
      return "🏠"; // PropertyAdded
    case 22:
      return "📝"; // PropertyEdited
    case 23:
      return "🗑️"; // PropertyDeleted
    default:
      switch (type.name.toLowerCase()) {
        case 'general':
          return "📢";
        case 'newmessage':
          return "💬";
        case 'newbookingrequest':
          return "📅";
        case 'bookingrequestcanceled':
          return "❌";
        case 'bookingrequestrejected':
          return "🚫";
        case 'newreview':
          return "⭐";
        case 'contractstarted':
          return "📜";
        case 'contractcanceled':
          return "⚠️";
        case 'contractsigned':
          return "✍️";
        case 'contractcompleted':
          return "✅";
        case 'upcomingpayment':
          return "💵";
        case 'paymentarrived':
          return "💰";
        case 'delayedpayment':
          return "⏳";
        case 'paymentsuccessful':
          return "🎉";
        case 'paymentfailed':
          return "❌";
        case 'paymentreceived':
          return "📥";
        case 'availableforwithdrawal':
          return "🏦";
        case 'connectaccountsuccess':
          return "🔗";
        case 'connectaccountfailed':
          return "🛑";
        case 'withdrawsuccess':
          return "💸";
        case 'withdrawfailed':
          return "❌";
        case 'propertyadded':
          return "🏠";
        case 'propertyedited':
          return "📝";
        case 'propertydeleted':
          return "🗑️";
        default:
          return "📢";
      }
  }
}

/// 🔹 Resolves action mapping for routing based on actionType and actionId.
void handleNotificationAction(
  BuildContext context, {
  required EnumItem? actionType,
  required String? actionId,
}) {
  final actionTypeStr = actionType?.name.toLowerCase();

  if (actionTypeStr == 'property') {
    final id = int.tryParse(actionId ?? '') ?? 0;
    context.pushReplacement(
      AppRoutes.viewPropertyDetailsScreen,
      extra: ViewPropertyDetailsScreenArguments(id: id),
    );
  } else if (actionTypeStr == 'chatuser') {
    context.pushReplacement(
      AppRoutes.chatScreen,
      extra: ChatScreenArguments(userId: actionId ?? ''),
    );
  } else if (actionTypeStr == 'editprofile') {
    context.pushReplacement(AppRoutes.editProfileScreen);
  } else if (actionTypeStr == 'renterdashboard') {
    context.pushReplacement(AppRoutes.renterDashboardScreen);
  } else if (actionTypeStr == 'ownerdashboard') {
    context.pushReplacement(AppRoutes.ownerDashboardScreen);
  } else if (actionTypeStr == 'contract') {
    final id = int.tryParse(actionId ?? '') ?? 0;
    context.pushReplacement(
      AppRoutes.contractScreen,
      extra: ContractScreenArguments(contractId: id),
    );
  } else if (actionTypeStr == 'payment') {
    final id = int.tryParse(actionId ?? '') ?? 0;
    context.read<PaymentCubit>().paySchedule(paymentScheduleId: id);
  }
}

/// 🔹 Translates actionType to a descriptive localized action label.
String getNotificationActionText(EnumItem? actionType) {
  if (actionType == null) return '';
  switch (actionType.name.toLowerCase()) {
    case 'property':
      return LocaleKeys.mainLayoutNotificationsViewProperty.tr();
    case 'chatuser':
      return LocaleKeys.mainLayoutNotificationsChatNow.tr();
    case 'editprofile':
      return LocaleKeys.mainLayoutNotificationsEditProfile.tr();
    case 'renterdashboard':
      return LocaleKeys.mainLayoutNotificationsRenterDashboard.tr();
    case 'ownerdashboard':
      return LocaleKeys.mainLayoutNotificationsOwnerDashboard.tr();
    case 'contract':
      return LocaleKeys.mainLayoutNotificationsViewContract.tr();
    case 'payment':
      return LocaleKeys.mainLayoutNotificationsPayNow.tr();
    default:
      return LocaleKeys.mainLayoutNotificationsAction.tr();
  }
}
