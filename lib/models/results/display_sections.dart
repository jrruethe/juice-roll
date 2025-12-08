/// Display section builders for generating structured result sections.
/// 
/// This file provides helper functions to build common section patterns
/// used across different result types. These enable the generic section-based
/// renderer to display results without type-specific code.
library;

import 'result_types.dart';

/// Helper class for building common section patterns.
class DisplaySections {
  DisplaySections._();

  /// Build a dice roll section with optional label.
  static ResultSection diceRoll({
    required String notation,
    required List<int> dice,
    String? label,
  }) {
    return ResultSection(
      label: label ?? notation,
      value: dice.join(', '),
      relatedDice: dice,
    );
  }

  /// Build a labeled value section.
  static ResultSection labeledValue({
    required String label,
    required String value,
    String? sublabel,
    bool isEmphasized = false,
    int? colorValue,
    String? iconName,
    List<int>? dice,
  }) {
    return ResultSection(
      label: label,
      value: value,
      sublabel: sublabel,
      isEmphasized: isEmphasized,
      colorValue: colorValue,
      iconName: iconName,
      relatedDice: dice,
    );
  }

  /// Build an outcome chip section (Yes/No, Success/Failure, etc.)
  static ResultSection outcome({
    required String value,
    required bool isPositive,
    String? iconName,
  }) {
    // Use green for positive, red for negative
    final color = isPositive ? 0xFF4CAF50 : 0xFFF44336;
    return ResultSection(
      label: 'Outcome',
      value: value,
      isEmphasized: true,
      colorValue: color,
      iconName: iconName,
    );
  }

  /// Build a fate dice section with symbolic representation.
  static ResultSection fateDice({
    required List<int> dice,
    String? label,
  }) {
    // Convert to symbols
    final symbols = dice.map((d) {
      switch (d) {
        case -1:
          return '−';
        case 0:
          return '○';
        case 1:
          return '+';
        default:
          return '?';
      }
    }).join(' ');
    
    return ResultSection(
      label: label ?? '2dF',
      value: symbols,
      relatedDice: dice,
    );
  }

  /// Build a trigger/alert section (Random Event, Invalid Assumption, etc.)
  static ResultSection trigger({
    required String value,
    String? iconName,
    int? colorValue,
  }) {
    return ResultSection(
      label: 'Trigger',
      value: value,
      isEmphasized: true,
      iconName: iconName ?? 'flash_on',
      colorValue: colorValue ?? 0xFFFFB300, // Amber
    );
  }

  /// Build a table lookup result section.
  static ResultSection tableLookup({
    required String tableName,
    required int roll,
    required String result,
  }) {
    return ResultSection(
      label: tableName,
      value: result,
      sublabel: 'Roll: $roll',
      relatedDice: [roll],
    );
  }

  /// Build a nested/child result section.
  static ResultSection nested({
    required String label,
    required String value,
    String? sublabel,
    List<int>? dice,
  }) {
    return ResultSection(
      label: label,
      value: value,
      sublabel: sublabel,
      relatedDice: dice,
    );
  }

  /// Build a property section (for NPC, settlement, etc.)
  static ResultSection property({
    required String property,
    required String intensity,
    List<int>? dice,
  }) {
    return ResultSection(
      label: 'Property',
      value: '$intensity $property',
      relatedDice: dice,
    );
  }

  /// Build a two-word meaning section (Discover Meaning style).
  static ResultSection twoWordMeaning({
    required String word1,
    required String word2,
    List<int>? dice,
  }) {
    return ResultSection(
      label: 'Meaning',
      value: '$word1 $word2',
      relatedDice: dice,
      isEmphasized: true,
    );
  }

  /// Build a location/area section with optional coordinates.
  static ResultSection location({
    required String name,
    String? sublabel,
    String? iconName,
    int? colorValue,
  }) {
    return ResultSection(
      label: 'Location',
      value: name,
      sublabel: sublabel,
      iconName: iconName ?? 'place',
      colorValue: colorValue,
    );
  }

  /// Build a monster/creature section.
  static ResultSection creature({
    required String description,
    String? level,
    List<int>? dice,
  }) {
    return ResultSection(
      label: 'Creature',
      value: description,
      sublabel: level,
      relatedDice: dice,
      iconName: 'pets',
    );
  }

  /// Build a challenge/difficulty section.
  static ResultSection challenge({
    required String description,
    String? dc,
    List<int>? dice,
  }) {
    return ResultSection(
      label: 'Challenge',
      value: description,
      sublabel: dc,
      relatedDice: dice,
      iconName: 'fitness_center',
    );
  }

  /// Build a plain text section.
  static ResultSection text({
    required String value,
    bool isEmphasized = false,
  }) {
    return ResultSection(
      value: value,
      isEmphasized: isEmphasized,
    );
  }

  /// Build a section from a sub-result (for nested results).
  static List<ResultSection> fromSubResult({
    required String prefix,
    required List<ResultSection> sections,
  }) {
    return sections.map((s) => ResultSection(
      label: s.label != null ? '$prefix: ${s.label}' : prefix,
      value: s.value,
      sublabel: s.sublabel,
      colorValue: s.colorValue,
      iconName: s.iconName,
      relatedDice: s.relatedDice,
      isEmphasized: s.isEmphasized,
    )).toList();
  }
}
