import 'dart:io';
import 'dart:typed_data';
import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/features/booking_contracts_payments/data/data_sources/booking_contract_request_service.dart';
import 'package:MARN/features/booking_contracts_payments/data/models/contract_model.dart';
import 'package:MARN/features/booking_contracts_payments/domain/entities/contract_entity.dart';
import 'package:dio/dio.dart';

class ApiBookingContractRequestService
    implements BookingContractRequestService {
  ApiBookingContractRequestService({required this.apiService});

  final ApiService apiService;

  @override
  Future<String> addBooking({
    required int propertyId,
    required String checkInDate,
    required String checkOutDate,
    required String paymentFrequency,
  }) async {
    return await handleRequest(() async {
      final response = await apiService.post(
        endPoint: ApiEndPoints.bookingRequestAdd,
        body: {
          'propertyId': propertyId,
          'startDate': checkInDate,
          'endDate': checkOutDate,
          'paymentFrequency': paymentFrequency,
        },
      );
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> cancelBooking({required int bookingId}) async {
    return await handleRequest(() async {
      final response = await apiService.delete(
        endPoint: '${ApiEndPoints.bookingRequestCancel}/$bookingId',
      );
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> startChat({required int bookingId}) async {
    return await handleRequest(() async {
      final response = await apiService.post(
        endPoint:
            '${ApiEndPoints.bookingRequestStartChat}/$bookingId/start-chat',
      );
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<CreateAndSignContractModel> createContract({
    required int bookingRequestId,
  }) async {
    return await handleRequest(() async {
      final response = await apiService.post(
        endPoint: '${ApiEndPoints.contractCreate}/$bookingRequestId',
      );
      if (response.statusCode == 201) {
        return CreateAndSignContractModel.fromJson(response.data);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<CreateAndSignContractModel> signContract({
    required int contractId,
  }) async {
    return await handleRequest(() async {
      final response = await apiService.post(
        endPoint: '${ApiEndPoints.contractSign}/$contractId/sign',
      );
      if (response.statusCode == 200) {
        return CreateAndSignContractModel.fromJson(response.data);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> cancelContract({required int contractId}) async {
    return await handleRequest(() async {
      final response = await apiService.delete(
        endPoint: '${ApiEndPoints.contractCancel}/$contractId',
      );
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<ContractDetailsEntity> getContract({required int contractId}) async {
    return await handleRequest(() async {
      final response = await apiService.get(
        endPoint: '${ApiEndPoints.contract}/$contractId',
      );
      if (response.statusCode == 200) {
        return ContractDetailsModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<Uint8List> getContractPdf({required int contractId}) async {
    return await handleRequest(() async {
      final response = await apiService.get(
        endPoint: '${ApiEndPoints.contractPdf}/$contractId/download',
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        final contract = Uint8List.fromList(response.data);
        return contract;
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<Uint8List> getContractProof({required int contractId}) async {
    return await handleRequest(() async {
      final response = await apiService.get(
        endPoint: '${ApiEndPoints.contractProof}/$contractId/proof',
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        final proof = Uint8List.fromList(response.data);
        return proof;
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<ContractProofVerificationEntity> verifyContract({
    required int contractId,
    required File file,
  }) async {
    return await handleRequest(() async {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });
      final response = await apiService.post(
        endPoint: '${ApiEndPoints.contractVerify}?contractId=$contractId',
        body: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );
      if (response.statusCode == 200) {
        return ContractProofVerificationModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }
}
