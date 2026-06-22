import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/theme/app_colors.dart';
import 'package:MARN/core/widgets/build_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/features/auth/domain/repositories/auth_repo.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  final AuthRepo authRepo;

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String dateOfBirth,
    required String password,
    required String confirmPassword,
    required EnumItem gender,
  }) async {
    emit(AuthLoading());
    var result = await authRepo.register(
      firstName,
      lastName,
      email,
      dateOfBirth,
      password,
      confirmPassword,
      gender,
    );
    result.fold(
      (failure) {
        emit(AuthError(errorMessage: failure.errorMessage));
      },
      (response) {
        emit(RegisterSuccess(response: response));
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
    required BuildContext context,
  }) async {
    emit(AuthLoading());
    var result = await authRepo.login(email, password, rememberMe);
    result.fold(
      (failure) {
        if (failure.action == "ResendEmailConfirmation") {
          emit(StopLoading());
          buildSnackBar(
            context,
            message:
                LocaleKeys.authSnackbarCheckEmailToConfirm.tr(),
            actionText: LocaleKeys.authSnackbarResendAction.tr(),
            duration: const Duration(seconds: 5),
            icon: Icons.info_outline,
            bgColor: AppColors.primary,
            actionOnPressed: () async {
              emit(AuthLoading());
              var result = await authRepo.resendConfirmationEmail(email);
              result.fold(
                (failure) {
                  emit(AuthError(errorMessage: failure.errorMessage));
                },
                (response) {
                  emit(ResendConfirmationEmailSuccess(response: response));
                },
              );
            },
          );
        } else if (failure.action == "login_with_two_factor_code") {
          emit(StopLoading());
          emit(
            TwoFactorAuthenticationRequired(
              email: email,
              errorMessage: failure.errorMessage,
              password: password,
              rememberMe: rememberMe,
            ),
          );
        } else {
          emit(AuthError(errorMessage: failure.errorMessage));
        }
      },
      (response) {
        emit(LoginSuccess(response: response));
      },
    );
  }

  Future<void> forgotPassword({required String email}) async {
    emit(AuthLoading());
    var result = await authRepo.forgotPassword(email);
    result.fold(
      (failure) {
        emit(AuthError(errorMessage: failure.errorMessage));
      },
      (response) {
        emit(ForgotPasswordSuccess(response: response));
      },
    );
  }

  Future<void> confirmEmail({
    required String userId,
    required String token,
  }) async {
    emit(AuthLoading());
    var result = await authRepo.confirmEmail(userId, token);
    result.fold(
      (failure) {
        emit(AuthError(errorMessage: failure.errorMessage));
      },
      (response) {
        emit(ConfirmEmailSuccess(response: response));
      },
    );
  }

  Future<void> googleSignIn() async {
    emit(AuthLoading());
    var result = await authRepo.googleSignIn();
    result.fold(
      (failure) {
        emit(AuthError(errorMessage: failure.errorMessage));
      },
      (response) {
        emit(GoogleSignInSuccess(response: response));
      },
    );
  }

  Future<void> checkSessionValidity() async {
    emit(AuthLoading());
    var result = await authRepo.checkSessionValidity();
    result.fold(
      (failure) {
        emit(AuthError(errorMessage: failure.errorMessage));
      },
      (response) {
        emit(CheckSessionValiditySuccess(isValid: response));
      },
    );
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    var result = await authRepo.resetPassword(
      email: email,
      token: token,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    result.fold(
      (failure) {
        emit(AuthError(errorMessage: failure.errorMessage));
      },
      (response) {
        emit(ResetPasswordSuccess(response: response));
      },
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    var result = await authRepo.logout();
    result.fold(
      (failure) {
        emit(AuthError(errorMessage: failure.errorMessage));
      },
      (response) {
        emit(LogoutSuccess(response: response));
      },
    );
  }

  Future<void> deleteAccount() async {
    emit(AuthLoading());
    var result = await authRepo.deleteAccount();
    result.fold(
      (failure) {
        emit(AuthError(errorMessage: failure.errorMessage));
      },
      (response) {
        emit(DeleteAccountSuccess(response: response));
      },
    );
  }

  Future<void> loginWithTwoFactorCode({
    required String email,
    required String code,
    required bool rememberMe,
  }) async {
    emit(AuthLoading());
    var result = await authRepo.loginWithTwoFactorCode(
      email: email,
      code: code,
      rememberMe: rememberMe,
    );
    result.fold(
      (failure) {
        emit(AuthError(errorMessage: failure.errorMessage));
      },
      (response) {
        emit(LoginSuccess(response: response));
      },
    );
  }
}
