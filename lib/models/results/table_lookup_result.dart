// Generic table lookup result that replaces ~20 specific result classes.
//
// This consolidated class handles all simple "roll on table, get result"
// patterns including:
// - SingleTableResult (Modifier, Idea, Event, Person, Object tables)
// - DetailResult (Color, Property, History, etc.)
// - Various dungeon/wilderness/settlement detail results
//
// The tableName metadata distinguishes between different table sources.

import '../roll_result.dart';

/// A generic result from rolling on a lookup table.
///
/// This replaces many specific result classes that were essentially identical
/// in structure - they just differed in which table they referenced.
///
/// Use the [tableName] and [category] to distinguish between table sources
/// when rendering in the UI.
class TableLookupResult extends RollResult {
  // Helper to safely access metadata
  Map<String, dynamic> get _meta => metadata ?? const {};

  /// The name of the table that was rolled on.
  String get tableName => _meta['tableName'] as String? ?? 'Unknown';

  /// The primary roll value.
  int get roll => _meta['roll'] as int? ?? 0;

  /// The result value from the table.
  String get result => _meta['result'] as String? ?? '';

  /// Optional secondary roll (for two-stage lookups).
  int? get secondRoll => _meta['secondRoll'] as int?;

  /// Optional secondary result (for two-stage lookups).
  String? get subResult => _meta['subResult'] as String?;

  /// Optional category grouping (e.g., 'dungeon', 'wilderness', 'settlement').
  String? get category => _meta['category'] as String?;

  /// Optional emoji/icon for the result.
  String? get emoji => _meta['emoji'] as String?;

  /// Whether this result requires a follow-up roll.
  bool get requiresFollowUp => _meta['requiresFollowUp'] as bool? ?? false;

  /// Name of the follow-up table if [requiresFollowUp] is true.
  String? get followUpTable => _meta['followUpTable'] as String?;

  TableLookupResult({
    required RollType type,
    required String description,
    required String tableName,
    required int roll,
    required String result,
    int? secondRoll,
    String? subResult,
    String? category,
    String? emoji,
    bool requiresFollowUp = false,
    String? followUpTable,
    DateTime? timestamp,
  }) : super(
          type: type,
          description: description,
          diceResults: secondRoll != null ? [roll, secondRoll] : [roll],
          total: roll,
          interpretation: _buildInterpretation(result, subResult, emoji),
          timestamp: timestamp,
          metadata: {
            'tableName': tableName,
            'roll': roll,
            'result': result,
            if (secondRoll != null) 'secondRoll': secondRoll,
            if (subResult != null) 'subResult': subResult,
            if (category != null) 'category': category,
            if (emoji != null) 'emoji': emoji,
            'requiresFollowUp': requiresFollowUp,
            if (followUpTable != null) 'followUpTable': followUpTable,
          },
        );

  /// Factory constructor for simple single-table rolls.
  factory TableLookupResult.simple({
    required RollType type,
    required String tableName,
    required int roll,
    required String result,
    String? emoji,
    DateTime? timestamp,
  }) {
    return TableLookupResult(
      type: type,
      description: tableName,
      tableName: tableName,
      roll: roll,
      result: result,
      emoji: emoji,
      timestamp: timestamp,
    );
  }

  /// Factory constructor for detail-type rolls (Color, Property, History, etc.).
  factory TableLookupResult.detail({
    required String detailType,
    required int roll,
    required String result,
    int? secondRoll,
    String? subResult,
    String? emoji,
    bool requiresFollowUp = false,
    String? followUpTable,
    DateTime? timestamp,
  }) {
    return TableLookupResult(
      type: RollType.details,
      description: detailType,
      tableName: detailType,
      roll: roll,
      result: result,
      secondRoll: secondRoll,
      subResult: subResult,
      emoji: emoji,
      requiresFollowUp: requiresFollowUp,
      followUpTable: followUpTable,
      timestamp: timestamp,
    );
  }

  /// Factory constructor for dungeon-related rolls.
  factory TableLookupResult.dungeon({
    required String tableName,
    required int roll,
    required String result,
    int? secondRoll,
    String? subResult,
    DateTime? timestamp,
  }) {
    return TableLookupResult(
      type: RollType.dungeon,
      description: tableName,
      tableName: tableName,
      roll: roll,
      result: result,
      secondRoll: secondRoll,
      subResult: subResult,
      category: 'dungeon',
      timestamp: timestamp,
    );
  }

  /// Factory constructor for wilderness/encounter-related rolls.
  factory TableLookupResult.wilderness({
    required String tableName,
    required int roll,
    required String result,
    int? secondRoll,
    String? subResult,
    DateTime? timestamp,
  }) {
    return TableLookupResult(
      type: RollType.encounter,
      description: tableName,
      tableName: tableName,
      roll: roll,
      result: result,
      secondRoll: secondRoll,
      subResult: subResult,
      category: 'wilderness',
      timestamp: timestamp,
    );
  }

  /// Factory constructor for settlement-related rolls.
  factory TableLookupResult.settlement({
    required String tableName,
    required int roll,
    required String result,
    int? secondRoll,
    String? subResult,
    DateTime? timestamp,
  }) {
    return TableLookupResult(
      type: RollType.settlement,
      description: tableName,
      tableName: tableName,
      roll: roll,
      result: result,
      secondRoll: secondRoll,
      subResult: subResult,
      category: 'settlement',
      timestamp: timestamp,
    );
  }

  @override
  String get className => 'TableLookupResult';

  factory TableLookupResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>? ?? {};
    final diceResults = (json['diceResults'] as List?)?.cast<int>() ?? [0];

    return TableLookupResult(
      type: RollType.values.firstWhere(
        (e) => e.name == (json['type'] as String?),
        orElse: () => RollType.tableLookup,
      ),
      description: json['description'] as String? ?? '',
      tableName: meta['tableName'] as String? ?? 'Unknown',
      roll: meta['roll'] as int? ?? (diceResults.isNotEmpty ? diceResults.first : 0),
      result: meta['result'] as String? ?? '',
      secondRoll: meta['secondRoll'] as int?,
      subResult: meta['subResult'] as String?,
      category: meta['category'] as String?,
      emoji: meta['emoji'] as String?,
      requiresFollowUp: meta['requiresFollowUp'] as bool? ?? false,
      followUpTable: meta['followUpTable'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  static String _buildInterpretation(
    String result,
    String? subResult,
    String? emoji,
  ) {
    final buffer = StringBuffer();
    if (emoji != null) {
      buffer.write('$emoji ');
    }
    buffer.write(result);
    if (subResult != null) {
      buffer.write(': $subResult');
    }
    return buffer.toString();
  }

  @override
  String toString() {
    if (subResult != null) {
      return '$tableName: $result ($subResult)';
    }
    return '$tableName: $result';
  }
}
