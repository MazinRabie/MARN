import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:dio/dio.dart';

class SupportService {
  final ApiService _apiService;

  SupportService(this._apiService);

  Future<Response> contactUs({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String subject,
    required String message,
  }) async {
    return await _apiService.post(
      endPoint: ApiEndPoints.contactUs,
      body: {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'subject': subject,
        'message': message,
      },
    );
  }
}
