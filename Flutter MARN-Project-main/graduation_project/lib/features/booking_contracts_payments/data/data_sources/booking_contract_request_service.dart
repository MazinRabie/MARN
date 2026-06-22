import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:MARN/features/booking_contracts_payments/domain/entities/contract_entity.dart';

abstract class BookingContractRequestService {
  Future<String> addBooking({
    required int propertyId,
    required String checkInDate,
    required String checkOutDate,
    required String paymentFrequency,
  });
  Future<String> startChat({required int bookingId});
  Future<String> cancelBooking({required int bookingId});

  // contracts
  Future<CreateAndSignContractEntity> createContract({
    required int bookingRequestId,
  });
  Future<CreateAndSignContractEntity> signContract({required int contractId});
  Future<String> cancelContract({required int contractId});
  Future<ContractDetailsEntity> getContract({required int contractId});
  Future<Uint8List> getContractPdf({required int contractId});
  Future<Uint8List> getContractProof({required int contractId});
  Future<ContractProofVerificationEntity> verifyContract({
    required int contractId,
    required File file,
  });
}
