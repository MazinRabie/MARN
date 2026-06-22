import 'package:MARN/features/booking_contracts_payments/domain/entities/payment_entity.dart';

class StartPaymentModel extends StartPaymentEntity {
  StartPaymentModel({required super.message, required super.clientSecret});

  factory StartPaymentModel.fromJson(Map<String, dynamic> json) {
    return StartPaymentModel(
      message: json['message'],
      clientSecret: json['data'],
    );
  }
}