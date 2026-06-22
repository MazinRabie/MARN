import 'package:MARN/core/utilities/api_keys.dart';

String? buildImageUrl(String? path) {
  if (path == null || path.trim().isEmpty) return null;

  if (path.startsWith('http')) return path;

  const baseUrl = ApiKeys.baseUrl;

  return "$baseUrl$path";
}
