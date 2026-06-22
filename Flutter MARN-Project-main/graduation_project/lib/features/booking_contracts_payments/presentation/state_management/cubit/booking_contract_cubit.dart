import 'dart:io';
import 'dart:typed_data';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/booking_contracts_payments/domain/entities/contract_entity.dart';
import 'package:MARN/features/booking_contracts_payments/domain/repositories/booking_contract_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' hide OpenFile;
import 'package:meta/meta.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

part 'booking_contract_state.dart';

class BookingContractCubit extends Cubit<BookingContractState> {
  final BookingContractRepo bookingRepo;
  BookingContractCubit({required this.bookingRepo}) : super(BookingInitial());
  Future<void> addBooking({
    required int propertyId,
    required String checkInDate,
    required String checkOutDate,
    required EnumItem paymentFrequency,
  }) async {
    emit(CreateBookingLoading());
    Either<Failure, String> response = await bookingRepo.addBooking(
      propertyId: propertyId,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      paymentFrequency: paymentFrequency.name,
    );
    response.fold(
      (failure) =>
          emit(CreateBookingFailure(errorMessage: failure.errorMessage)),
      (message) => emit(CreateBookingSuccess(message: message)),
    );
  }

  Future<void> cancelBooking({required int bookingId}) async {
    emit(CancelBookingLoading());
    Either<Failure, String> response = await bookingRepo.cancelBooking(
      bookingId: bookingId,
    );
    response.fold(
      (failure) =>
          emit(CancelBookingFailure(errorMessage: failure.errorMessage)),
      (message) => emit(CancelBookingSuccess(message: message)),
    );
  }

  Future<void> startChat({
    required int bookingId,
    required String chatUserId,
  }) async {
    emit(StartChatLoading());
    Either<Failure, String> response = await bookingRepo.startChat(
      bookingId: bookingId,
    );
    response.fold(
      (failure) => emit(StartChatFailure(errorMessage: failure.errorMessage)),
      (message) =>
          emit(StartChatSuccess(message: message, chatUserId: chatUserId)),
    );
  }

  Future<void> createContract({required int bookingRequestId}) async {
    emit(CreateContractLoading());
    Either<Failure, CreateAndSignContractEntity> response = await bookingRepo
        .createContract(bookingRequestId: bookingRequestId);
    response.fold(
      (failure) =>
          emit(CreateContractFailure(errorMessage: failure.errorMessage)),
      (contract) => emit(CreateContractSuccess(contract: contract)),
    );
  }

  Future<void> signContract({required int contractId}) async {
    emit(SignContractLoading());
    Either<Failure, CreateAndSignContractEntity> response = await bookingRepo
        .signContract(contractId: contractId);
    response.fold(
      (failure) =>
          emit(SignContractFailure(errorMessage: failure.errorMessage)),
      (contract) => emit(SignContractSuccess(contract: contract)),
    );
  }

  Future<void> cancelContract({required int contractId}) async {
    emit(CancelContractLoading());
    Either<Failure, String> response = await bookingRepo.cancelContract(
      contractId: contractId,
    );
    response.fold(
      (failure) =>
          emit(CancelContractFailure(errorMessage: failure.errorMessage)),
      (message) => emit(CancelContractSuccess(message: message)),
    );
  }

  Future<void> getContract({required int contractId}) async {
    emit(GetContractLoading());
    Either<Failure, ContractDetailsEntity> response = await bookingRepo
        .getContract(contractId: contractId);
    response.fold(
      (failure) => emit(GetContractFailure(errorMessage: failure.errorMessage)),
      (contract) => emit(GetContractSuccess(contract: contract)),
    );
  }

  Future<void> getContractPdf({required int contractId}) async {
    emit(GetContractPdfLoading());
    var response = await bookingRepo.getContractPdf(contractId: contractId);
    response.fold(
      (failure) =>
          emit(GetContractPdfFailure(errorMessage: failure.errorMessage)),
      (pdf) async {
        await saveAndOpenFile(pdf, "Contract_$contractId.pdf");
        return emit(GetContractPdfSuccess());
      },
    );
  }

  Future<void> getContractProof({required int contractId}) async {
    emit(GetContractProofLoading());
    var response = await bookingRepo.getContractProof(contractId: contractId);
    response.fold(
      (failure) =>
          emit(GetContractProofFailure(errorMessage: failure.errorMessage)),
      (proof) async {
        await saveAndOpenFile(proof, "Contract_$contractId.ots");
        return emit(GetContractProofSuccess());
      },
    );
  }

  Future<void> verifyContract({
    required int contractId,
    required File file,
  }) async {
    emit(VerifyContractLoading());
    Either<Failure, ContractProofVerificationEntity> response =
        await bookingRepo.verifyContract(contractId: contractId, file: file);
    response.fold(
      (failure) =>
          emit(VerifyContractFailure(errorMessage: failure.errorMessage)),
      (contract) => emit(VerifyContractSuccess(contract: contract)),
    );
  }

  Future<void> saveAndOpenFile(Uint8List bytes, String fileName) async {
    final dir = await getTemporaryDirectory();

    final file = File('${dir.path}/$fileName');

    await file.writeAsBytes(bytes);

    final result = await OpenFile.open(file.path);

    if (result.type != ResultType.done) {
      throw Exception(result.message);
    }
  }
}
