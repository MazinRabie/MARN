import 'dart:convert';
import 'dart:io';

import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/features/profile/data/model/profile_model.dart';
import 'package:MARN/features/profile/data/data_sources/profile_service.dart';
import 'package:MARN/features/profile/data/model/profile_settings_model.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:MARN/core/localization/locale_keys.dart';

class ApiProfileService implements ProfileService {
  final ApiService apiService;
  late ProfileModel user;
  ApiProfileService({required this.apiService});

  @override
  Future<ProfileModel> getMyProfile() async {
    return await handleRequest(() async {
      var response = await apiService.get(endPoint: ApiEndPoints.profile);
      if (response.statusCode == 200) {
        user = ProfileModel.fromJson(response.data);
        await SharedPreferencesHelper.setString(
          LocalStorageVariables.user,
          jsonEncode(response.data),
        );
        await SharedPreferencesHelper.setString(
          LocalStorageVariables.userId,
          user.id,
        );
        return user;
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<ProfileModel> getMyProfileFromLocalStorage() async {
    return await handleRequest(() async {
      var response = SharedPreferencesHelper.getString(
        LocalStorageVariables.user,
      );
      if (response != null) {
        return ProfileModel.fromJson(jsonDecode(response));
      } else {
        throw ServerFailure(errorMessage: LocaleKeys.profileErrorsNoUserData.tr());
      }
    });
  }

  @override
  Future<ProfileModel> getUserProfile({required String userId}) async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: "${ApiEndPoints.profileUserId}/$userId",
      );
      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    return await handleRequest(() async {
      var user = await getMyProfileFromLocalStorage();
      var response = await apiService.put(
        endPoint: ApiEndPoints.profileChangePassword,
        body: {
          'id': user.id,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmNewPassword': newPasswordConfirmation,
        },
      );
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> toggleTwoFactorAuth({required String password}) async {
    return await handleRequest(() async {
      var response = await apiService.put(
        endPoint: ApiEndPoints.profileToggle2FA,
        body: {'password': password},
      );
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<ProfileSettingsModel> getProfileSettingsInfo() async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: ApiEndPoints.profileEditProfile,
      );
      if (response.statusCode == 200) {
        await SharedPreferencesHelper.setString(
          LocalStorageVariables.profileSettings,
          jsonEncode(response.data["data"]),
        );
        return ProfileSettingsModel.fromJson(response.data);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<ProfileSettingsModel> getProfileSettingsInfoFromLocalStorage() async {
    return await handleRequest(() async {
      var response = SharedPreferencesHelper.getString(
        LocalStorageVariables.profileSettings,
      );
      if (response != null) {
        return ProfileSettingsModel.fromJson(jsonDecode(response));
      } else {
        throw ServerFailure(errorMessage: LocaleKeys.profileErrorsNoSettingsData.tr());
      }
    });
  }

  @override
  Future<String> editBasicProfile({
    required String firstName,
    required String lastName,
    required String? phoneNumber,
    required DateTime? dateOfBirth,
    required EnumItem gender,
    required EnumItem language,
    required EnumItem country,
    required String? bio,
    required File? profileImage,
  }) async {
    return await handleRequest(() async {
      FormData formData = FormData.fromMap({
        "Id": user.id,
        "FirstName": firstName,
        "LastName": lastName,
        "PhoneNumber": phoneNumber,
        "DateOfBirth": dateOfBirth?.toIso8601String().split("T").first,
        "Gender": gender.toBackendValue(),
        "Language": language.toBackendValue(),
        "Country": country.toBackendValue(),
        "Bio": bio,

        if (profileImage != null)
          "ProfileImage": await MultipartFile.fromFile(
            profileImage.path,
            filename: profileImage.path.split('/').last,
          ),
      });
      var response = await apiService.put(
        endPoint: ApiEndPoints.profileEditProfileBasic,
        body: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> editIdentityProfile({
    required File frontIdImage,
    required File backIdImage,
    required String nationalIDNumber,
    required String arabicFullName,
    required String arabicAddress,
  }) async {
    return await handleRequest(() async {
      FormData formData = FormData.fromMap({
        "Id": user.id,
        "NationalIDNumber": nationalIDNumber,
        "ArabicFullName": arabicFullName,
        "ArabicAddress": arabicAddress,
        "FrontIdPhoto": await MultipartFile.fromFile(
          frontIdImage.path,
          filename: frontIdImage.path.split('/').last,
        ),
        "BackIdPhoto": await MultipartFile.fromFile(
          backIdImage.path,
          filename: backIdImage.path.split('/').last,
        ),
      });
      var response = await apiService.put(
        endPoint: ApiEndPoints.profileEditProfileLegal,
        body: formData,
        headers: {"Content-Type": "multipart/form-data"},
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> editProfileRoommatePreferences({
    required bool roommatePreferencesEnabled,
    required bool? smoking,
    required bool? pets,
    required EnumItem? sleepSchedule,
    required EnumItem? educationLevel,
    required EnumItem? fieldOfStudy,
    required int? noiseTolerance,
    required EnumItem? guestsFrequency,
    required EnumItem? workSchedule,
    required EnumItem? sharingLevel,
    required num? budgetRangeMin,
    required num? budgetRangeMax,
    required int? smokingImportance,
    required int? petsImportance,
    required int? sleepImportance,
    required int? educationImportance,
    required int? fieldOfStudyImportance,
    required int? noiseToleranceImportance,
    required int? guestsFrequencyImportance,
    required int? workScheduleImportance,
    required int? sharingLevelImportance,
    required int? budgetImportance,
  }) async {
    return await handleRequest(() async {
      var response = await apiService.put(
        endPoint: ApiEndPoints.profileEditProfileRoommatePreferences,
        body: {
          "userId": user.id,
          "RoommatePreferencesEnabled": roommatePreferencesEnabled,
          "smoking": smoking,
          "pets": pets,
          "sleepSchedule": sleepSchedule?.toBackendValue(),
          "educationLevel": educationLevel?.toBackendValue(),
          "fieldOfStudy": fieldOfStudy?.toBackendValue(),
          "noiseTolerance": noiseTolerance,
          "guestsFrequency": guestsFrequency?.toBackendValue(),
          "workSchedule": workSchedule?.toBackendValue(),
          "sharingLevel": sharingLevel?.toBackendValue(),
          "budgetRangeMin": budgetRangeMin,
          "budgetRangeMax": budgetRangeMax,
          "smokingImportance": smokingImportance,
          "petsImportance": petsImportance,
          "sleepImportance": sleepImportance,
          "educationImportance": educationImportance,
          "fieldOfStudyImportance": fieldOfStudyImportance,
          "noiseToleranceImportance": noiseToleranceImportance,
          "guestsFrequencyImportance": guestsFrequencyImportance,
          "workScheduleImportance": workScheduleImportance,
          "sharingLevelImportance": sharingLevelImportance,
          "budgetImportance": budgetImportance,
        },
      );
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }
}
