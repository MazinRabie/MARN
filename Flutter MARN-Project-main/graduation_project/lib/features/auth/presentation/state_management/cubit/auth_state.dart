part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class StopLoading extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;
  AuthError({required this.errorMessage});
}

final class RegisterSuccess extends AuthState {
  final String response;
  RegisterSuccess({required this.response});
}

final class LoginSuccess extends AuthState {
  final String response;
  LoginSuccess({required this.response});
}

final class ResendConfirmationEmailSuccess extends AuthState {
  final String response;
  ResendConfirmationEmailSuccess({required this.response});
}

final class ForgotPasswordSuccess extends AuthState {
  final String response;
  ForgotPasswordSuccess({required this.response});
}

final class ConfirmEmailSuccess extends AuthState {
  final String response;
  ConfirmEmailSuccess({required this.response});
}

final class GoogleSignInSuccess extends AuthState {
  final String response;
  GoogleSignInSuccess({required this.response});
}

final class CheckSessionValiditySuccess extends AuthState {
  final bool isValid;
  CheckSessionValiditySuccess({required this.isValid});
}

final class ResetPasswordSuccess extends AuthState {
  final String response;
  ResetPasswordSuccess({required this.response});
}

final class LogoutSuccess extends AuthState {
  final String response;
  LogoutSuccess({required this.response});
}

final class DeleteAccountSuccess extends AuthState {
  final String response;
  DeleteAccountSuccess({required this.response});
}

final class TwoFactorAuthenticationRequired extends AuthState {
  final String errorMessage;
  final String email;
  final String password;
  final bool rememberMe;
  TwoFactorAuthenticationRequired({
    required this.errorMessage,
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}
