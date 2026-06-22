import 'package:MARN/features/property/data/models/owner_property_card_model.dart';
import 'package:MARN/features/property/data/models/property_add_model.dart';
import 'package:MARN/features/property/data/models/property_edit_model.dart';
import 'package:MARN/features/property/data/models/viewer_property_card_model.dart';
import 'package:MARN/features/property/domain/entities/property_search_parameters.dart';
import 'package:MARN/features/property/data/models/property_view_model.dart';

abstract class PropertyService {
  Future<String> addProperty({required PropertyAddModel property});
  Future<String> becomeOwner();
  Future<List<OwnerPropertyCardModel>> getUserProperties();
  Future<PropertyViewModel> getProperty({required int propertyId});
  Future<bool> saveProperty({required int propertyId});
  Future<List<ViewerPropertyCardModel>> getSavedProperties();
  Future<
    ({List<ViewerPropertyCardModel> items, int totalCount, int totalPages})
  >
  searchProperties({required PropertySearchParameters params});

  Future<List<ViewerPropertyCardModel>> recommendedProperties();

  Future<PropertyEditModel> getPropertyForEdit({required int propertyId});
  Future<String> editProperty({required PropertyEditModel property});

  Future<Map<String, dynamic>> togglePropertyActiveStatus({
    required int propertyId,
  });
  Future<String> deleteProperty({required int propertyId});

  Future<void> addFeedback({
    required int propertyId,
    required int rating,
    required String content,
  });
  Future<void> updateFeedback({
    required int propertyId,
    required int rating,
    required String content,
  });
  Future<void> deleteFeedback({required int propertyId});
}
