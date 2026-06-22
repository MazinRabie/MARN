import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:dio/dio.dart';

class ReportService {
  final ApiService _apiService;

  ReportService(this._apiService);

  Future<Response> submitReport({
    required EnumItem reportableType,
    required String reportableTargetId,
    required String reason,
  }) async {
    return await _apiService.post(
      endPoint: ApiEndPoints.report,
      body: {
        'reportableType': reportableType.toBackendValue(),
        'reportableTargetId': reportableTargetId,
        'reason': reason,
      },
    );
  }
}
