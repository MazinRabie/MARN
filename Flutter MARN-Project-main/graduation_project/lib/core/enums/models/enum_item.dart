import 'package:MARN/core/services/service_locator.dart';
import 'package:MARN/core/enums/models/enum_type.dart';
import 'package:MARN/core/enums/cubit/enum_cubit.dart';
import 'package:MARN/core/enums/utils/enum_config.dart';

/// Generic enum item model for API-driven enums
/// Supports int, string, and mixed enum formats
class EnumItem {
  final int id;
  final String name;
  final String displayName;

  const EnumItem({
    required this.id,
    required this.name,
    required this.displayName,
  });

  /// Resolves an EnumItem from any value (string or int) by looking it up in the cache.
  static EnumItem resolve(EnumType type, dynamic value) {
    if (value == null) return empty;
    return getIt<EnumCubit>().resolver?.resolveDynamic(type, value) ?? empty;
  }

  /// Returns the id or name based on the global EnumConfig preference.
  dynamic toBackendValue() {
    return EnumConfig.sendIdToBackend ? id : name;
  }

  static const EnumItem empty = EnumItem(
    id: 0,
    name: '',
    displayName: '',
  );

  factory EnumItem.fromJson(Map<String, dynamic> json) {
    // Handle id safely (could be int or string from backend)
    int parseId(dynamic idVal) {
      if (idVal is int) return idVal;
      if (idVal is String) return int.tryParse(idVal) ?? 0;
      return 0;
    }

    return EnumItem(
      id: parseId(json['id'] ?? json['value']),
      name: json['name']?.toString() ?? json['value']?.toString() ?? '',
      displayName: json['displayName']?.toString() ??
          json['name']?.toString() ??
          json['value']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'displayName': displayName};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnumItem && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() =>
      'EnumItem(id: $id, name: $name, displayName: $displayName)';
}
