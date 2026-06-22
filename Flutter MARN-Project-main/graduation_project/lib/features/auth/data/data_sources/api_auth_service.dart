import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/core/utilities/api_keys.dart';
import 'package:MARN/features/auth/data/data_sources/auth_service.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/features/auth/data/models/auth_user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MARN/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class ApiAuthService implements AuthService {
  final ApiService apiService;

  ApiAuthService({required this.apiService});

  @override
  Future<String> register(AuthUserModel user) async {
    return await handleRequest(() async {
      var response = await apiService.post(
        endPoint: ApiEndPoints.register,
        body: user.toJsonRegister(),
      );
      if (response.statusCode == 201) {
        return response.data["message"] ??
            LocaleKeys.authSuccessRegistration.tr();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> login(AuthUserModel user) async {
    return await handleRequest(() async {
      var response = await apiService.post(
        endPoint: ApiEndPoints.login,
        body: user.toJsonLogin(),
      );

      if (response.statusCode == 200) {
        AuthUserModel user = AuthUserModel.fromJson(response.data);
        saveLocalData(user.token!, user.expiration!);
        return response.data["message"] ?? LocaleKeys.authSuccessLogin.tr();
      } else if (response.statusCode == 202) {
        throw ServerFailure(
          errorMessage: LocaleKeys.authErrorsTwoFactorRequired.tr(),
          action: "login_with_two_factor_code",
        );
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> loginWithTwoFactorCode({
    required String email,
    required String code,
    required bool rememberMe,
  }) async {
    return await handleRequest(() async {
      var response = await apiService.post(
        endPoint: ApiEndPoints.verify2FA,
        body: {"email": email, "code": code, "rememberMe": rememberMe},
      );
      if (response.statusCode == 200) {
        AuthUserModel user = AuthUserModel.fromJson(response.data);
        saveLocalData(user.token!, user.expiration!);
        return response.data["message"] ?? LocaleKeys.authSuccessLogin.tr();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> resendConfirmationEmail(String email) async {
    return await handleRequest(() async {
      var response = await apiService.post(
        endPoint: ApiEndPoints.resendConfirmationEmail,
        body: {"email": email},
      );

      if (response.statusCode == 200) {
        return response.data["message"] ??
            LocaleKeys.authSuccessResendConfirmation.tr();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> forgotPassword(String email) async {
    return await handleRequest(() async {
      var response = await apiService.post(
        endPoint: ApiEndPoints.forgotPassword,
        body: {"email": email},
      );

      if (response.statusCode == 200) {
        return response.data["message"] ??
            LocaleKeys.authSuccessPasswordResetEmailSent.tr();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> confirmEmail(String userId, String token) async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: ApiEndPoints.confirmEmail,
        queryParameters: {"userId": userId, "token": token},
      );

      if (response.statusCode == 200) {
        return response.data["message"] ??
            LocaleKeys.authSuccessEmailConfirmed.tr();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    return await handleRequest(() async {
      await googleSignIn.initialize(serverClientId: ApiKeys.googleClientId);

      try {
        final account = await googleSignIn.authenticate();
        final auth = account.authentication;
        final idToken = auth.idToken;

        if (idToken == null) {
          throw ServerFailure(
            errorMessage: LocaleKeys.authErrorsGoogleSignInFailed.tr(),
          );
        }

        final response = await apiService.post(
          endPoint: ApiEndPoints.googleLogin,
          body: {"idToken": idToken},
        );

        if (response.statusCode == 200) {
          AuthUserModel user = AuthUserModel.fromJson(response.data);
          saveLocalData(user.token!, user.expiration!);
          return response.data["message"] ??
              LocaleKeys.authSuccessGoogleSignIn.tr();
        } else {
          throw ServerFailure.fromResponse(response.statusCode!, response.data);
        }
      } catch (e) {
        throw ServerFailure(
          errorMessage: LocaleKeys.authErrorsGoogleSignInCancelled.tr(),
        );
      }
    });
  }

  @override
  Future<String> logout() async {
    return await handleRequest(() async {
      deleteLocalData();
      return LocaleKeys.authSuccessLoggedOut.tr();
    });
  }

  @override
  Future<String> deleteAccount() async {
    return await handleRequest(() async {
      var response = await apiService.delete(
        endPoint: ApiEndPoints.profileDeleteProfile,
      );
      if (response.statusCode == 200) {
        deleteLocalData();
        return response.data["message"] ??
            LocaleKeys.authSuccessAccountDeleted.tr();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<bool> checkSessionValidity() async {
    return await handleRequest(() async {
      final expiration = SharedPreferencesHelper.getString(
        LocalStorageVariables.expiration,
      );
      if (expiration != null &&
          DateTime.now().isAfter(
            DateTime.parse(expiration).subtract(const Duration(hours: 8)),
          )) {
        await logout();
        return false;
      }
      final token = SharedPreferencesHelper.getString(
        LocalStorageVariables.token,
      );

      if (token == null) {
        await logout();
        return false;
      }
      //
      return true;
    });
  }

  @override
  Future<String> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await handleRequest(() async {
      var response = await apiService.put(
        endPoint: ApiEndPoints.resetPassword,
        body: {
          "email": email,
          "token": token,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        return response.data["message"] ??
            LocaleKeys.authSuccessPasswordReset.tr();
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }
}
