import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class Failure {
  final String _errorMessage;
  final List<dynamic>? _errors;
  final String? action;

  Failure({required String errorMessage, List<dynamic>? errors, this.action})
    : _errorMessage = errorMessage,
      _errors = errors;

  /// Public unified message (only exposed field)
  String get errorMessage {
    if (_errors != null && _errors.isNotEmpty) {
      return _errors.first.toString();
    }
    return _errorMessage;
  }
}

class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage, super.action, super.errors});

  @override
  String toString() {
    return 'ServerFailure(message: $errorMessage, action: $action)';
  }

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          errorMessage: LocaleKeys.apiErrorsConnectionTimeout.tr(),
        );

      case DioExceptionType.sendTimeout:
        return ServerFailure(
          errorMessage: LocaleKeys.apiErrorsSendTimeout.tr(),
        );

      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          errorMessage: LocaleKeys.apiErrorsReceiveTimeout.tr(),
        );

      case DioExceptionType.badCertificate:
        return ServerFailure(
          errorMessage: LocaleKeys.apiErrorsBadCertificate.tr(),
        );

      case DioExceptionType.badResponse:
        final response = dioException.response;
        if (response != null && response.data != null) {
          return ServerFailure.fromResponse(
            response.statusCode ?? 0,
            response.data,
          );
        } else {
          return ServerFailure(
            errorMessage: LocaleKeys.apiErrorsNoResponse.tr(),
          );
        }

      case DioExceptionType.cancel:
        return ServerFailure(
          errorMessage: LocaleKeys.apiErrorsRequestCancelled.tr(),
        );

      case DioExceptionType.connectionError:
        return ServerFailure(errorMessage: LocaleKeys.apiErrorsNoInternet.tr());

      case DioExceptionType.unknown:
        return ServerFailure(
          errorMessage: LocaleKeys.apiErrorsUnexpectedError.tr(),
        );
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final errors = responseData['errors'] is List
          ? responseData['errors']
          : responseData['errors'] is Map
          ? (responseData['errors'] as Map<String, dynamic>).values
                .expand((e) => e is List ? e : [e])
                .toList()
          : [];

      final action = responseData['action'] is String
          ? responseData['action']
          : null;

      final message = responseData['message'] is String
          ? responseData['message']
          : errors.isNotEmpty
          ? errors.first.toString()
          : responseData['title'] is String
          ? responseData['title']
          : LocaleKeys.apiErrorsUnexpectedError.tr();

      if (statusCode == 400 ||
          statusCode == 401 ||
          statusCode == 403 ||
          statusCode == 404 ||
          statusCode == 409) {
        return ServerFailure(
          errorMessage: message,
          errors: errors,
          action: action,
        );
      }
    }
    final action = "";
    final errors = [];
    if (statusCode == 404) {
      return ServerFailure(
        errorMessage: LocaleKeys.apiErrorsRequestNotFound.tr(),
        errors: errors,
        action: action,
      );
      // } else if (statusCode == 409) {
      //   return ServerFailure(
      //     errorMessage: 'Rate limit exceeded, please try again later',
      //     errors: errors,
      //     action: action,
      //   );
    } else if (statusCode == 500) {
      return ServerFailure(
        errorMessage: LocaleKeys.apiErrorsServerError.tr(),
        errors: errors,
        action: action,
      );
    } else if (statusCode == 503) {
      return ServerFailure(
        errorMessage: LocaleKeys.apiErrorsServerUpdate.tr(),
        errors: errors,
        action: action,
      );
    } else {
      return ServerFailure(
        errorMessage: LocaleKeys.apiErrorsUnexpectedFailure.tr(),
        errors: errors,
        action: action,
      );
    }
  }
}

Future<T> handleRequest<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on ServerFailure {
    rethrow;
  } on DioException catch (e) {
    throw ServerFailure.fromDioException(e);
  } catch (e) {
    throw ServerFailure(errorMessage: e.toString());
  }
}
