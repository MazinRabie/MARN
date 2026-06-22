import 'package:MARN/features/property/domain/entities/card/owner_property_card_entity.dart';
import 'package:MARN/features/property/domain/entities/card/viewer_property_card_entity.dart';
import 'package:MARN/features/property/domain/entities/property_add_entity.dart';
import 'package:MARN/features/property/domain/entities/property_edit_entity.dart';
import 'package:MARN/features/property/domain/entities/property_search_parameters.dart';
import 'package:MARN/features/property/domain/entities/property_view_entity.dart';
import 'package:MARN/features/property/domain/repositories/property_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  PropertyCubit({required this.propertyRepo}) : super(PropertyInitial());

  final PropertyRepo propertyRepo;

  Future<void> addProperty({required PropertyAddEntity property}) async {
    emit(PropertyAddLoading());

    final result = await propertyRepo.addProperty(property: property);
    result.fold(
      (failure) => emit(PropertyAddFailure(errorMessage: failure.errorMessage)),
      (message) => emit(PropertyAddSuccess(message: message)),
    );
  }

  Future<void> becomeOwner() async {
    emit(PropertyLoading());

    final result = await propertyRepo.becomeOwner();
    result.fold(
      (failure) => emit(PropertyFailure(errorMessage: failure.errorMessage)),
      (message) => emit(PropertyBecomeOwnerSuccess(message: message)),
    );
  }

  Future<void> getUserProperties() async {
    emit(PropertyGetUserPropertiesLoading());

    final result = await propertyRepo.getUserProperties();
    result.fold(
      (failure) => emit(
        PropertyGetUserPropertiesFailure(errorMessage: failure.errorMessage),
      ),
      (properties) =>
          emit(PropertyGetUserPropertiesSuccess(properties: properties)),
    );
  }

  Future<void> getPropertyDetails({required int propertyId}) async {
    emit(PropertyGetPropertyDetailsLoading());

    final result = await propertyRepo.getProperty(propertyId: propertyId);
    result.fold(
      (failure) => emit(
        PropertyGetPropertyDetailsFailure(errorMessage: failure.errorMessage),
      ),
      (property) => emit(PropertyGetPropertyDetailsSuccess(property: property)),
    );
  }

  Future<void> toggleSaveProperty({required int propertyId}) async {
    final result = await propertyRepo.saveProperty(propertyId: propertyId);
    result.fold(
      (failure) {},
      (isSaved) => emit(PropertyToggleSave(isSaved: isSaved)),
    );
  }

  Future<void> getSavedProperties() async {
    emit(PropertyGetSavedPropertiesLoading());

    final result = await propertyRepo.getSavedProperties();
    result.fold(
      (failure) => emit(
        PropertyGetSavedPropertiesFailure(errorMessage: failure.errorMessage),
      ),
      (properties) =>
          emit(PropertyGetSavedPropertiesSuccess(properties: properties)),
    );
  }

  Future<void> getPropertyForEdit({required int propertyId}) async {
    emit(PropertyGetPropertyForEditLoading());

    final result = await propertyRepo.getPropertyForEdit(
      propertyId: propertyId,
    );
    result.fold(
      (failure) => emit(
        PropertyGetPropertyForEditFailure(errorMessage: failure.errorMessage),
      ),
      (property) => emit(PropertyGetPropertyForEditSuccess(property: property)),
    );
  }

  Future<void> editProperty({required PropertyEditEntity property}) async {
    emit(PropertyEditLoading());

    final result = await propertyRepo.editProperty(property: property);
    result.fold(
      (failure) =>
          emit(PropertyEditFailure(errorMessage: failure.errorMessage)),
      (message) => emit(PropertyEditSuccess(message: message)),
    );
  }

  Future<void> togglePropertyActiveStatus({required int propertyId}) async {
    emit(PropertyToggleActiveLoading());

    final result = await propertyRepo.togglePropertyActiveStatus(
      propertyId: propertyId,
    );
    result.fold(
      (failure) =>
          emit(PropertyToggleActiveFailure(errorMessage: failure.errorMessage)),
      (result) => emit(
        PropertyToggleActiveSuccess(
          message: result['message'] as String,
          isActive: result['isActive'] as bool,
        ),
      ),
    );
  }

  Future<void> deleteProperty({
    required int propertyId,
    required int index,
  }) async {
    emit(PropertyDeleteLoading());

    final result = await propertyRepo.deleteProperty(propertyId: propertyId);
    result.fold(
      (failure) =>
          emit(PropertyDeleteFailure(errorMessage: failure.errorMessage)),
      (message) => emit(PropertyDeleteSuccess(message: message, index: index)),
    );
  }

  Future<void> searchProperties(
    PropertySearchParameters params, {
    bool isPagination = false,
  }) async {
    if (isPagination) {
      emit(PropertySearchPaginationLoading());
    } else {
      emit(PropertySearchLoading());
    }

    final result = await propertyRepo.searchProperties(params);
    result.fold(
      (failure) =>
          emit(PropertySearchFailure(errorMessage: failure.errorMessage)),
      (data) {
        final hasReachedMax =
            (params.page ?? 1) >= data.totalPages || data.items.isEmpty;
        emit(
          PropertySearchSuccess(
            properties: data.items,
            isPagination: isPagination,
            hasReachedMax: hasReachedMax,
            totalCount: data.totalCount,
          ),
        );
      },
    );
  }

  Future<void> recommendedProperties() async {
    emit(PropertyRecommendedPropertiesLoading());
    final result = await propertyRepo.recommendedProperties();
    result.fold(
      (failure) => emit(
        PropertyRecommendedPropertiesFailure(
          errorMessage: failure.errorMessage,
        ),
      ),
      (properties) =>
          emit(PropertyRecommendedPropertiesSuccess(properties: properties)),
    );
  }

  Future<void> submitFeedback({
    required int propertyId,
    required int rating,
    required String content,
  }) async {
    emit(PropertyFeedbackLoading());
    final result = await propertyRepo.addFeedback(
      propertyId: propertyId,
      rating: rating,
      content: content,
    );
    result.fold(
      (failure) =>
          emit(PropertyFeedbackFailure(errorMessage: failure.errorMessage)),
      (_) => emit(PropertyFeedbackSuccess()),
    );
  }

  Future<void> updateFeedback({
    required int propertyId,
    required int rating,
    required String content,
  }) async {
    emit(PropertyFeedbackLoading());
    final result = await propertyRepo.updateFeedback(
      propertyId: propertyId,
      rating: rating,
      content: content,
    );
    result.fold(
      (failure) =>
          emit(PropertyFeedbackFailure(errorMessage: failure.errorMessage)),
      (_) => emit(PropertyFeedbackSuccess()),
    );
  }

  Future<void> deleteFeedback({required int propertyId}) async {
    emit(PropertyFeedbackLoading());
    final result = await propertyRepo.deleteFeedback(propertyId: propertyId);
    result.fold(
      (failure) =>
          emit(PropertyFeedbackFailure(errorMessage: failure.errorMessage)),
      (_) => emit(PropertyFeedbackSuccess()),
    );
  }
}
