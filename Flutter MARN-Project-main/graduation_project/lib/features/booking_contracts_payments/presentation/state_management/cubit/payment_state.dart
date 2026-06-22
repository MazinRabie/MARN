abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String message;
  PaymentSuccess({required this.message});
}

class ConnectSuccess extends PaymentState {
  final String url;
  ConnectSuccess({required this.url});
}

class WithdrawSuccess extends PaymentState {
  final String message;
  WithdrawSuccess({required this.message});
}

class PaymentFailure extends PaymentState {
  final String errorMessage;
  PaymentFailure({required this.errorMessage});
}
