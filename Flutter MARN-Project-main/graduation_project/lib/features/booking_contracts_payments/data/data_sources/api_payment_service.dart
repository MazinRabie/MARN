import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/features/booking_contracts_payments/data/data_sources/payment_service.dart';
import 'package:MARN/features/booking_contracts_payments/data/models/payment_model.dart';

class ApiPaymentService implements PaymentService {
  final ApiService apiService;
  const ApiPaymentService({required this.apiService});

  @override
  Future<StartPaymentModel> startPayment({
    required int paymentScheduleId,
  }) async {
    return await handleRequest(() async {
      final response = await apiService.post(
        endPoint: ApiEndPoints.startPayment,
        queryParameters: {"paymentScheduleId": paymentScheduleId},
      );
      if (response.statusCode == 200) {
        return StartPaymentModel.fromJson(response.data);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> connectAccount() async {
    return await handleRequest(() async {
      final response = await apiService.post(
        endPoint: ApiEndPoints.paymentConnectAccount,
      );
      if (response.statusCode == 200) {
        return response.data['data'] ?? '';
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> withdraw() async {
    return await handleRequest(() async {
      final response = await apiService.post(
        endPoint: ApiEndPoints.paymentWithdraw,
      );
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Withdrawal initiated successfully';
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }
}
