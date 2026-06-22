part of 'booking_contract_cubit.dart';

@immutable
sealed class BookingContractState {}

final class BookingInitial extends BookingContractState {}

final class CreateBookingLoading extends BookingContractState {}

final class CreateBookingSuccess extends BookingContractState {
  final String message;
  CreateBookingSuccess({required this.message});
}

final class CreateBookingFailure extends BookingContractState {
  final String errorMessage;
  CreateBookingFailure({required this.errorMessage});
}

final class CancelBookingLoading extends BookingContractState {}

final class CancelBookingSuccess extends BookingContractState {
  final String message;
  CancelBookingSuccess({required this.message});
}

final class CancelBookingFailure extends BookingContractState {
  final String errorMessage;
  CancelBookingFailure({required this.errorMessage});
}

final class StartChatLoading extends BookingContractState {}

final class StartChatSuccess extends BookingContractState {
  final String chatUserId;
  final String message;
  StartChatSuccess({required this.message, required this.chatUserId});
}

final class StartChatFailure extends BookingContractState {
  final String errorMessage;
  StartChatFailure({required this.errorMessage});
}

final class CreateContractLoading extends BookingContractState {}

final class CreateContractSuccess extends BookingContractState {
  final CreateAndSignContractEntity contract;
  CreateContractSuccess({required this.contract});
}

final class CreateContractFailure extends BookingContractState {
  final String errorMessage;
  CreateContractFailure({required this.errorMessage});
}

final class SignContractLoading extends BookingContractState {}

final class SignContractSuccess extends BookingContractState {
  final CreateAndSignContractEntity contract;
  SignContractSuccess({required this.contract});
}

final class SignContractFailure extends BookingContractState {
  final String errorMessage;
  SignContractFailure({required this.errorMessage});
}

final class CancelContractLoading extends BookingContractState {}

final class CancelContractSuccess extends BookingContractState {
  final String message;
  CancelContractSuccess({required this.message});
}

final class CancelContractFailure extends BookingContractState {
  final String errorMessage;
  CancelContractFailure({required this.errorMessage});
}

final class GetContractLoading extends BookingContractState {}

final class GetContractSuccess extends BookingContractState {
  final ContractDetailsEntity contract;
  GetContractSuccess({required this.contract});
}

final class GetContractFailure extends BookingContractState {
  final String errorMessage;
  GetContractFailure({required this.errorMessage});
}

final class GetContractPdfLoading extends BookingContractState {}

final class GetContractPdfSuccess extends BookingContractState {}

final class GetContractPdfFailure extends BookingContractState {
  final String errorMessage;
  GetContractPdfFailure({required this.errorMessage});
}

final class GetContractProofLoading extends BookingContractState {}

final class GetContractProofSuccess extends BookingContractState {}

final class GetContractProofFailure extends BookingContractState {
  final String errorMessage;
  GetContractProofFailure({required this.errorMessage});
}

final class VerifyContractLoading extends BookingContractState {}

final class VerifyContractSuccess extends BookingContractState {
  final ContractProofVerificationEntity contract;
  VerifyContractSuccess({required this.contract});
}

final class VerifyContractFailure extends BookingContractState {
  final String errorMessage;
  VerifyContractFailure({required this.errorMessage});
}
