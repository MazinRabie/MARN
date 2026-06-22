import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/property/data/data_sources/property_service.dart';
import 'package:MARN/features/property/data/models/owner_property_card_model.dart';
import 'package:MARN/features/property/data/models/property_add_model.dart';
import 'package:MARN/features/property/data/models/property_edit_model.dart';
import 'package:MARN/features/property/domain/entities/card/owner_property_card_entity.dart';
import 'package:MARN/features/property/domain/entities/card/viewer_property_card_entity.dart';
import 'package:MARN/features/property/domain/entities/property_add_entity.dart';
import 'package:MARN/features/property/domain/entities/property_edit_entity.dart';
import 'package:MARN/features/property/domain/entities/property_search_parameters.dart';
import 'package:MARN/features/property/domain/entities/property_view_entity.dart';
import 'package:MARN/features/property/domain/repositories/property_repo.dart';
import 'package:dartz/dartz.dart';

class PropertyRepoImpl implements PropertyRepo {
  final PropertyService propertyService;
  PropertyRepoImpl({required this.propertyService});
  @override
  Future<Either<Failure, String>> addProperty({
    required PropertyAddEntity property,
  }) async {
    try {
      final result = await propertyService.addProperty(
        property: PropertyAddModel.fromEntity(property),
      );
      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> becomeOwner() async {
    try {
      final result = await propertyService.becomeOwner();
      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OwnerPropertyCardEntity>>>
  getUserProperties() async {
    try {
      List<OwnerPropertyCardModel> result = await propertyService
          .getUserProperties();
      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PropertyViewEntity>> getProperty({
    required int propertyId,
  }) async {
    try {
      var result = await propertyService.getProperty(propertyId: propertyId);

      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveProperty({required int propertyId}) async {
    try {
      final result = await propertyService.saveProperty(propertyId: propertyId);
      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ViewerPropertyCardEntity>>>
  getSavedProperties() async {
    try {
      var result = await propertyService.getSavedProperties();

      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<
    Either<
      Failure,
      ({List<ViewerPropertyCardEntity> items, int totalCount, int totalPages})
    >
  >
  searchProperties(PropertySearchParameters params) async {
    try {
      var result = await propertyService.searchProperties(params: params);
      return right((
        items: result.items,
        totalCount: result.totalCount,
        totalPages: result.totalPages,
      ));
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ViewerPropertyCardEntity>>>
  recommendedProperties() async {
    try {
      var result = await propertyService.recommendedProperties();
      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PropertyEditEntity>> getPropertyForEdit({
    required int propertyId,
  }) async {
    try {
      var result = await propertyService.getPropertyForEdit(
        propertyId: propertyId,
      );

      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> editProperty({
    required PropertyEditEntity property,
  }) async {
    try {
      final result = await propertyService.editProperty(
        property: property as PropertyEditModel,
      );
      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> togglePropertyActiveStatus({
    required int propertyId,
  }) async {
    try {
      final result = await propertyService.togglePropertyActiveStatus(
        propertyId: propertyId,
      );
      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProperty({
    required int propertyId,
  }) async {
    try {
      final result = await propertyService.deleteProperty(
        propertyId: propertyId,
      );
      return right(result);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addFeedback({
    required int propertyId,
    required int rating,
    required String content,
  }) async {
    try {
      await propertyService.addFeedback(
        propertyId: propertyId,
        rating: rating,
        content: content,
      );
      return right(null);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateFeedback({
    required int propertyId,
    required int rating,
    required String content,
  }) async {
    try {
      await propertyService.updateFeedback(
        propertyId: propertyId,
        rating: rating,
        content: content,
      );
      return right(null);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFeedback({
    required int propertyId,
  }) async {
    try {
      await propertyService.deleteFeedback(propertyId: propertyId);
      return right(null);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
