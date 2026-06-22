part of 'enum_cubit.dart';

/// Base enum state
abstract class EnumState {}

/// Initial state - enums not loaded
class EnumInitial extends EnumState {}

/// Loading state - fetching enums
class EnumLoading extends EnumState {}

/// Loaded state - enums successfully loaded
class EnumLoaded extends EnumState {
  final String language;
  final DateTime loadedAt;

  EnumLoaded({
    required this.language,
    required this.loadedAt,
  });
}

/// Error state - failed to load enums
class EnumError extends EnumState {
  final String message;

  EnumError({required this.message});
}

/// Refreshing state - refreshing enums
class EnumRefreshing extends EnumState {
  final String currentLanguage;

  EnumRefreshing({required this.currentLanguage});
}
