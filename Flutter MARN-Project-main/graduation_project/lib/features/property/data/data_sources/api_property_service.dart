import 'package:MARN/core/errors/failure.dart';
import 'package:MARN/core/services/api_service.dart';
import 'package:MARN/core/services/shared_preferences_helper.dart';
import 'package:MARN/core/utilities/api_endpoints.dart';
import 'package:MARN/features/property/data/data_sources/property_service.dart';
import 'package:MARN/features/property/data/models/owner_property_card_model.dart';
import 'package:MARN/features/property/data/models/property_add_model.dart';
import 'package:MARN/features/property/data/models/property_edit_model.dart';
import 'package:MARN/features/property/data/models/viewer_property_card_model.dart';
import 'package:MARN/features/property/data/models/property_view_model.dart';
import 'package:MARN/features/property/domain/entities/property_search_parameters.dart';
import 'package:dio/dio.dart';

class ApiPropertyService implements PropertyService {
  final ApiService apiService;
  ApiPropertyService({required this.apiService});
  @override
  Future<String> addProperty({required PropertyAddModel property}) async {
    return await handleRequest(() async {
      FormData formData = FormData.fromMap({
        if (property.title != null) "Title": property.title,
        if (property.description != null) "Description": property.description,
        if (property.type != null) "Type": property.type!.toBackendValue(),
        if (property.isShared != null) "IsShared": property.isShared,
        if (property.maxOccupants != null)
          "MaxOccupants": property.maxOccupants,
        if (property.bedrooms != null) "Bedrooms": property.bedrooms,
        if (property.beds != null) "Beds": property.beds,
        if (property.bathrooms != null) "Bathrooms": property.bathrooms,
        if (property.price != null) "Price": property.price,
        if (property.rentalUnit != null)
          "RentalUnit": property.rentalUnit!.toBackendValue(),
        if (property.address != null) "Address": property.address,
        if (property.city != null) "City": property.city!.toBackendValue(),
        if (property.governorate != null)
          "Governorate": property.governorate!.toBackendValue(),
        if (property.zipCode != null) "ZipCode": property.zipCode,
        if (property.squareMeters != null)
          "SquareMeters": property.squareMeters,
        if (property.latitude != null) "Latitude": property.latitude,
        if (property.longitude != null) "Longitude": property.longitude,
      });

      if (property.proofOfOwnership != null) {
        formData.files.add(
          MapEntry(
            "ProofOfOwnership",
            await MultipartFile.fromFile(property.proofOfOwnership!.path),
          ),
        );
      }

      if (property.primaryImage != null) {
        formData.files.add(
          MapEntry(
            "PrimaryImage",
            await MultipartFile.fromFile(property.primaryImage!.path),
          ),
        );
      }

      if (property.mediaFiles != null) {
        for (var file in property.mediaFiles!) {
          formData.files.add(
            MapEntry("MediaFiles", await MultipartFile.fromFile(file.path)),
          );
        }
      }

      if (property.amenities != null) {
        for (var amenity in property.amenities!) {
          formData.fields.add(
            MapEntry("Amenities", amenity.toBackendValue().toString()),
          );
        }
      }

      if (property.rules != null) {
        for (var rule in property.rules!) {
          formData.fields.add(MapEntry("Rules", rule));
        }
      }

      var response = await apiService.post(
        endPoint: ApiEndPoints.propertyAdd,
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
  Future<String> becomeOwner() async {
    return await handleRequest(() async {
      var response = await apiService.post(
        endPoint: ApiEndPoints.propertyBecomeOwner,
      );

      if (response.statusCode == 200) {
        SharedPreferencesHelper.setString(
          LocalStorageVariables.token,
          response.data['data'],
        );
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<List<OwnerPropertyCardModel>> getUserProperties() async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: ApiEndPoints.profileOwnerDashboard,
      );

      if (response.statusCode == 200) {
        List<OwnerPropertyCardModel> properties = [];
        for (var property in response.data['data']['properties']) {
          properties.add(OwnerPropertyCardModel.fromJson(property));
        }
        return properties;
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<PropertyViewModel> getProperty({required int propertyId}) async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: "${ApiEndPoints.property}/$propertyId",
      );

      if (response.statusCode == 200) {
        return PropertyViewModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<bool> saveProperty({required int propertyId}) async {
    return await handleRequest(() async {
      var response = await apiService.post(
        endPoint: "${ApiEndPoints.propertySave}/$propertyId",
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<List<ViewerPropertyCardModel>> getSavedProperties() async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: ApiEndPoints.profileRenterDashboard,
      );

      if (response.statusCode == 200) {
        List<ViewerPropertyCardModel> properties = [];
        for (var property in response.data['data']['savedProperties']) {
          properties.add(ViewerPropertyCardModel.fromJson(property));
        }
        return properties;
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<
    ({List<ViewerPropertyCardModel> items, int totalCount, int totalPages})
  >
  searchProperties({required PropertySearchParameters params}) async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: ApiEndPoints.propertySearch,
        queryParameters: params.toMap(),
      );

      if (response.statusCode == 200) {
        List<ViewerPropertyCardModel> properties = [];
        for (var property in response.data['data']['items']) {
          properties.add(ViewerPropertyCardModel.fromJson(property));
        }
        return (
          items: properties,
          totalCount: response.data['data']['totalCount'] as int? ?? 0,
          totalPages: response.data['data']['totalPages'] as int? ?? 0,
        );
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<List<ViewerPropertyCardModel>> recommendedProperties() async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: ApiEndPoints.recommendedProperties,
      );

      if (response.statusCode == 200) {
        List<ViewerPropertyCardModel> properties = [];
        for (var property in response.data['data']['items']) {
          properties.add(ViewerPropertyCardModel.fromJson(property));
        }
        return properties;
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<PropertyEditModel> getPropertyForEdit({
    required int propertyId,
  }) async {
    return await handleRequest(() async {
      var response = await apiService.get(
        endPoint: "${ApiEndPoints.propertyEdit}/$propertyId",
      );

      if (response.statusCode == 200) {
        return PropertyEditModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> editProperty({required PropertyEditModel property}) async {
    return await handleRequest(() async {
      FormData formData = FormData.fromMap({
        "Title": property.title,
        "Description": property.description,
        "Type": property.type.toBackendValue(),
        "IsShared": property.isShared,
        "MaxOccupants": property.maxOccupants,
        "Bedrooms": property.bedrooms,
        "Beds": property.beds,
        "Bathrooms": property.bathrooms,
        "Price": property.price,
        "RentalUnit": property.rentalUnit.toBackendValue(),
        "Address": property.address,
        "City": property.city.toBackendValue(),
        "Governorate": property.governorate.toBackendValue(),
        "ZipCode": property.zipCode,
        "SquareMeters": property.squareMeters,
        "Latitude": property.latitude,
        "Longitude": property.longitude,
      });

      if (property.newProofOfOwnership != null) {
        formData.files.add(
          MapEntry(
            "NewProofOfOwnership",
            await MultipartFile.fromFile(property.newProofOfOwnership!.path),
          ),
        );
      }

      if (property.newPrimaryImage != null) {
        formData.files.add(
          MapEntry(
            "NewPrimaryImage",
            await MultipartFile.fromFile(property.newPrimaryImage!.path),
          ),
        );
      }

      if (property.addedMediaFiles != null) {
        for (var file in property.addedMediaFiles!) {
          formData.files.add(
            MapEntry(
              "AddedMediaFiles",
              await MultipartFile.fromFile(file.path),
            ),
          );
        }
      }

      if (property.removedMediaIds != null) {
        for (var id in property.removedMediaIds!) {
          formData.fields.add(MapEntry("RemovedMediaIds", id.toString()));
        }
      }

      if (property.addedAmenities != null) {
        for (var amenity in property.addedAmenities!) {
          formData.fields.add(
            MapEntry("AddedAmenities", amenity.toBackendValue().toString()),
          );
        }
      }

      if (property.removedAmenityIds != null) {
        for (var id in property.removedAmenityIds!) {
          formData.fields.add(MapEntry("RemovedAmenityIds", id.toString()));
        }
      }

      if (property.addedRuleTexts != null) {
        for (var rule in property.addedRuleTexts!) {
          formData.fields.add(MapEntry("AddedRules", rule));
        }
      }

      if (property.removedRuleIds != null) {
        for (var id in property.removedRuleIds!) {
          formData.fields.add(MapEntry("RemovedRuleIds", id.toString()));
        }
      }

      var response = await apiService.put(
        endPoint: "${ApiEndPoints.propertyEdit}/${property.id}",
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
  Future<Map<String, dynamic>> togglePropertyActiveStatus({
    required int propertyId,
  }) async {
    return await handleRequest(() async {
      var response = await apiService.put(
        endPoint: "${ApiEndPoints.propertyDeactivate}/$propertyId",
      );

      if (response.statusCode == 200) {
        return {
          "message": response.data['message'],
          "isActive": response.data['data'],
        };
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<String> deleteProperty({required int propertyId}) async {
    return await handleRequest(() async {
      var response = await apiService.delete(
        endPoint: "${ApiEndPoints.propertyDelete}/$propertyId",
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<void> addFeedback({
    required int propertyId,
    required int rating,
    required String content,
  }) async {
    await handleRequest(() async {
      var response = await apiService.post(
        endPoint: "${ApiEndPoints.propertyFeedback}/$propertyId/feedback",
        body: {'rating': rating, 'content': content},
      );
      if (response.statusCode != 201) {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<void> updateFeedback({
    required int propertyId,
    required int rating,
    required String content,
  }) async {
    await handleRequest(() async {
      var response = await apiService.put(
        endPoint: "${ApiEndPoints.propertyFeedback}/$propertyId/feedback/me",
        body: {'rating': rating, 'content': content},
      );
      if (response.statusCode != 200) {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }

  @override
  Future<void> deleteFeedback({required int propertyId}) async {
    await handleRequest(() async {
      var response = await apiService.delete(
        endPoint: "${ApiEndPoints.propertyFeedback}/$propertyId/feedback/me",
      );
      if (response.statusCode != 200) {
        throw ServerFailure.fromResponse(response.statusCode!, response.data);
      }
    });
  }
}
