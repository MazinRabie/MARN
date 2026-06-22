import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_response.dart';
import 'package:MARN/core/enums/models/enum_type.dart';

/// Universal enum resolver for centralized enum access
/// Provides safe lookup and conversion methods
class EnumResolver {
  final EnumResponse _enumResponse;

  EnumResolver(this._enumResponse);

  /// Get all items for an enum type
  List<EnumItem>? getEnum(EnumType enumType) {
    return _enumResponse.getEnum(enumType);
  }

  /// Find enum item by id
  EnumItem? findById(EnumType enumType, int id) {
    final items = getEnum(enumType);
    if (items == null) {
      // Fallback: create an EnumItem with the given id
      return EnumItem(id: id, name: id.toString(), displayName: id.toString());
    }

    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      // Fallback if id not present in the list
      return EnumItem(id: id, name: id.toString(), displayName: id.toString());
    }
  }

  /// Find enum item by name
  EnumItem? findByName(EnumType enumType, String name) {
    final items = getEnum(enumType);
    if (items == null) return null;

    try {
      return items.firstWhere(
        (item) => item.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get display name for an enum value by id
  String getDisplayNameById(EnumType enumType, int id) {
    final item = findById(enumType, id);
    return item?.displayName ?? '';
  }

  /// Get display name for an enum value by name
  String getDisplayNameByName(EnumType enumType, String name) {
    final item = findByName(enumType, name);
    return item?.displayName ?? '';
  }

  /// Get name for an enum value by id
  String getNameById(EnumType enumType, int id) {
    final item = findById(enumType, id);
    return item?.name ?? '';
  }

  /// Get id for an enum value by name
  int? getIdByName(EnumType enumType, String name) {
    final item = findByName(enumType, name);
    return item?.id;
  }

  /// Check if an enum type exists
  bool hasEnumType(EnumType enumType) {
    return _enumResponse.hasEnum(enumType);
  }

  /// Get all available enum types
  List<EnumType> getEnumTypes() {
    return _enumResponse.enumTypes;
  }

  /// Get first enum item (fallback for missing data)
  EnumItem? getFirst(EnumType enumType) {
    final items = getEnum(enumType);
    if (items == null || items.isEmpty) return null;
    return items.first;
  }

  /// Get enum item at index (for dropdowns)
  EnumItem? getByIndex(EnumType enumType, int index) {
    final items = getEnum(enumType);
    if (items == null || index < 0 || index >= items.length) return null;
    return items[index];
  }

  /// Get count of enum items
  int getCount(EnumType enumType) {
    final items = getEnum(enumType);
    return items?.length ?? 0;
  }

  /// Convert int id to EnumItem with fallback
  EnumItem resolveInt(EnumType enumType, int? id) {
    if (id == null) {
      final first = getFirst(enumType);
      return first ??
          const EnumItem(id: 0, name: 'unknown', displayName: 'Unknown');
    }

    final item = findById(enumType, id);
    if (item != null) return item;

    // Fallback to first item if available, otherwise preserve the int as string
    final first = getFirst(enumType);
    return first ??
        EnumItem(id: id, name: id.toString(), displayName: id.toString());
  }

  /// Convert string name to EnumItem with fallback
  EnumItem resolveString(EnumType enumType, String? name) {
    if (name == null || name.isEmpty) {
      final first = getFirst(enumType);
      return first ??
          const EnumItem(id: 0, name: 'unknown', displayName: 'Unknown');
    }

    final item = findByName(enumType, name);
    if (item != null) return item;

    // Fallback to first item if available, otherwise preserve the name
    final first = getFirst(enumType);
    return first ??
        EnumItem(id: 0, name: name, displayName: name);
  }

  /// Resolve dynamic value (can be int or string) safely from backend
  EnumItem resolveDynamic(EnumType enumType, dynamic value) {
    if (value == null) {
      final first = getFirst(enumType);
      return first ?? const EnumItem(id: 0, name: 'unknown', displayName: 'Unknown');
    }
    
    if (value is int) {
      return resolveInt(enumType, value);
    }
    
    if (value is String) {
      // First try to see if it's an ID sent as string (e.g. "1")
      final parsedInt = int.tryParse(value);
      if (parsedInt != null) {
        return resolveInt(enumType, parsedInt);
      }
      // Otherwise treat as string name
      return resolveString(enumType, value);
    }
    
    // Fallback
    final first = getFirst(enumType);
    return first ?? EnumItem(id: 0, name: value.toString(), displayName: value.toString());
  }

  /// Get display name for dynamic value
  String getDisplayNameDynamic(EnumType enumType, dynamic value) {
    final item = resolveDynamic(enumType, value);
    return item.displayName;
  }
}
