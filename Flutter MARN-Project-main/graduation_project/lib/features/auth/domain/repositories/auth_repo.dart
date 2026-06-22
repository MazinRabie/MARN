import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, String>> register(
    String firstName,
    String lastName,
    String email,
    String dateOfBirth,
    String password,
    String confirmPassword,
    EnumItem gender,
  );
  Future<Either<Failure, String>> login(
    String email,
    String password,
    bool rememberMe,
  );

  Future<Either<Failure, String>> resendConfirmationEmail(String email);

  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, String>> confirmEmail(String userId, String token);

  Future<Either<Failure, String>> googleSignIn();

  Future<Either<Failure, String>> logout();

  Future<Either<Failure, bool>> checkSessionValidity();

  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Either<Failure, String>> deleteAccount();

  Future<Either<Failure, String>> loginWithTwoFactorCode({
    required String email,
    required String code,
    required bool rememberMe,
  });
}
