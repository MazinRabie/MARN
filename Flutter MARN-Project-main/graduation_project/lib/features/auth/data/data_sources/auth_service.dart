import 'package:MARN/features/auth/data/models/auth_user_model.dart';

abstract class AuthService {
  Future<String> register(AuthUserModel user);
  Future<String> login(AuthUserModel user);
  Future<String> confirmEmail(String userId, String token);
  Future<String> resendConfirmationEmail(String email);
  Future<String> forgotPassword(String email);
  Future<String> googleSignIn();
  Future<String> logout();
  Future<bool> checkSessionValidity();
  Future<String> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  });
  Future<String> deleteAccount();
  Future<String> loginWithTwoFactorCode({
    required String email,
    required String code,
    required bool rememberMe,
  });
}
