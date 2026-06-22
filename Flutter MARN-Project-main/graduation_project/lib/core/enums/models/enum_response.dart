import 'package:MARN/core/enums/models/enum_type.dart';

import 'enum_item.dart';

/// Response model for enum API endpoint
/// Maps enum type names to their respective items
class EnumResponse {
  final Map<EnumType, List<EnumItem>> enums;

  const EnumResponse({required this.enums});

  factory EnumResponse.fromJson(Map<String, dynamic> json) {
    final Map<EnumType, List<EnumItem>> enumMap = {};

    // Handle wrapped API response structure: { code, message, data: { ... } }
    final data = json['data'] as Map<String, dynamic>?;
    final enumData = data ?? json;
    enumData.forEach((key, value) {
      if (value is List) {
        final enumType = EnumType.fromString(key);
        if (enumType != null) {
          enumMap[enumType] = value
              .map((item) => EnumItem.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
    });
    return EnumResponse(enums: enumMap);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    enums.forEach((key, value) {
      json[key.name] = value.map((item) => item.toJson()).toList();
    });
    return json;
  }

  /// Get all items for a specific enum type
  List<EnumItem>? getEnum(EnumType enumType) {
    return enums[enumType];
  }

  /// Check if an enum type exists
  bool hasEnum(EnumType enumType) {
    return enums.containsKey(enumType);
  }

  /// Get all enum type names
  List<EnumType> get enumTypes => enums.keys.toList();
}
