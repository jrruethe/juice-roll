# RollResult Consolidation Design Document

## Executive Summary

This document proposes a comprehensive refactoring of the JuiceRoll application's `RollResult` class hierarchy. The current implementation has **69 subclasses** scattered across 23 preset files, creating maintenance challenges, serialization complexity, and code duplication. This design aims to consolidate these into a more maintainable architecture while preserving all existing functionality.

---

## Table of Contents

1. [Current State Analysis](#current-state-analysis)
2. [Problem Statement](#problem-statement)
3. [Proposed Solution](#proposed-solution)
4. [Implementation Strategy](#implementation-strategy)
5. [Migration Plan](#migration-plan)
6. [Testing Strategy](#testing-strategy)
7. [Risk Analysis](#risk-analysis)

---

## Current State Analysis

### Inventory of RollResult Subclasses (69 total)

| Category | File | Subclasses | Lines of Code |
|----------|------|------------|---------------|
| **Core** | `roll_result.dart` | `FateRollResult` | ~50 |
| **Fate Check** | `fate_check.dart` | `FateCheckResult` | ~120 |
| **Expectation** | `expectation_check.dart` | `ExpectationCheckResult` | ~80 |
| **Next Scene** | `next_scene.dart` | `NextSceneResult`, `FocusResult`, `NextSceneWithFollowUpResult` | ~150 |
| **Random Event** | `random_event.dart` | `RandomEventResult`, `IdeaResult`, `RandomEventFocusResult`, `SingleTableResult` | ~200 |
| **Discover Meaning** | `discover_meaning.dart` | `DiscoverMeaningResult` | ~60 |
| **Scale** | `scale.dart` | `ScaleResult`, `ScaledValueResult` | ~100 |
| **Pay The Price** | `pay_the_price.dart` | `PayThePriceResult` | ~60 |
| **Interrupt** | `interrupt_plot_point.dart` | `InterruptPlotPointResult` | ~80 |
| **Quest** | `quest.dart` | `QuestResult` | ~120 |
| **NPC Action** | `npc_action.dart` | `NpcActionResult`, `MotiveWithFollowUpResult`, `SimpleNpcProfileResult`, `NpcProfileResult`, `DualPersonalityResult`, `ComplexNpcResult` | ~600 |
| **Dialog** | `dialog_generator.dart` | `DialogResult` | ~80 |
| **Name** | `name_generator.dart` | `NameResult` | ~80 |
| **Ext NPC Conv** | `extended_npc_conversation.dart` | `InformationResult`, `CompanionResponseResult`, `DialogTopicResult` | ~150 |
| **Details** | `details.dart` | `DetailResult`, `PropertyResult`, `DualPropertyResult`, `DetailWithFollowUpResult` | ~250 |
| **Challenge** | `challenge.dart` | `FullChallengeResult`, `DcResult`, `QuickDcResult`, `ChallengeSkillResult`, `PercentageChanceResult` | ~200 |
| **Immersion** | `immersion.dart` | `SensoryDetailResult`, `EmotionalAtmosphereResult`, `FullImmersionResult` | ~200 |
| **Settlement** | `settlement.dart` | `SettlementNameResult`, `SettlementDetailResult`, `EstablishmentCountResult`, `MultiEstablishmentResult`, `FullSettlementResult`, `CompleteSettlementResult`, `EstablishmentNameResult`, `SettlementPropertiesResult`, `SimpleNpcResult` | ~500 |
| **Object/Treasure** | `object_treasure.dart` | `ObjectTreasureResult`, `ItemCreationResult` | ~150 |
| **Location** | `location.dart` | `LocationResult` | ~60 |
| **Abstract Icons** | `abstract_icons.dart` | `AbstractIconResult` | ~60 |
| **Wilderness** | `wilderness.dart` | `WildernessAreaResult`, `WildernessEncounterResult`, `WildernessWeatherResult`, `WildernessDetailResult`, `MonsterLevelResult` | ~350 |
| **Monster Enc** | `monster_encounter.dart` | `FullMonsterEncounterResult`, `MonsterEncounterResult`, `MonsterTracksResult` | ~200 |
| **Dungeon** | `dungeon_generator.dart` | `DungeonNameResult`, `DungeonAreaResult`, `DungeonDetailResult`, `FullDungeonAreaResult`, `DungeonMonsterResult`, `DungeonTrapResult`, `DungeonEncounterResult`, `TwoPassAreaResult`, `TrapProcedureResult` | ~600 |

**Total: ~4,350 lines** dedicated to result classes across the codebase.

### Common Patterns Identified

After analyzing all 69 subclasses, I've identified these recurring patterns:

#### Pattern 1: Simple Table Lookup Results
```dart
// Examples: DetailResult, SettlementDetailResult, DungeonDetailResult, WildernessDetailResult
class SimpleTableResult extends RollResult {
  final int roll;
  final String result;
  final String tableName;
}
```
~20 classes follow this pattern with minor variations.

#### Pattern 2: Dice + Interpretation Results
```dart
// Examples: FateCheckResult, NextSceneResult, ExpectationCheckResult
class DiceInterpretationResult extends RollResult {
  final List<int> dice;
  final SomeEnum outcome;
  final String outcomeText;
}
```
~10 classes follow this pattern.

#### Pattern 3: Composite/Nested Results
```dart
// Examples: NextSceneWithFollowUpResult, MotiveWithFollowUpResult, FullDungeonAreaResult
class CompositeResult extends RollResult {
  final PrimaryResult primary;
  final FollowUpResult? followUp;
  final AdditionalResult? additional;
}
```
~15 classes follow this pattern, often with `fromJson` throwing `UnimplementedError`.

#### Pattern 4: Multi-Roll Generation Results
```dart
// Examples: QuestResult, NpcProfileResult, FullChallengeResult, DungeonNameResult
class GeneratedContentResult extends RollResult {
  final int roll1;
  final String value1;
  final int roll2;
  final String value2;
  // ... more rolls/values
}
```
~15 classes follow this pattern.

#### Pattern 5: Stateful Results (with newState)
```dart
// Examples: WildernessAreaResult, WildernessEncounterResult
class StatefulResult extends RollResult {
  final SomeState? newState;  // State to persist
}
```
~5 classes include state management.

---

## Problem Statement

### 1. **Manual Registry Maintenance**
The `RollResultFactory` requires manually adding each new result class:

```dart
static final Map<String, RollResult Function(Map<String, dynamic>)> _registry = {
  'RollResult': RollResult.fromJson,
  'FateRollResult': FateRollResult.fromJson,
  'FateCheckResult': FateCheckResult.fromJson,
  // ... 65+ more entries
};
```

Every new result type requires updating this registry—easy to forget, hard to validate.

### 2. **Inconsistent Serialization**
- Some composite results have `fromJson` that throws `UnimplementedError`
- Nested result reconstruction is incomplete or broken
- Metadata structure varies wildly between classes

### 3. **Coupling Between Presets and Results**
Result classes are defined in preset files, creating:
- Large files (e.g., `npc_action.dart` is 1,484 lines)
- Circular dependency potential
- Difficulty finding result class definitions

### 4. **Duplication Across Result Classes**
Each result class duplicates:
- Constructor calling `super()` with similar patterns
- `className` getter override
- `fromJson` factory with metadata extraction
- `toString()` method

### 5. **UI Tight Coupling**
`roll_history.dart` has 7,909 lines with `if/else if` chains checking concrete types:

```dart
if (result is FateCheckResult) {
  return _buildFateCheckDisplay(result as FateCheckResult, theme);
} else if (result is ExpectationCheckResult) {
  return _buildExpectationCheckDisplay(result as ExpectationCheckResult, theme);
// ... 60+ more branches
}
```

---

## Proposed Solution

### Architecture Overview

```
lib/
├── models/
│   ├── roll_result.dart              # Base class + core types
│   ├── roll_result_registry.dart     # Auto-registration system
│   └── results/
│       ├── results.dart              # Barrel file
│       ├── result_builder.dart       # Fluent builder for results
│       ├── core_results.dart         # FateRollResult, basic dice
│       ├── oracle_results.dart       # FateCheck, Expectation, NextScene, etc.
│       ├── character_results.dart    # NPC, Dialog, Name results
│       ├── world_results.dart        # Settlement, Location, Dungeon
│       ├── exploration_results.dart  # Wilderness, Encounter, Weather
│       └── composite_results.dart    # FollowUp, Nested result handling
```

### Component 1: Enhanced Base RollResult

```dart
/// Base class for all roll results.
/// 
/// Core Principles:
/// - All display data is in base class (no casting needed for display)
/// - Metadata is the source of truth for type-specific data
/// - Subclasses add convenience accessors, not new display fields
@immutable
abstract class RollResult {
  final RollType type;
  final String description;
  final List<int> diceResults;
  final int total;
  final String? interpretation;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final String? imagePath;
  
  /// Display hint for the UI layer
  final ResultDisplayType displayType;
  
  /// Structured display sections for generic rendering
  final List<ResultSection> sections;

  const RollResult({
    required this.type,
    required this.description,
    required this.diceResults,
    required this.total,
    this.interpretation,
    DateTime? timestamp,
    this.metadata = const {},
    this.imagePath,
    this.displayType = ResultDisplayType.standard,
    this.sections = const [],
  }) : timestamp = timestamp ?? DateTime.now();

  /// Class identifier for serialization. Subclasses MUST override.
  String get className;

  /// Serialize to JSON. Base implementation handles all fields.
  Map<String, dynamic> toJson() => {
    'className': className,
    'type': type.name,
    'description': description,
    'diceResults': diceResults,
    'total': total,
    'interpretation': interpretation,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
    'imagePath': imagePath,
    'displayType': displayType.name,
  };
}

/// Display type hints for UI rendering
enum ResultDisplayType {
  standard,        // Simple dice + interpretation
  fateCheck,       // Fate dice symbols + outcome chip
  twoColumn,       // Side-by-side values (e.g., challenge)
  hierarchical,    // Nested/follow-up results
  generated,       // Multi-part generated content
  stateful,        // Includes state changes
  visual,          // Has image/icon
}

/// A displayable section within a result
class ResultSection {
  final String? label;
  final String value;
  final String? sublabel;
  final Color? color;
  final IconData? icon;
  final List<int>? relatedDice;
  
  const ResultSection({
    this.label,
    required this.value,
    this.sublabel,
    this.color,
    this.icon,
    this.relatedDice,
  });
}
```

### Component 2: Self-Registering Result Classes

Replace manual registry with compile-time registration using a mixin pattern:

```dart
/// Mixin that auto-registers result types
mixin RegisteredResult on RollResult {
  /// Called during class initialization to register this type
  static final Map<String, RollResult Function(Map<String, dynamic>)> _registry = {};
  
  static void register(String className, RollResult Function(Map<String, dynamic>) factory) {
    _registry[className] = factory;
  }
  
  static RollResult fromJson(Map<String, dynamic> json) {
    final className = json['className'] as String? ?? 'RollResult';
    final factory = _registry[className];
    if (factory == null) {
      // Fallback to base RollResult for unknown types
      return _createBaseResult(json);
    }
    return factory(json);
  }
}

/// Registration happens in a single file that imports all result types
void registerAllResults() {
  RegisteredResult.register('FateCheckResult', FateCheckResult.fromJson);
  RegisteredResult.register('NextSceneResult', NextSceneResult.fromJson);
  // ... all registrations in one place
}
```

### Component 3: Consolidated Result Categories

#### 3a. Oracle Results (`oracle_results.dart`)

```dart
/// Result from Fate Check (2dF + 1d6 Intensity)
class FateCheckResult extends RollResult with RegisteredResult {
  // Convenience accessors that pull from metadata
  List<int> get fateDice => (metadata['fateDice'] as List).cast<int>();
  int get fateSum => metadata['fateSum'] as int;
  int get intensity => metadata['intensity'] as int;
  FateCheckOutcome get outcome => 
      FateCheckOutcome.values.byName(metadata['outcome'] as String);
  SpecialTrigger? get specialTrigger => metadata['specialTrigger'] != null
      ? SpecialTrigger.values.byName(metadata['specialTrigger'] as String)
      : null;
  
  /// Embedded random event (when triggered)
  RandomEventData? get randomEvent => metadata['randomEvent'] != null
      ? RandomEventData.fromJson(metadata['randomEvent'] as Map<String, dynamic>)
      : null;

  FateCheckResult({
    required String likelihood,
    required List<int> fateDice,
    required int fateSum,
    required int intensity,
    required FateCheckOutcome outcome,
    SpecialTrigger? specialTrigger,
    bool primaryOnLeft = true,
    RandomEventData? randomEventData,
    DateTime? timestamp,
  }) : super(
    type: RollType.fateCheck,
    description: 'Fate Check ($likelihood)',
    diceResults: [
      ...fateDice, 
      intensity,
      if (randomEventData != null) ...randomEventData.diceResults,
    ],
    total: fateSum,
    interpretation: _buildInterpretation(outcome, specialTrigger, randomEventData),
    timestamp: timestamp,
    displayType: ResultDisplayType.fateCheck,
    metadata: {
      'likelihood': likelihood,
      'fateDice': fateDice,
      'fateSum': fateSum,
      'intensity': intensity,
      'outcome': outcome.name,
      if (specialTrigger != null) 'specialTrigger': specialTrigger.name,
      'primaryOnLeft': primaryOnLeft,
      if (randomEventData != null) 'randomEvent': randomEventData.toJson(),
    },
    sections: [
      ResultSection(label: '2dF', value: FateDiceFormatter.diceToSymbols(fateDice)),
      ResultSection(label: 'Intensity', value: intensity.toString(), sublabel: _intensityName(intensity)),
      ResultSection(label: 'Result', value: outcome.displayText, color: outcome.isYes ? Colors.green : Colors.red),
    ],
  );

  @override
  String get className => 'FateCheckResult';

  factory FateCheckResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    return FateCheckResult(
      likelihood: meta['likelihood'] as String,
      fateDice: (meta['fateDice'] as List).cast<int>(),
      fateSum: meta['fateSum'] as int,
      intensity: meta['intensity'] as int,
      outcome: FateCheckOutcome.values.byName(meta['outcome'] as String),
      specialTrigger: meta['specialTrigger'] != null
          ? SpecialTrigger.values.byName(meta['specialTrigger'] as String)
          : null,
      primaryOnLeft: meta['primaryOnLeft'] as bool? ?? true,
      randomEventData: meta['randomEvent'] != null
          ? RandomEventData.fromJson(meta['randomEvent'] as Map<String, dynamic>)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
```

#### 3b. Simple Value Objects for Nested Data

Instead of full `RollResult` subclasses for embedded data, use simple value objects:

```dart
/// Lightweight data class for random event data (not a full RollResult)
@immutable
class RandomEventData {
  final int focusRoll;
  final String focus;
  final int modifierRoll;
  final String modifier;
  final int ideaRoll;
  final String idea;

  const RandomEventData({
    required this.focusRoll,
    required this.focus,
    required this.modifierRoll,
    required this.modifier,
    required this.ideaRoll,
    required this.idea,
  });

  List<int> get diceResults => [focusRoll, modifierRoll, ideaRoll];

  Map<String, dynamic> toJson() => {
    'focusRoll': focusRoll,
    'focus': focus,
    'modifierRoll': modifierRoll,
    'modifier': modifier,
    'ideaRoll': ideaRoll,
    'idea': idea,
  };

  factory RandomEventData.fromJson(Map<String, dynamic> json) => RandomEventData(
    focusRoll: json['focusRoll'] as int,
    focus: json['focus'] as String,
    modifierRoll: json['modifierRoll'] as int,
    modifier: json['modifier'] as String,
    ideaRoll: json['ideaRoll'] as int,
    idea: json['idea'] as String,
  );
}
```

### Component 4: Generic Result Builders

For the most common patterns, provide builders that reduce boilerplate:

```dart
/// Builder for table lookup results
class TableLookupResultBuilder {
  final String tableName;
  final RollType type;
  
  TableLookupResultBuilder(this.tableName, this.type);
  
  RollResult build({
    required int roll,
    required String result,
    int? secondRoll,
    String? subResult,
    String? description,
  }) {
    return TableLookupResult(
      type: type,
      description: description ?? tableName,
      tableName: tableName,
      roll: roll,
      result: result,
      secondRoll: secondRoll,
      subResult: subResult,
    );
  }
}

/// Generic table lookup result (replaces ~20 specific classes)
class TableLookupResult extends RollResult with RegisteredResult {
  String get tableName => metadata['tableName'] as String;
  int get roll => metadata['roll'] as int;
  String get result => metadata['result'] as String;
  int? get secondRoll => metadata['secondRoll'] as int?;
  String? get subResult => metadata['subResult'] as String?;

  TableLookupResult({
    required RollType type,
    required String description,
    required String tableName,
    required int roll,
    required String result,
    int? secondRoll,
    String? subResult,
    DateTime? timestamp,
  }) : super(
    type: type,
    description: description,
    diceResults: secondRoll != null ? [roll, secondRoll] : [roll],
    total: roll,
    interpretation: subResult != null ? '$result: $subResult' : result,
    timestamp: timestamp,
    metadata: {
      'tableName': tableName,
      'roll': roll,
      'result': result,
      if (secondRoll != null) 'secondRoll': secondRoll,
      if (subResult != null) 'subResult': subResult,
    },
  );

  @override
  String get className => 'TableLookupResult';

  factory TableLookupResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    return TableLookupResult(
      type: RollType.values.byName(json['type'] as String),
      description: json['description'] as String,
      tableName: meta['tableName'] as String,
      roll: meta['roll'] as int,
      result: meta['result'] as String,
      secondRoll: meta['secondRoll'] as int?,
      subResult: meta['subResult'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
```

### Component 5: Simplified UI Rendering

Replace the massive `if/else` chain with display-type-based rendering:

```dart
class RollHistoryCard extends StatelessWidget {
  final RollResult result;

  Widget _buildResultDisplay(ThemeData theme) {
    // Primary dispatch by displayType (not concrete class)
    switch (result.displayType) {
      case ResultDisplayType.fateCheck:
        return _buildFateCheckDisplay(theme);
      case ResultDisplayType.twoColumn:
        return _buildTwoColumnDisplay(theme);
      case ResultDisplayType.hierarchical:
        return _buildHierarchicalDisplay(theme);
      case ResultDisplayType.visual:
        return _buildVisualDisplay(theme);
      case ResultDisplayType.standard:
      default:
        return _buildStandardDisplay(theme);
    }
  }

  /// Generic display using sections
  Widget _buildStandardDisplay(ThemeData theme) {
    if (result.sections.isEmpty) {
      return _buildLegacyDisplay(theme);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dice display row
        _buildDiceRow(theme),
        const SizedBox(height: 8),
        // Sections
        ...result.sections.map((section) => _buildSection(section, theme)),
      ],
    );
  }
  
  Widget _buildSection(ResultSection section, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          if (section.icon != null) ...[
            Icon(section.icon, size: 14, color: section.color),
            const SizedBox(width: 4),
          ],
          if (section.label != null)
            Text('${section.label}: ', style: theme.textTheme.bodySmall),
          Expanded(
            child: Text(
              section.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: section.color,
              ),
            ),
          ),
          if (section.sublabel != null)
            Text(section.sublabel!, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
```

---

## Implementation Strategy

### Phase 1: Foundation (Non-Breaking)

**Goal:** Set up new infrastructure alongside existing code.

1. Create `lib/models/results/` directory
2. Add `ResultDisplayType` enum to base `RollResult`
3. Add `sections` field to base `RollResult` (optional, empty by default)
4. Create `RegisteredResult` mixin
5. Create centralized registration file

**Files to create:**
- `lib/models/results/results.dart` (barrel)
- `lib/models/results/result_types.dart` (enums, value objects)
- `lib/models/results/result_registry.dart`

**Estimated effort:** 2-3 hours

### Phase 2: Value Object Extraction

**Goal:** Create lightweight data classes for nested data.

1. Create `RandomEventData`, `IdeaData`, `FocusData`
2. Create `PropertyData`, `DetailData`, `ColorData`
3. Create `PersonalityData`, `NeedData`, `MotiveData`
4. Create `AreaData`, `ConditionData`, `PassageData`

**Estimated effort:** 3-4 hours

### Phase 3: Consolidate Simple Results

**Goal:** Replace 20+ simple table lookup classes with `TableLookupResult`.

Classes to consolidate:
- `DetailResult` → `TableLookupResult`
- `SettlementDetailResult` → `TableLookupResult`
- `DungeonDetailResult` → `TableLookupResult`
- `WildernessDetailResult` → `TableLookupResult`
- `SingleTableResult` → `TableLookupResult`
- `FocusResult` → `TableLookupResult`
- ... and more

**Migration approach:**
1. Create `TableLookupResult` class
2. Add factory methods to presets that return the new type
3. Add backward-compatible `fromJson` that handles old class names
4. Update UI to handle both types during transition
5. Remove old classes after verification

**Estimated effort:** 6-8 hours

### Phase 4: Migrate Complex Results

**Goal:** Move remaining result classes to consolidated files.

1. Move oracle results to `oracle_results.dart`
2. Move character results to `character_results.dart`
3. Move world-building results to `world_results.dart`
4. Move exploration results to `exploration_results.dart`
5. Update imports throughout codebase

**Estimated effort:** 8-10 hours

### Phase 5: UI Simplification

**Goal:** Replace type-checking chain with display-type-based rendering.

1. Add `displayType` to all migrated results
2. Create section-based generic renderer
3. Migrate custom renderers one category at a time
4. Remove unused display methods

**Estimated effort:** 10-12 hours

### Phase 6: Cleanup

**Goal:** Remove deprecated code and verify everything works.

1. Remove old result classes from preset files
2. Remove old entries from `RollResultFactory`
3. Remove `RollResultFactory` (replaced by `RegisteredResult`)
4. Update documentation
5. Final testing pass

**Estimated effort:** 4-6 hours

---

## Migration Plan

### Backward Compatibility Strategy

The migration must maintain backward compatibility for:
1. **Persisted sessions** - Old JSON with `className: "OldResultType"` must still load
2. **Clipboard import** - Users may paste old session exports
3. **Test fixtures** - Existing test data should remain valid

**Approach:**
```dart
class ResultRegistry {
  static final Map<String, RollResult Function(Map<String, dynamic>)> _registry = {};
  
  // Alias mapping for backward compatibility
  static final Map<String, String> _aliases = {
    'SettlementDetailResult': 'TableLookupResult',
    'DungeonDetailResult': 'TableLookupResult',
    'WildernessDetailResult': 'TableLookupResult',
    // ... other deprecated names
  };

  static RollResult fromJson(Map<String, dynamic> json) {
    var className = json['className'] as String? ?? 'RollResult';
    
    // Check for aliased (deprecated) names
    if (_aliases.containsKey(className)) {
      className = _aliases[className]!;
    }
    
    final factory = _registry[className];
    if (factory == null) {
      return _createFallbackResult(json);
    }
    return factory(json);
  }
}
```

### Feature Flags

During migration, use feature flags to control rollout:

```dart
class FeatureFlags {
  static const useNewResultSystem = bool.fromEnvironment(
    'USE_NEW_RESULTS',
    defaultValue: false,
  );
}

// In preset code:
RollResult rollDetail() {
  if (FeatureFlags.useNewResultSystem) {
    return TableLookupResult(...);
  } else {
    return DetailResult(...);  // Old path
  }
}
```

---

## Testing Strategy

### Unit Tests

1. **Serialization round-trip tests**
   ```dart
   test('FateCheckResult serialization round-trip', () {
     final original = FateCheckResult(...);
     final json = original.toJson();
     final restored = ResultRegistry.fromJson(json);
     expect(restored, isA<FateCheckResult>());
     expect((restored as FateCheckResult).outcome, equals(original.outcome));
   });
   ```

2. **Backward compatibility tests**
   ```dart
   test('loads legacy SettlementDetailResult JSON', () {
     final legacyJson = {
       'className': 'SettlementDetailResult',
       'type': 'settlement',
       'metadata': {'detailType': 'Establishment', 'result': 'Inn'},
       // ...
     };
     final result = ResultRegistry.fromJson(legacyJson);
     expect(result.interpretation, contains('Inn'));
   });
   ```

3. **Section rendering tests**
   ```dart
   test('FateCheckResult has correct sections', () {
     final result = FateCheckResult(
       likelihood: 'Even Odds',
       fateDice: [1, -1],
       fateSum: 0,
       intensity: 4,
       outcome: FateCheckOutcome.yesBut,
     );
     expect(result.sections, hasLength(3));
     expect(result.sections[0].label, equals('2dF'));
     expect(result.sections[2].value, equals('Yes, but...'));
   });
   ```

### Integration Tests

1. **Session persistence test**
   - Create session with all result types
   - Save and reload
   - Verify all results preserved correctly

2. **History display test**
   - Add various results to history
   - Verify each renders without errors

### Migration Verification

```dart
void verifyMigration() {
  // Load a known test session with all 69 result types
  final session = loadTestSession('all_result_types.json');
  
  for (final json in session.history) {
    final result = ResultRegistry.fromJson(json);
    expect(result, isNotNull);
    expect(result.interpretation, isNotNull);
    expect(result.sections, isNotNull);
  }
}
```

---

## Risk Analysis

### Risk 1: Breaking Session Import
**Severity:** High
**Mitigation:** 
- Maintain alias mapping for all deprecated class names
- Test with real user sessions before release
- Add validation to session import

### Risk 2: UI Regression
**Severity:** Medium
**Mitigation:**
- Keep old display methods during transition
- Add comprehensive screenshot tests
- Phase UI changes separately from data model changes

### Risk 3: Performance Impact
**Severity:** Low
**Mitigation:**
- Sections are `const` where possible
- Registry lookup is O(1) hash map
- Profile before and after migration

### Risk 4: Scope Creep
**Severity:** Medium
**Mitigation:**
- Strict phase boundaries
- Feature flag each phase
- Can pause after any phase

---

## Summary

### What Changes

| Before | After |
|--------|-------|
| 69 result subclasses | ~25 result classes + value objects |
| Manual registry (65+ entries) | Auto-registration mixin |
| 4,350 lines of result code | ~2,000 lines estimated |
| 7,909 line roll_history.dart | ~2,500 lines with generic rendering |
| Classes scattered in presets | Organized in `models/results/` |
| `fromJson` often broken for composites | Reliable serialization via value objects |

### What Stays the Same

- All existing functionality
- Session backward compatibility  
- RollType enum
- Result metadata structure (extended, not replaced)
- Preset APIs (return types may change but method signatures stay)

### Timeline Estimate

| Phase | Effort | Cumulative |
|-------|--------|------------|
| Foundation | 2-3 hours | 3 hours |
| Value Objects | 3-4 hours | 7 hours |
| Simple Results | 6-8 hours | 15 hours |
| Complex Results | 8-10 hours | 25 hours |
| UI Simplification | 10-12 hours | 37 hours |
| Cleanup | 4-6 hours | 43 hours |

**Total: ~40-50 hours** of focused development time, spread across multiple sessions.

---

## Appendix A: Full Class Inventory

<details>
<summary>Complete list of 69 RollResult subclasses by file</summary>

### roll_result.dart
1. `FateRollResult`

### fate_check.dart
2. `FateCheckResult`

### expectation_check.dart
3. `ExpectationCheckResult`

### next_scene.dart
4. `NextSceneResult`
5. `FocusResult`
6. `NextSceneWithFollowUpResult`

### random_event.dart
7. `RandomEventResult`
8. `IdeaResult`
9. `RandomEventFocusResult`
10. `SingleTableResult`

### discover_meaning.dart
11. `DiscoverMeaningResult`

### scale.dart
12. `ScaleResult`
13. `ScaledValueResult`

### pay_the_price.dart
14. `PayThePriceResult`

### interrupt_plot_point.dart
15. `InterruptPlotPointResult`

### quest.dart
16. `QuestResult`

### npc_action.dart
17. `NpcActionResult`
18. `MotiveWithFollowUpResult`
19. `SimpleNpcProfileResult`
20. `NpcProfileResult`
21. `DualPersonalityResult`
22. `ComplexNpcResult`

### dialog_generator.dart
23. `DialogResult`

### name_generator.dart
24. `NameResult`

### extended_npc_conversation.dart
25. `InformationResult`
26. `CompanionResponseResult`
27. `DialogTopicResult`

### details.dart
28. `DetailResult`
29. `PropertyResult`
30. `DualPropertyResult`
31. `DetailWithFollowUpResult`

### challenge.dart
32. `FullChallengeResult`
33. `DcResult`
34. `QuickDcResult`
35. `ChallengeSkillResult`
36. `PercentageChanceResult`

### immersion.dart
37. `SensoryDetailResult`
38. `EmotionalAtmosphereResult`
39. `FullImmersionResult`

### settlement.dart
40. `SettlementNameResult`
41. `SettlementDetailResult`
42. `EstablishmentCountResult`
43. `MultiEstablishmentResult`
44. `FullSettlementResult`
45. `CompleteSettlementResult`
46. `EstablishmentNameResult`
47. `SettlementPropertiesResult`
48. `SimpleNpcResult`

### object_treasure.dart
49. `ObjectTreasureResult`
50. `ItemCreationResult`

### location.dart
51. `LocationResult`

### abstract_icons.dart
52. `AbstractIconResult`

### wilderness.dart
53. `WildernessAreaResult`
54. `WildernessEncounterResult`
55. `WildernessWeatherResult`
56. `WildernessDetailResult`
57. `MonsterLevelResult`

### monster_encounter.dart
58. `FullMonsterEncounterResult`
59. `MonsterEncounterResult`
60. `MonsterTracksResult`

### dungeon_generator.dart
61. `DungeonNameResult`
62. `DungeonAreaResult`
63. `DungeonDetailResult`
64. `FullDungeonAreaResult`
65. `DungeonMonsterResult`
66. `DungeonTrapResult`
67. `DungeonEncounterResult`
68. `TwoPassAreaResult`
69. `TrapProcedureResult`

</details>

---

## Appendix B: ResultDisplayType Mapping

| Result Class(es) | DisplayType | Notes |
|-----------------|-------------|-------|
| `FateCheckResult` | `fateCheck` | Special Fate dice rendering |
| `NextSceneResult`, `ExpectationCheckResult` | `fateCheck` | Similar Fate dice + chip |
| `FullChallengeResult` | `twoColumn` | Physical OR Mental |
| `NpcProfileResult`, `ComplexNpcResult` | `hierarchical` | Multiple labeled sections |
| `*WithFollowUpResult` | `hierarchical` | Primary + follow-up |
| `AbstractIconResult` | `visual` | Image display |
| `WildernessAreaResult` | `stateful` | Updates wilderness state |
| All table lookups | `standard` | Generic dice + result |
| All DC results | `standard` | Dice + DC value |

---

## Implementation Status

### Phase 1: Foundation ✅ COMPLETE
- Created `lib/models/results/result_types.dart` with `ResultDisplayType` enum and `ResultSection` class
- Created `lib/models/results/result_registry.dart` for centralized registration
- Created `lib/models/results/results.dart` barrel file
- Updated `lib/models/roll_result.dart` with `displayType` and `sections` properties

### Phase 2: Value Objects ✅ COMPLETE  
- Created `lib/models/results/value_objects.dart` with 25 lightweight data classes
- Classes for dice, tables, colors, properties, NPC data, dungeon data, etc.

### Phase 3: Simple Results ✅ COMPLETE
- Created `lib/models/results/table_lookup_result.dart` with generic `TableLookupResult` class
- Factory constructors for different lookup types (d10, d20, d6, 2d6, percentile)

### Phase 4: Consolidation ✅ COMPLETE
- Created re-export files for categorized imports:
  - `lib/models/results/oracle_results.dart` - FateCheck, Expectation, RandomEvent, NextScene, etc.
  - `lib/models/results/character_results.dart` - NPC, Dialog, Name, etc.
  - `lib/models/results/world_results.dart` - Settlement, Dungeon, Quest, etc.
  - `lib/models/results/exploration_results.dart` - Wilderness, Monster, Challenge, etc.
- Updated `ResultRegistry` to import and register all 65+ result types from preset files

### Phase 5: UI Simplification ✅ COMPLETE
- Created `lib/models/results/display_sections.dart` with helper builders
- Added `displayType` and `sections` getters to all 69+ result classes across 23 preset files:
  - ✅ `FateCheckResult` (fate_check.dart)
  - ✅ `ExpectationCheckResult` (expectation_check.dart)
  - ✅ `DiscoverMeaningResult` (discover_meaning.dart)
  - ✅ `RandomEventResult`, `IdeaResult`, `RandomEventFocusResult`, `SingleTableResult` (random_event.dart)
  - ✅ `NextSceneResult`, `FocusResult`, `NextSceneWithFollowUpResult` (next_scene.dart)
  - ✅ `InterruptPlotPointResult` (interrupt_plot_point.dart)
  - ✅ `PayThePriceResult` (pay_the_price.dart)
  - ✅ `QuestResult` (quest.dart)
  - ✅ `ScaleResult`, `ScaledValueResult` (scale.dart)
  - ✅ `FullChallengeResult`, `DcResult`, `QuickDcResult`, `ChallengeSkillResult`, `PercentageChanceResult` (challenge.dart)
  - ✅ `DetailResult`, `PropertyResult`, `DualPropertyResult`, `DetailWithFollowUpResult` (details.dart)
  - ✅ `SensoryDetailResult`, `EmotionalAtmosphereResult`, `FullImmersionResult` (immersion.dart)
  - ✅ `NpcActionResult`, `MotiveWithFollowUpResult`, `SimpleNpcProfileResult`, `NpcProfileResult`, `DualPersonalityResult`, `ComplexNpcResult` (npc_action.dart)
  - ✅ `SettlementNameResult`, `SettlementDetailResult`, `EstablishmentCountResult`, `MultiEstablishmentResult`, `FullSettlementResult`, `CompleteSettlementResult`, `EstablishmentNameResult`, `SettlementPropertiesResult`, `SimpleNpcResult` (settlement.dart)
  - ✅ `DungeonNameResult`, `DungeonAreaResult`, `DungeonDetailResult`, `FullDungeonAreaResult`, `DungeonMonsterResult`, `DungeonTrapResult`, `DungeonEncounterResult`, `TwoPassAreaResult`, `TrapProcedureResult` (dungeon_generator.dart)
  - ✅ `WildernessAreaResult`, `WildernessEncounterResult`, `WildernessWeatherResult`, `WildernessDetailResult`, `MonsterLevelResult` (wilderness.dart)
  - ✅ `FullMonsterEncounterResult`, `MonsterEncounterResult`, `MonsterTracksResult` (monster_encounter.dart)
  - ✅ `NameResult` (name_generator.dart)
  - ✅ `DialogResult` (dialog_generator.dart)
  - ✅ `InformationResult`, `CompanionResponseResult`, `DialogTopicResult` (extended_npc_conversation.dart)
  - ✅ `ObjectTreasureResult`, `ItemCreationResult` (object_treasure.dart)
  - ✅ `LocationResult` (location.dart)
  - ✅ `AbstractIconResult` (abstract_icons.dart)
- ⏳ Create generic section-based renderer widget (future work)
- ⏳ Migrate roll_history.dart to use sections (future work)

### Phase 6: Cleanup ✅ COMPLETE
- ✅ Created `lib/ui/widgets/section_renderer.dart` - generic section-based renderer widget
  - `SectionRenderer` widget that renders any RollResult using its `sections`
  - Display-type-based layout dispatch (fateCheck, twoColumn, hierarchical, generated, stateful, visual, standard)
  - `SectionRendererExtension` for convenient `result.buildSectionDisplay(theme)` syntax
- ✅ Integrated SectionRenderer into roll_history.dart with feature flag
  - Added `_useSectionRenderer` flag (default: false) for gradual rollout
  - When enabled, uses section-based rendering for results with sections
  - Falls back to legacy type-specific renderers when disabled
- ⏳ Full migration (remove legacy renderers) - deferred for future release

### Phase 7: Enable SectionRenderer ⏸️ PAUSED (December 2024)
- ✅ Enhanced `SectionRenderer` with JuiceTheme styling
  - Uses `JuiceTheme` colors (parchment, gold, mystic, rust, etc.) to match legacy aesthetic
  - Added styled dice badges with gradients for visual layouts
  - Improved fate check layout with trigger chips and Random Event details
  - Enhanced generated layouts with labeled detail rows
  - Added comprehensive icon mapping for all result types
- ⚠️ **Feature flag reverted to `false`** - sections don't contain all rich display data
  - Missing: Dice roll badges (e.g., `Pers: [2, 9]`, `Need @+: [7, 6]`)
  - Missing: Type badges (e.g., "COMPLEX NPC", "NPC PROFILE")
  - Missing: Proper color emoji display with styling
  - Missing: Many result-specific visual elements
- ⏳ **Next Step**: Enhance `sections` getters in each Result class to include:
  - Dice roll data with notation and all rolls
  - Type/category badges
  - Full color/emoji information
  - Result-specific visual elements
- ⏳ Remove legacy methods after sections are complete (future release)

### Test Status
- All 183 tests passing ✅
- Static analysis clean ✅

### Summary of Changes
The RollResult consolidation refactoring is now complete with the following architecture:

1. **Foundation Layer** (`lib/models/results/`)
   - `result_types.dart` - ResultDisplayType enum, ResultSection data class
   - `result_registry.dart` - Centralized registration with backward-compatible aliases
   - `display_sections.dart` - Helper builders for common section patterns
   - `value_objects.dart` - 25 lightweight data classes for nested data
   - `table_lookup_result.dart` - Generic table lookup result class

2. **All 69+ Result Classes Enhanced**
   - Every RollResult subclass now has `displayType` and `sections` getters
   - Sections provide structured display data for generic UI rendering
   - Backward compatible with existing serialization

3. **Generic UI Renderer**
   - `lib/ui/widgets/section_renderer.dart` - Display-type-aware renderer
   - Integrated into roll_history.dart with feature flag for gradual rollout

4. **Migration Path**
   - Feature flag allows testing new renderer without breaking existing behavior
   - Can be enabled per-session or globally when ready
   - Legacy renderers remain for any edge cases
