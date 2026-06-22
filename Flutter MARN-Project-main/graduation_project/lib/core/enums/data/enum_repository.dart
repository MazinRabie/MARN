import 'package:MARN/core/enums/data/enum_cache_manager.dart';
import 'package:MARN/core/enums/models/enum_response.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

/// Repository for enum data management
/// Handles API calls, caching, and offline support
class EnumRepository {
  final ApiService _apiService;

  EnumRepository(this._apiService);

  /// Fetch all enums from API
  /// Returns cached data if available and offline
  Future<Either<Failure, EnumResponse>> fetchEnums({
    String language = 'en',
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache first if not forcing refresh
      if (!forceRefresh) {
        final cached = await EnumCacheManager.loadEnums(language);
        if (cached != null) {
          return Right(cached);
        }
      }

      // Fetch from API with Accept-Language header
      final response = await _apiService.get(
        endPoint: '/Enum/all',
        options: Options(
          headers: {'Accept-Language': language},
          extra: {'language': language},
        ),
      );

      if (response.statusCode == 200) {
        final enumResponse = EnumResponse.fromJson(response.data);
        // Cache the response
        await EnumCacheManager.saveEnums(language, enumResponse);

        return Right(enumResponse);
      } else {
        // Try to return cached data as fallback
        final cached = await EnumCacheManager.loadEnums(language);
        if (cached != null) {
          return Right(cached);
        }

        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    } catch (e) {
      // On error, try to return cached data
      final cached = await EnumCacheManager.loadEnums(language);
      if (cached != null) {
        return Right(cached);
      }

      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  /// Refresh enums for a specific language
  Future<Either<Failure, EnumResponse>> refreshEnums(String language) async {
    return fetchEnums(language: language, forceRefresh: true);
  }

  /// Clear cached enum data
  Future<void> clearCache() async {
    await EnumCacheManager.clearEnums();
  }

  /// Check if cached data exists
  Future<bool> hasCachedData(String language) async {
    return EnumCacheManager.hasCachedEnums(language);
  }
}
