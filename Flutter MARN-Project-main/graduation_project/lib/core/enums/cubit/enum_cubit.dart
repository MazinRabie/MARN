import 'package:MARN/core/enums/utils/enum_resolver.dart';
import 'package:MARN/core/enums/data/enum_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'enum_state.dart';

/// Cubit for managing enum loading state
/// Handles enum fetching, caching, and language switching
class EnumCubit extends Cubit<EnumState> {
  final EnumRepository _enumRepository;
  
  EnumResolver? _resolver;
  String _currentLanguage = 'en';

  EnumCubit(this._enumRepository) : super(EnumInitial());

  /// Get the current enum resolver
  EnumResolver? get resolver => _resolver;

  /// Get current language
  String get currentLanguage => _currentLanguage;

  /// Load enums for a specific language
  Future<void> loadEnums({String language = 'en', bool forceRefresh = false}) async {
    final bool isSameLanguage = _currentLanguage == language && _resolver != null;
    _currentLanguage = language;
    
    if (!forceRefresh && isSameLanguage) {
      // Already loaded with same language
      emit(EnumLoaded(language: language, loadedAt: DateTime.now()));
      return;
    }

    emit(EnumLoading());

    final result = await _enumRepository.fetchEnums(
      language: language,
      forceRefresh: forceRefresh,
    );

    result.fold(
      (failure) {
        // If we have a resolver, keep it and emit error
        if (_resolver != null) {
          emit(EnumLoaded(language: _currentLanguage, loadedAt: DateTime.now()));
        } else {
          emit(EnumError(message: failure.errorMessage));
        }
      },
      (enumResponse) {
        _resolver = EnumResolver(enumResponse);
        emit(EnumLoaded(language: language, loadedAt: DateTime.now()));
      },
    );
  }

  /// Refresh enums for current language
  Future<void> refreshEnums() async {
    if (state is EnumLoaded) {
      final loadedState = state as EnumLoaded;
      emit(EnumRefreshing(currentLanguage: loadedState.language));
      
      await loadEnums(
        language: loadedState.language,
        forceRefresh: true,
      );
    }
  }

  /// Switch language and reload enums
  Future<void> switchLanguage(String newLanguage) async {
    if (newLanguage == _currentLanguage) return;
    
    await loadEnums(language: newLanguage, forceRefresh: false);
  }

  /// Clear cached data and reload
  Future<void> clearCacheAndReload() async {
    await _enumRepository.clearCache();
    _resolver = null;
    await loadEnums(language: _currentLanguage, forceRefresh: true);
  }

  /// Check if enums are loaded
  bool get isLoaded => _resolver != null;

  /// Check if currently loading
  bool get isLoading => state is EnumLoading || state is EnumRefreshing;
}
