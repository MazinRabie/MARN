import 'dart:convert';
import 'package:MARN/core/enums/models/enum_response.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';

/// Cache manager for enum data
/// Uses SharedPreferences for storage (replaceable with Hive/Isar later)
class EnumCacheManager {
  static const String _cacheVersionKey = 'enum_cache_version';
  static const String _cacheDataKeyAr = 'enums_ar';
  static const String _cacheDataKeyEn = 'enums_en';
  static const int _currentCacheVersion = 1;

  /// Save enum data for a specific language
  static Future<bool> saveEnums(String language, EnumResponse enumResponse) async {
    try {
      final cacheKey = language == 'ar' ? _cacheDataKeyAr : _cacheDataKeyEn;
      final jsonString = jsonEncode(enumResponse.toJson());
      
      await SharedPreferencesHelper.setString(cacheKey, jsonString);
      await SharedPreferencesHelper.setInt(_cacheVersionKey, _currentCacheVersion);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Load enum data for a specific language
  static Future<EnumResponse?> loadEnums(String language) async {
    try {
      final cacheKey = language == 'ar' ? _cacheDataKeyAr : _cacheDataKeyEn;
      final jsonString = await SharedPreferencesHelper.getString(cacheKey);
      
      if (jsonString == null) return null;
      
      final version = await SharedPreferencesHelper.getInt(_cacheVersionKey);
      if (version != _currentCacheVersion) {
        // Cache version mismatch, invalidate
        await clearEnums();
        return null;
      }
      
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return EnumResponse.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  /// Clear all cached enum data
  static Future<void> clearEnums() async {
    await SharedPreferencesHelper.remove(_cacheDataKeyAr);
    await SharedPreferencesHelper.remove(_cacheDataKeyEn);
    await SharedPreferencesHelper.remove(_cacheVersionKey);
  }

  /// Check if cached data exists for a language
  static Future<bool> hasCachedEnums(String language) async {
    final cacheKey = language == 'ar' ? _cacheDataKeyAr : _cacheDataKeyEn;
    final jsonString = await SharedPreferencesHelper.getString(cacheKey);
    return jsonString != null;
  }

  /// Get cache timestamp (optional, for cache expiry logic)
  static Future<DateTime?> getCacheTimestamp(String language) async {
    // Implement if needed for cache expiry
    return null;
  }
}
