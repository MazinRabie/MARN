import 'package:MARN/features/booking_contracts_payments/domain/repositories/payment_repo.dart';
import 'package:MARN/features/booking_contracts_payments/presentation/state_management/cubit/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepo paymentRepo;

  PaymentCubit({required this.paymentRepo}) : super(PaymentInitial());

  Future<void> paySchedule({required int paymentScheduleId}) async {
    emit(PaymentLoading());
    final result = await paymentRepo.startPayment(
      paymentScheduleId: paymentScheduleId,
    );

    await result.fold(
      (failure) async {
        emit(PaymentFailure(errorMessage: failure.errorMessage));
      },
      (startPaymentEntity) async {
        try {
          // Initialize Stripe Payment Sheet
          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: startPaymentEntity.clientSecret,
              merchantDisplayName: LocaleKeys.paymentsCheckoutMerchantDisplayName.tr(),
            ),
          );

          // Present Stripe Payment Sheet
          await Stripe.instance.presentPaymentSheet();

          emit(PaymentSuccess(message: startPaymentEntity.message));
        } on StripeException catch (e) {
          emit(
            PaymentFailure(
              errorMessage: e.error.localizedMessage ?? LocaleKeys.paymentsErrorsPaymentCancelled.tr(),
            ),
          );
        } catch (e) {
          emit(PaymentFailure(errorMessage: e.toString()));
        }
      },
    );
  }

  Future<void> connectStripeAccount() async {
    emit(PaymentLoading());
    final result = await paymentRepo.connectAccount();

    result.fold(
      (failure) => emit(PaymentFailure(errorMessage: failure.errorMessage)),
      (url) => emit(ConnectSuccess(url: url)),
    );
  }

  Future<void> withdrawEarnings() async {
    emit(PaymentLoading());
    final result = await paymentRepo.withdraw();

    result.fold(
      (failure) => emit(PaymentFailure(errorMessage: failure.errorMessage)),
      (message) => emit(WithdrawSuccess(message: message)),
    );
  }
}
