import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/booking_contracts_payments/domain/entities/payment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PaymentRepo {
  Future<Either<Failure, StartPaymentEntity>> startPayment({
    required int paymentScheduleId,
  });
  Future<Either<Failure, String>> connectAccount();
  Future<Either<Failure, String>> withdraw();
}
