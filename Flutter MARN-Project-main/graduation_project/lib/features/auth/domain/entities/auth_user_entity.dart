import 'package:MARN/core/enums/models/enum_item.dart';

abstract class AuthUserEntity {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? dateOfBirth;
  final String? password;
  final String? confirmPassword;
  final EnumItem? gender;
  final bool? rememberMe;

  AuthUserEntity({
    this.firstName,
    this.lastName,
    this.email,
    this.dateOfBirth,
    this.password,
    this.confirmPassword,
    this.gender,
    this.rememberMe,
  });
}
