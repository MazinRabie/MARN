import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/booking_contracts_payments/data/data_sources/payment_service.dart';
import 'package:MARN/features/booking_contracts_payments/domain/entities/payment_entity.dart';
import 'package:MARN/features/booking_contracts_payments/domain/repositories/payment_repo.dart';
import 'package:dartz/dartz.dart';

class PaymentRepoImpl implements PaymentRepo {
  final PaymentService paymentService;
  PaymentRepoImpl({required this.paymentService});

  @override
  Future<Either<Failure, StartPaymentEntity>> startPayment({
    required int paymentScheduleId,
  }) async {
    try {
      final response = await paymentService.startPayment(
        paymentScheduleId: paymentScheduleId,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> connectAccount() async {
    try {
      final response = await paymentService.connectAccount();
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> withdraw() async {
    try {
      final response = await paymentService.withdraw();
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
