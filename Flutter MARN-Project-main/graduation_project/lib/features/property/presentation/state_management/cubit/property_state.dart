part of 'property_cubit.dart';

@immutable
sealed class PropertyState {}

final class PropertyInitial extends PropertyState {}

/// for general loading and failure
final class PropertyLoading extends PropertyState {}

final class PropertyFailure extends PropertyState {
  final String errorMessage;
  PropertyFailure({required this.errorMessage});
}

/// for adding property
final class PropertyAddLoading extends PropertyState {}

final class PropertyAddSuccess extends PropertyState {
  final String message;
  PropertyAddSuccess({required this.message});
}

final class PropertyAddFailure extends PropertyState {
  final String errorMessage;
  PropertyAddFailure({required this.errorMessage});
}

/// for becoming owner
final class PropertyBecomeOwnerSuccess extends PropertyState {
  final String message;
  PropertyBecomeOwnerSuccess({required this.message});
}

/// for getting user properties
final class PropertyGetUserPropertiesLoading extends PropertyState {}

final class PropertyGetUserPropertiesSuccess extends PropertyState {
  final List<OwnerPropertyCardEntity> properties;
  PropertyGetUserPropertiesSuccess({required this.properties});
}

final class PropertyGetUserPropertiesFailure extends PropertyState {
  final String errorMessage;
  PropertyGetUserPropertiesFailure({required this.errorMessage});
}

/// for getting property details
final class PropertyGetPropertyDetailsLoading extends PropertyState {}

final class PropertyGetPropertyDetailsSuccess extends PropertyState {
  final PropertyViewEntity property;
  PropertyGetPropertyDetailsSuccess({required this.property});
}

final class PropertyGetPropertyDetailsFailure extends PropertyState {
  final String errorMessage;
  PropertyGetPropertyDetailsFailure({required this.errorMessage});
}

/// for saving or unSaving property
final class PropertyToggleSave extends PropertyState {
  final bool isSaved;
  PropertyToggleSave({required this.isSaved});
}

/// for getting saved properties
final class PropertyGetSavedPropertiesLoading extends PropertyState {}

final class PropertyGetSavedPropertiesSuccess extends PropertyState {
  final List<ViewerPropertyCardEntity> properties;
  PropertyGetSavedPropertiesSuccess({required this.properties});
}

final class PropertyGetSavedPropertiesFailure extends PropertyState {
  final String errorMessage;
  PropertyGetSavedPropertiesFailure({required this.errorMessage});
}

/// for getting property details for edit
final class PropertyGetPropertyForEditLoading extends PropertyState {}

final class PropertyGetPropertyForEditSuccess extends PropertyState {
  final PropertyEditEntity property;
  PropertyGetPropertyForEditSuccess({required this.property});
}

final class PropertyGetPropertyForEditFailure extends PropertyState {
  final String errorMessage;
  PropertyGetPropertyForEditFailure({required this.errorMessage});
}

/// for editing property
final class PropertyEditLoading extends PropertyState {}

final class PropertyEditSuccess extends PropertyState {
  final String message;
  PropertyEditSuccess({required this.message});
}

final class PropertyEditFailure extends PropertyState {
  final String errorMessage;
  PropertyEditFailure({required this.errorMessage});
}

/// for toggling property active status
final class PropertyToggleActiveLoading extends PropertyState {}

final class PropertyToggleActiveSuccess extends PropertyState {
  final String message;
  final bool isActive;
  PropertyToggleActiveSuccess({required this.message, required this.isActive});
}

final class PropertyToggleActiveFailure extends PropertyState {
  final String errorMessage;
  PropertyToggleActiveFailure({required this.errorMessage});
}

/// for deleting property
final class PropertyDeleteLoading extends PropertyState {}

final class PropertyDeleteSuccess extends PropertyState {
  final String message;
  final int index;
  PropertyDeleteSuccess({required this.message, required this.index});
}

final class PropertyDeleteFailure extends PropertyState {
  final String errorMessage;
  PropertyDeleteFailure({required this.errorMessage});
}

/// Search properties
final class PropertySearchLoading extends PropertyState {}

final class PropertySearchPaginationLoading extends PropertyState {}

final class PropertySearchSuccess extends PropertyState {
  final List<ViewerPropertyCardEntity> properties;
  final bool isPagination;
  final bool hasReachedMax;
  final int totalCount;

  PropertySearchSuccess({
    required this.properties,
    this.isPagination = false,
    this.hasReachedMax = false,
    this.totalCount = 0,
  });
}

final class PropertySearchFailure extends PropertyState {
  final String errorMessage;
  PropertySearchFailure({required this.errorMessage});
}

/// for recommended properties
final class PropertyRecommendedPropertiesLoading extends PropertyState {}

final class PropertyRecommendedPropertiesSuccess extends PropertyState {
  final List<ViewerPropertyCardEntity> properties;
  PropertyRecommendedPropertiesSuccess({required this.properties});
}

final class PropertyRecommendedPropertiesFailure extends PropertyState {
  final String errorMessage;
  PropertyRecommendedPropertiesFailure({required this.errorMessage});
}

/// Feedback states
final class PropertyFeedbackLoading extends PropertyState {}

final class PropertyFeedbackSuccess extends PropertyState {}

final class PropertyFeedbackFailure extends PropertyState {
  final String errorMessage;
  PropertyFeedbackFailure({required this.errorMessage});
}
