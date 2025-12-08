/// JSON deserialization utilities for RollResult classes.
/// 
/// These utilities handle common issues with JSON deserialization,
/// particularly when loading from browser localStorage where Maps
/// may be returned as Map<dynamic, dynamic> instead of Map<String, dynamic>.
library;

/// Safely cast a dynamic value to Map<String, dynamic>.
/// 
/// Handles:
/// - null values (returns null)
/// - Map<String, dynamic> (returns as-is)
/// - Map<dynamic, dynamic> (converts to Map<String, dynamic>)
/// - Other types (returns null)
/// 
/// Usage in fromJson:
/// ```dart
/// final nestedJson = safeMap(meta['nestedObject']);
/// if (nestedJson != null) {
///   return NestedType.fromJson(nestedJson);
/// }
/// ```
Map<String, dynamic>? safeMap(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

/// Safely cast a dynamic value to Map<String, dynamic>, throwing if null.
/// 
/// Use this for required nested objects that must exist.
/// 
/// Usage in fromJson:
/// ```dart
/// final nestedJson = requireMap(meta['requiredObject'], 'requiredObject');
/// return NestedType.fromJson(nestedJson);
/// ```
Map<String, dynamic> requireMap(dynamic value, String fieldName) {
  final result = safeMap(value);
  if (result == null) {
    throw FormatException('Required field "$fieldName" is missing or not a Map');
  }
  return result;
}

/// Safely cast a dynamic value to List<int>.
/// 
/// Handles:
/// - null values (returns null)
/// - List<int> (returns as-is)
/// - List<dynamic> containing ints (casts to List<int>)
/// - Other types (returns null)
List<int>? safeIntList(dynamic value) {
  if (value == null) return null;
  if (value is List<int>) return value;
  if (value is List) {
    try {
      return value.cast<int>();
    } catch (_) {
      return null;
    }
  }
  return null;
}

/// Safely cast a dynamic value to List<int>, returning empty list if null.
List<int> safeIntListOrEmpty(dynamic value) {
  return safeIntList(value) ?? [];
}

/// Safely get the 'metadata' field from a JSON object.
/// 
/// This is the most common pattern in fromJson methods.
/// Use this instead of `json['metadata'] as Map<String, dynamic>`.
/// 
/// Usage:
/// ```dart
/// factory MyResult.fromJson(Map<String, dynamic> json) {
///   final meta = requireMeta(json);
///   // ... use meta fields
/// }
/// ```
Map<String, dynamic> requireMeta(Map<String, dynamic> json) {
  final metadata = json['metadata'];
  if (metadata == null) {
    throw FormatException('Required field "metadata" is missing');
  }
  if (metadata is Map<String, dynamic>) return metadata;
  if (metadata is Map) return Map<String, dynamic>.from(metadata);
  throw FormatException('Field "metadata" is not a Map');
}
