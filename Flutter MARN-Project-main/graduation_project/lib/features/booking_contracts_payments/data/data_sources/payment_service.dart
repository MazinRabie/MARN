import 'package:MARN/features/booking_contracts_payments/data/models/payment_model.dart';

abstract class PaymentService {
  Future<StartPaymentModel> startPayment({required int paymentScheduleId});
  Future<String> connectAccount();
  Future<String> withdraw();
}
