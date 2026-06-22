class EnumConfig {
  /// Global preference:
  /// - If true, `EnumItem.toBackendValue()` returns the integer `id`.
  /// - If false, it returns the string `name`.
  static bool sendIdToBackend = true;
}
