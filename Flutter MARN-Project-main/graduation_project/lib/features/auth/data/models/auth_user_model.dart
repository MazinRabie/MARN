import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/features/auth/domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  bool? requiresTwoFactor;
  String? twoFactorProvider;
  bool? isExternalLogin;
  String? externalProvider;
  final String? token;
  String? expiration;

  AuthUserModel({
    super.firstName = "",
    super.lastName = "",
    super.email = "",
    super.dateOfBirth = "",
    super.password = "",
    super.confirmPassword = "",
    super.gender = EnumItem.empty,
    super.rememberMe = false,
    this.token = "",
    this.expiration = "",
    this.requiresTwoFactor = false,
    this.twoFactorProvider = "",
    this.isExternalLogin = false,
    this.externalProvider = "",
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
      email: json['email'] ?? "",
      dateOfBirth: json['dateOfBirth'] ?? "",
      password: json['password'] ?? "",
      confirmPassword: json['confirmPassword'] ?? "",
      gender: EnumItem.resolve(EnumType.gender, json['gender']),
      rememberMe: json['rememberMe'] ?? false,
      token: json['data']['token'] ?? "",
      expiration: json['data']['expiration'] ?? "",
      requiresTwoFactor: json['data']['requiresTwoFactor'] ?? false,
      twoFactorProvider: json['data']['twoFactorProvider'] ?? "",
      isExternalLogin: json['data']['isExternalLogin'] ?? false,
      externalProvider: json['data']['externalProvider'] ?? "",
    );
  }

  Map<String, dynamic> toJsonRegister() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dateOfBirth': convertArabicToEnglishNumbers(dateOfBirth!),
      'password': password,
      'confirmPassword': confirmPassword,
      'gender': gender?.toBackendValue(),
    };
  }

  Map<String, dynamic> toJsonLogin() {
    return {'email': email, 'password': password, 'rememberMe': rememberMe};
  }
}

String convertArabicToEnglishNumbers(String input) {
  const arabicNumbers = '٠١٢٣٤٥٦٧٨٩';
  const englishNumbers = '0123456789';

  for (int i = 0; i < arabicNumbers.length; i++) {
    input = input.replaceAll(arabicNumbers[i], englishNumbers[i]);
  }

  return input;
}
