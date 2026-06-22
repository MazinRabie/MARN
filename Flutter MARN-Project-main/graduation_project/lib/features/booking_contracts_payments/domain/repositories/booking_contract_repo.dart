import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/booking_contracts_payments/domain/entities/contract_entity.dart';
import 'package:dartz/dartz.dart';
import 'dart:io';
import 'dart:typed_data';

abstract class BookingContractRepo {
  Future<Either<Failure, String>> addBooking({
    required int propertyId,
    required String checkInDate,
    required String checkOutDate,
    required String paymentFrequency,
  });
  Future<Either<Failure, String>> cancelBooking({required int bookingId});
  Future<Either<Failure, String>> startChat({required int bookingId});

  Future<Either<Failure, CreateAndSignContractEntity>> createContract({
    required int bookingRequestId,
  });
  Future<Either<Failure, CreateAndSignContractEntity>> signContract({
    required int contractId,
  });
  Future<Either<Failure, String>> cancelContract({required int contractId});
  Future<Either<Failure, ContractDetailsEntity>> getContract({
    required int contractId,
  });
  Future<Either<Failure, Uint8List>> getContractPdf({required int contractId});
  Future<Either<Failure, Uint8List>> getContractProof({
    required int contractId,
  });
  Future<Either<Failure, ContractProofVerificationEntity>> verifyContract({
    required int contractId,
    required File file,
  });
}
