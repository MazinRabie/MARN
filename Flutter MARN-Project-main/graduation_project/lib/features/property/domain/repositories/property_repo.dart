import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/features/property/domain/entities/card/owner_property_card_entity.dart';
import 'package:MARN/features/property/domain/entities/card/viewer_property_card_entity.dart';
import 'package:MARN/features/property/domain/entities/property_add_entity.dart';
import 'package:MARN/features/property/domain/entities/property_edit_entity.dart';
import 'package:MARN/features/property/domain/entities/property_search_parameters.dart';
import 'package:MARN/features/property/domain/entities/property_view_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PropertyRepo {
  Future<Either<Failure, String>> addProperty({
    required PropertyAddEntity property,
  });
  Future<Either<Failure, String>> becomeOwner();
  Future<Either<Failure, List<OwnerPropertyCardEntity>>> getUserProperties();
  Future<Either<Failure, PropertyViewEntity>> getProperty({
    required int propertyId,
  });
  Future<Either<Failure, bool>> saveProperty({required int propertyId});
  Future<Either<Failure, List<ViewerPropertyCardEntity>>> getSavedProperties();
  Future<
    Either<
      Failure,
      ({List<ViewerPropertyCardEntity> items, int totalCount, int totalPages})
    >
  >
  searchProperties(PropertySearchParameters params);
  Future<Either<Failure, List<ViewerPropertyCardEntity>>>
  recommendedProperties();
  Future<Either<Failure, PropertyEditEntity>> getPropertyForEdit({
    required int propertyId,
  });
  Future<Either<Failure, String>> editProperty({
    required PropertyEditEntity property,
  });
  Future<Either<Failure, Map<String, dynamic>>> togglePropertyActiveStatus({
    required int propertyId,
  });
  Future<Either<Failure, String>> deleteProperty({required int propertyId});

  Future<Either<Failure, void>> addFeedback({
    required int propertyId,
    required int rating,
    required String content,
  });
  Future<Either<Failure, void>> updateFeedback({
    required int propertyId,
    required int rating,
    required String content,
  });
  Future<Either<Failure, void>> deleteFeedback({required int propertyId});
}
