import 'dart:io';
import 'dart:typed_data';

import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/booking_contracts_payments/data/data_sources/booking_contract_request_service.dart';
import 'package:MARN/features/booking_contracts_payments/domain/entities/contract_entity.dart';
import 'package:MARN/features/booking_contracts_payments/domain/repositories/booking_contract_repo.dart';
import 'package:dartz/dartz.dart';

class BookingContractRepoImpl implements BookingContractRepo {
  final BookingContractRequestService bookingRequestService;
  BookingContractRepoImpl({required this.bookingRequestService});
  @override
  Future<Either<Failure, String>> addBooking({
    required int propertyId,
    required String checkInDate,
    required String checkOutDate,
    required String paymentFrequency,
  }) async {
    try {
      var response = await bookingRequestService.addBooking(
        propertyId: propertyId,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        paymentFrequency: paymentFrequency,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> cancelBooking({
    required int bookingId,
  }) async {
    try {
      var response = await bookingRequestService.cancelBooking(
        bookingId: bookingId,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> startChat({required int bookingId}) async {
    try {
      var response = await bookingRequestService.startChat(
        bookingId: bookingId,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> cancelContract({
    required int contractId,
  }) async {
    try {
      var response = await bookingRequestService.cancelContract(
        contractId: contractId,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CreateAndSignContractEntity>> createContract({
    required int bookingRequestId,
  }) async {
    try {
      var response = await bookingRequestService.createContract(
        bookingRequestId: bookingRequestId,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CreateAndSignContractEntity>> signContract({
    required int contractId,
  }) async {
    try {
      var response = await bookingRequestService.signContract(
        contractId: contractId,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContractDetailsEntity>> getContract({
    required int contractId,
  }) async {
    try {
      var response = await bookingRequestService.getContract(
        contractId: contractId,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> getContractPdf({
    required int contractId,
  }) async {
    try {
      var response = await bookingRequestService.getContractPdf(
        contractId: contractId,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> getContractProof({
    required int contractId,
  }) async {
    try {
      var response = await bookingRequestService.getContractProof(
        contractId: contractId,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContractProofVerificationEntity>> verifyContract({
    required int contractId,
    required File file,
  }) async {
    try {
      var response = await bookingRequestService.verifyContract(
        contractId: contractId,
        file: file,
      );
      return right(response);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
