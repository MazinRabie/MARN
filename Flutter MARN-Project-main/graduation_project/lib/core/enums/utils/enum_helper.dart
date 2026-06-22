import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:MARN/core/enums/cubit/enum_cubit.dart';
import 'package:MARN/core/enums/utils/enum_resolver.dart';
import 'package:MARN/core/enums/models/enum_item.dart';
import 'package:MARN/core/enums/models/enum_type.dart';

/// Global helper for easy access to enum resolver
/// Provides static methods to access enum data from anywhere in the app
class EnumHelper {
  /// Get the enum resolver from context
  static EnumResolver? of(BuildContext context) {
    return context.read<EnumCubit>().resolver;
  }

  /// Get display name by enum type and id
  static String getDisplayName(
    BuildContext context,
    EnumType enumType,
    int id,
  ) {
    final resolver = of(context);
    if (resolver == null) return '';
    return resolver.getDisplayNameById(enumType, id);
  }

  /// Get display name by enum type and name
  static String getDisplayNameByName(
    BuildContext context,
    EnumType enumType,
    String name,
  ) {
    final resolver = of(context);
    if (resolver == null) return '';
    return resolver.getDisplayNameByName(enumType, name);
  }

  /// Get enum item by id
  static EnumItem? findById(BuildContext context, EnumType enumType, int id) {
    final resolver = of(context);
    if (resolver == null) {
      // Return a fallback EnumItem with given id as name/displayName
      return EnumItem(id: id, name: id.toString(), displayName: id.toString());
    }
    return resolver.findById(enumType, id);
  }

  /// Get enum item by name
  static EnumItem? findByName(
    BuildContext context,
    EnumType enumType,
    String name,
  ) {
    final resolver = of(context);
    if (resolver == null) return null;
    // Try exact name match (case‑insensitive)
    final item = resolver.findByName(enumType, name);
    if (item != null) return item;
    // Fallback: if name looks like an integer, treat it as an id
    final id = int.tryParse(name);
    if (id != null) {
      return resolver.findById(enumType, id);
    }
    return null;
  }

  /// Get all enum items for a type
  static List<EnumItem>? getEnum(BuildContext context, EnumType enumType) {
    final resolver = of(context);
    if (resolver == null) return null;
    return resolver.getEnum(enumType);
  }

  /// Resolve int to EnumItem with fallback
  static EnumItem resolveInt(BuildContext context, EnumType enumType, int? id) {
    final resolver = of(context);
    if (resolver == null) {
      return const EnumItem(id: 0, name: 'unknown', displayName: 'Unknown');
    }
    return resolver.resolveInt(enumType, id);
  }

  /// Resolve string to EnumItem with fallback
  static EnumItem resolveString(
    BuildContext context,
    EnumType enumType,
    String? name,
  ) {
    final resolver = of(context);
    if (resolver == null) {
      return const EnumItem(id: 0, name: 'unknown', displayName: 'Unknown');
    }
    return resolver.resolveString(enumType, name);
  }

  /// Resolve dynamic value (can be int or string) safely from backend
  static EnumItem resolveDynamic(
    BuildContext context,
    EnumType enumType,
    dynamic value,
  ) {
    final resolver = of(context);
    if (resolver == null) {
      return const EnumItem(id: 0, name: 'unknown', displayName: 'Unknown');
    }
    return resolver.resolveDynamic(enumType, value);
  }

  /// Get display name for a dynamic value
  static String getDisplayNameDynamic(
    BuildContext context,
    EnumType enumType,
    dynamic value,
  ) {
    final resolver = of(context);
    if (resolver == null) return '';
    return resolver.getDisplayNameDynamic(enumType, value);
  }

  /// Check if enums are loaded
  static bool isLoaded(BuildContext context) {
    return context.read<EnumCubit>().isLoaded;
  }

  /// Refresh enums
  static Future<void> refresh(BuildContext context) async {
    await context.read<EnumCubit>().refreshEnums();
  }

  /// Switch language
  static Future<void> switchLanguage(
    BuildContext context,
    String language,
  ) async {
    await context.read<EnumCubit>().switchLanguage(language);
  }
}
