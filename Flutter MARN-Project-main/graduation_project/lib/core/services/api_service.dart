import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/core/utilities/api_keys.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  ApiService(this._dio);

  final String _baseUrl = ApiKeys.apiBaseUrl;

  /// Returns the current language from SharedPreferences (defaults to 'en')
  String get _language =>
      SharedPreferencesHelper.getString(LocalStorageVariables.language) ?? 'en';

  /// Base headers shared across all requests (Auth + Accept-Language)
  Map<String, String> get _baseHeaders {
    final headers = <String, String>{
      'Accept-Language': _language,
    };
    final token = SharedPreferencesHelper.getString(LocalStorageVariables.token);
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final headers = Map<String, String>.from(_baseHeaders);
    if (options?.headers != null) {
      headers.addAll(
        options!.headers!.map((key, value) => MapEntry(key, value.toString())),
      );
    }
    return await _dio.get(
      '$_baseUrl$endPoint',
      options: (options ?? Options()).copyWith(headers: headers),
      queryParameters: queryParameters,
    );
  }

  Future<Response> post({
    required String endPoint,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final allHeaders = Map<String, String>.from(_baseHeaders)
      ..addAll(headers ?? {});
    final postOptions = (options ?? Options()).copyWith(headers: allHeaders);
    return await _dio.post(
      '$_baseUrl$endPoint',
      data: body,
      options: postOptions,
      queryParameters: queryParameters,
    );
  }

  Future<Response> put({
    required String endPoint,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final allHeaders = Map<String, String>.from(_baseHeaders)
      ..addAll(headers ?? {});
    return await _dio.put(
      '$_baseUrl$endPoint',
      data: body,
      options: Options(headers: allHeaders),
    );
  }

  Future<Response> patch({
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    return await _dio.patch(
      '$_baseUrl$endPoint',
      data: body,
      options: Options(headers: _baseHeaders),
    );
  }

  Future<Response> delete({
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    return await _dio.delete(
      '$_baseUrl$endPoint',
      data: body,
      options: Options(headers: _baseHeaders),
    );
  }
}
