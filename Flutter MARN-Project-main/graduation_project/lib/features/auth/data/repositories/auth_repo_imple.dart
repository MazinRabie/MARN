import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/auth/data/data_sources/auth_service.dart';
import 'package:MARN/features/auth/data/models/auth_user_model.dart';
import 'package:MARN/features/auth/domain/repositories/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthService authService;
  AuthRepoImpl({required this.authService});
  @override
  Future<Either<Failure, String>> register(
    String firstName,
    String lastName,
    String email,
    String dateOfBirth,
    String password,
    String confirmPassword,
    EnumItem gender,
  ) async {
    try {
      var response = await authService.register(
        AuthUserModel(
          firstName: firstName,
          lastName: lastName,
          email: email,
          dateOfBirth: dateOfBirth,
          password: password,
          confirmPassword: confirmPassword,
          gender: gender,
        ),
      );
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> login(
    String email,
    String password,
    bool rememberMe,
  ) async {
    try {
      var response = await authService.login(
        AuthUserModel(email: email, password: password, rememberMe: rememberMe),
      );
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resendConfirmationEmail(String email) async {
    try {
      var response = await authService.resendConfirmationEmail(email);
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      var response = await authService.forgotPassword(email);
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> confirmEmail(
    String userId,
    String token,
  ) async {
    try {
      var response = await authService.confirmEmail(userId, token);
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> googleSignIn() async {
    try {
      var response = await authService.googleSignIn();
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkSessionValidity() async {
    try {
      var response = await authService.checkSessionValidity();
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      var response = await authService.resetPassword(
        email: email,
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      var response = await authService.logout();
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount() async {
    try {
      var response = await authService.deleteAccount();
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginWithTwoFactorCode({
    required String email,
    required String code,
    required bool rememberMe,
  }) async {
    try {
      var response = await authService.loginWithTwoFactorCode(
        email: email,
        code: code,
        rememberMe: rememberMe,
      );
      return right(response);
    } catch (e) {
      if (e is Failure) {
        return left(e);
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
