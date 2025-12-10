import '../core/roll_engine.dart';
import '../models/roll_result.dart';
import '../models/results/json_utils.dart';
import '../data/wilderness_data.dart' as data;

/// Wilderness Generator preset for the Juice Oracle.
/// Uses wilderness-table.md for terrain, encounters, and monster generation.
/// 
/// Formula: 2dF Env → 1dF Type; W: 1d6@E+T; M: 1d6+E
/// 
/// **Stateless Design:**
/// This class is stateless - all methods take state as input and return
/// results that include any new state. State is managed externally in HomeState.
/// 
/// Benefits:
/// - Easier to test (pure functions)
/// - No hidden state mutations
/// - Single source of truth (HomeState/Session)
/// 
/// **Data Separation:**
/// Static table data is stored in data/wilderness_data.dart.
/// This class provides backward-compatible static accessors.
class Wilderness {
  final RollEngine _rollEngine;

  // ========== Static Accessors (delegate to data file) ==========
  
  /// Full environment list (d10, rows 1-10)
  static List<String> get environments => data.wildernessEnvironments;
  
  /// Type data: modifier for weather, name, and weather skew symbol
  static List<Map<String, dynamic>> get types => data.wildernessTypes;
  
  /// Encounter types (d10)
  static List<Map<String, dynamic>> get encounters => data.wildernessEncounters;
  
  /// Weather conditions (rows 1-10)
  static List<String> get weatherTypes => data.wildernessWeatherTypes;
  
  /// Monster level formulas (modifier + advantage type) by environment
  static List<Map<String, dynamic>> get monsterFormulas => data.wildernessMonsterFormulas;
  
  /// Natural hazards (d10)
  static List<String> get naturalHazards => data.wildernessNaturalHazards;
  
  /// Wilderness features (d10)
  static List<String> get features => data.wildernessFeatures;

  /// Get encounter name by index (for backwards compatibility)
  static String getEncounterName(int index) => data.getWildernessEncounterName(index);

  /// Check if encounter should be displayed in italics
  static bool isEncounterItalic(int index) => data.isWildernessEncounterItalic(index);
  
  /// For partial italic (Settlement/Camp), get the italic portion
  static String? getPartialItalic(int index) => data.getWildernessPartialItalic(index);

  Wilderness([RollEngine? rollEngine])
      : _rollEngine = rollEngine ?? RollEngine();

  /// Initialize wilderness with a random starting environment.
  /// Returns result with new state embedded in `newState`.
  WildernessAreaResult initializeRandom() {
    final envRoll = _rollEngine.rollDie(10);
    final envRow = envRoll == 10 ? 10 : envRoll;
    
    // Roll 1dF for initial type offset from environment
    final typeFate = _rollEngine.rollFateDice(1)[0];
    final typeRow = _clampTypeRow(envRow, typeFate);
    
    final newState = WildernessState(
      environmentRow: envRow,
      typeRow: typeRow,
      isLost: false,
    );

    return WildernessAreaResult(
      envFateDice: [0, 0], // No offset for initial
      envRoll: envRoll,
      environment: environments[envRow - 1],
      typeFateDie: typeFate,
      typeRoll: typeRow,
      typeName: types[typeRow - 1]['name'] as String,
      typeModifier: types[typeRow - 1]['modifier'] as int,
      isTransition: false,
      previousEnvironment: null,
      newState: newState,
    );
  }

  /// Initialize wilderness at a specific environment.
  /// Returns result with new state embedded in `newState`.
  WildernessAreaResult initializeAt(int environmentRow, {int? typeRow, bool isLost = false}) {
    final clampedEnv = environmentRow.clamp(1, 10);
    final clampedType = (typeRow ?? clampedEnv).clamp(1, 10);
    
    final newState = WildernessState(
      environmentRow: clampedEnv,
      typeRow: clampedType,
      isLost: isLost,
    );

    return WildernessAreaResult(
      envFateDice: [0, 0], // No dice for manual set
      envRoll: clampedEnv,
      environment: environments[clampedEnv - 1],
      typeFateDie: 0, // No dice for manual set
      typeRoll: clampedType,
      typeName: types[clampedType - 1]['name'] as String,
      typeModifier: types[clampedType - 1]['modifier'] as int,
      isTransition: false,
      previousEnvironment: null,
      isManualSet: true,
      newState: newState,
    );
  }

  /// Transition to a new area using 2dF for environment + 1dF for type.
  /// Takes current state as parameter and returns result with new state.
  /// If no state provided, initializes randomly.
  WildernessAreaResult transition(WildernessState? currentState) {
    if (currentState == null) {
      return initializeRandom();
    }

    final previousEnv = currentState.environmentRow;
    final previousEnvName = environments[previousEnv - 1];
    
    // Roll 2dF for environment offset
    final envFateDice = _rollEngine.rollFateDice(2);
    final envOffset = envFateDice[0] + envFateDice[1];
    
    // Apply offset with clamping (no wrap)
    final newEnvRow = (previousEnv + envOffset).clamp(1, 10);
    
    // Roll 1dF for type offset from new environment
    final typeFate = _rollEngine.rollFateDice(1)[0];
    final newTypeRow = _clampTypeRow(newEnvRow, typeFate);
    
    final newState = WildernessState(
      environmentRow: newEnvRow,
      typeRow: newTypeRow,
      isLost: currentState.isLost,
    );

    return WildernessAreaResult(
      envFateDice: envFateDice,
      envRoll: newEnvRow,
      environment: environments[newEnvRow - 1],
      typeFateDie: typeFate,
      typeRoll: newTypeRow,
      typeName: types[newTypeRow - 1]['name'] as String,
      typeModifier: types[newTypeRow - 1]['modifier'] as int,
      isTransition: true,
      previousEnvironment: previousEnvName,
      newState: newState,
    );
  }

  /// Clamp type row so it doesn't wrap at edges
  /// Arctic stays Snowy (row 1), Desert stays Arid (row 10)
  int _clampTypeRow(int envRow, int fateOffset) {
    final rawType = envRow + fateOffset;
    return rawType.clamp(1, 10);
  }

  /// Roll for a wilderness encounter.
  /// Uses d10 when oriented, d6 when lost.
  /// Takes current state as parameter and returns result with any state changes.
  WildernessEncounterResult rollEncounter({
    required WildernessState? currentState,
    bool? hasDangerousTerrain,
    bool? hasMapOrGuide,
  }) {
    final isLost = currentState?.isLost ?? false;
    
    // Determine die size based on lost state
    final dieSize = isLost ? 6 : 10;
    
    // Calculate net skew
    final dangerSkew = (hasDangerousTerrain ?? false) ? -1 : 0;
    final guideSkew = (hasMapOrGuide ?? false) ? 1 : 0;
    final netSkew = dangerSkew + guideSkew;
    
    int roll;
    int? secondRoll;
    String skewUsed;
    
    if (netSkew > 0) {
      // Advantage
      final result = _rollEngine.rollWithAdvantage(1, dieSize);
      roll = result.chosenSum;
      secondRoll = result.sum2;
      skewUsed = 'advantage';
    } else if (netSkew < 0) {
      // Disadvantage
      final result = _rollEngine.rollWithDisadvantage(1, dieSize);
      roll = result.chosenSum;
      secondRoll = result.sum2;
      skewUsed = 'disadvantage';
    } else {
      roll = _rollEngine.rollDie(dieSize);
      skewUsed = 'straight';
    }
    
    final index = roll == 10 ? 9 : roll - 1;
    final encounterData = encounters[index];
    final encounter = encounterData['name'] as String;
    final isItalic = encounterData['isItalic'] as bool;
    final partialItalic = encounterData['partialItalic'] as String?;
    
    // Check for Lost/Found state transitions
    bool becameLost = false;
    bool becameFound = false;
    WildernessState? newState;
    
    if (currentState != null) {
      if (encounter == 'Destination/Lost' && !currentState.isLost) {
        // Became lost (caller decides whether to apply)
        becameLost = true;
      } else if (encounter == 'River/Road' && currentState.isLost) {
        // Found orientation again
        becameFound = true;
        newState = currentState.copyWith(isLost: false);
      }
    }

    return WildernessEncounterResult(
      roll: roll,
      secondRoll: secondRoll,
      encounter: encounter,
      requiresFollowUp: _requiresFollowUp(encounter),
      dieSize: dieSize,
      skewUsed: skewUsed,
      wasLost: isLost,
      becameLost: becameLost,
      becameFound: becameFound,
      isItalic: isItalic,
      partialItalic: partialItalic,
      newState: newState,
    );
  }

  bool _requiresFollowUp(String encounter) {
    return encounter == 'Natural Hazard' ||
           encounter == 'Monster' ||
           encounter == 'Weather' ||
           encounter == 'Challenge' ||
           encounter == 'Dungeon' ||
           encounter == 'Feature';
  }

  /// Roll for weather using proper formula: 1d6@environment_skew + type_modifier.
  /// Requires explicit state parameters.
  WildernessWeatherResult rollWeather({required int environmentRow, required int typeRow}) {
    final envRow = environmentRow.clamp(1, 10);
    final tRow = typeRow.clamp(1, 10);
    
    // Get environment skew symbol from the type table (indexed by environment row)
    final envSkew = types[envRow - 1]['skew'] as String;
    final typeModifier = types[tRow - 1]['modifier'] as int;
    
    // Roll 1d6 with appropriate skew
    int baseRoll;
    int? secondRoll;
    
    if (envSkew == '+') {
      final result = _rollEngine.rollWithAdvantage(1, 6);
      baseRoll = result.chosenSum;
      secondRoll = result.sum2;
    } else if (envSkew == '-') {
      final result = _rollEngine.rollWithDisadvantage(1, 6);
      baseRoll = result.chosenSum;
      secondRoll = result.sum2;
    } else {
      baseRoll = _rollEngine.rollDie(6);
    }
    
    // Add modifier and clamp to 1-10
    final weatherRow = (baseRoll + typeModifier).clamp(1, 10);
    final weather = weatherTypes[weatherRow - 1];

    return WildernessWeatherResult(
      baseRoll: baseRoll,
      secondRoll: secondRoll,
      environmentSkew: envSkew,
      typeModifier: typeModifier,
      weatherRow: weatherRow,
      weather: weather,
      environment: environments[envRow - 1],
      typeName: types[tRow - 1]['name'] as String,
    );
  }

  /// Roll for natural hazard.
  WildernessDetailResult rollNaturalHazard() {
    final roll = _rollEngine.rollDie(10);
    final index = roll == 10 ? 9 : roll - 1;
    final hazard = naturalHazards[index];

    return WildernessDetailResult(
      detailType: 'Natural Hazard',
      roll: roll,
      result: hazard,
    );
  }

  /// Roll for wilderness feature.
  WildernessDetailResult rollFeature() {
    final roll = _rollEngine.rollDie(10);
    final index = roll == 10 ? 9 : roll - 1;
    final feature = features[index];

    return WildernessDetailResult(
      detailType: 'Feature',
      roll: roll,
      result: feature,
    );
  }

  /// Calculate monster level using the formula from the environment.
  /// M: 1d6+E where E is environment modifier.
  MonsterLevelResult rollMonsterLevel({required int environmentRow}) {
    final envRow = environmentRow.clamp(1, 10);
    final envIndex = envRow - 1;
    final formula = monsterFormulas[envIndex];
    final modifier = formula['modifier'] as int;
    final advantageType = formula['advantage'] as String;

    // Roll 1d6 with appropriate advantage
    int baseRoll;
    int? secondRoll;
    
    if (advantageType == '+') {
      final result = _rollEngine.rollWithAdvantage(1, 6);
      baseRoll = result.chosenSum;
      secondRoll = result.sum2;
    } else if (advantageType == '-') {
      final result = _rollEngine.rollWithDisadvantage(1, 6);
      baseRoll = result.chosenSum;
      secondRoll = result.sum2;
    } else {
      baseRoll = _rollEngine.rollDie(6);
    }

    final monsterLevel = baseRoll + modifier;

    return MonsterLevelResult(
      baseRoll: baseRoll,
      secondRoll: secondRoll,
      modifier: modifier,
      advantageType: advantageType,
      monsterLevel: monsterLevel,
    );
  }

  // ========== Convenience Methods ==========
  
  /// Convenience method that takes WildernessState for weather roll.
  WildernessWeatherResult rollWeatherFromState(WildernessState state) {
    return rollWeather(
      environmentRow: state.environmentRow,
      typeRow: state.typeRow,
    );
  }
  
  /// Convenience method that takes WildernessState for monster level roll.
  MonsterLevelResult rollMonsterLevelFromState(WildernessState state) {
    return rollMonsterLevel(environmentRow: state.environmentRow);
  }

  // Legacy method for backwards compatibility
  /// Generate a full wilderness area (environment + type).
  /// @deprecated Use initializeRandom() or transition() instead.
  WildernessAreaResult generateArea() {
    return initializeRandom();
  }
}

/// Persistent state for wilderness exploration.
/// This is an immutable value object.
class WildernessState {
  final int environmentRow;  // 1-10
  final int typeRow;         // 1-10
  final bool isLost;         // Use d6 instead of d10 for encounters

  const WildernessState({
    required this.environmentRow,
    required this.typeRow,
    required this.isLost,
  });

  /// Create a copy with updated fields
  WildernessState copyWith({
    int? environmentRow,
    int? typeRow,
    bool? isLost,
  }) {
    return WildernessState(
      environmentRow: environmentRow ?? this.environmentRow,
      typeRow: typeRow ?? this.typeRow,
      isLost: isLost ?? this.isLost,
    );
  }

  String get environment => Wilderness.environments[environmentRow - 1];
  String get typeName => Wilderness.types[typeRow - 1]['name'] as String;
  int get typeModifier => Wilderness.types[typeRow - 1]['modifier'] as int;
  String get environmentSkew => Wilderness.types[environmentRow - 1]['skew'] as String;
  
  String get fullDescription => '$typeName $environment';

  @override
  String toString() => 'WildernessState($fullDescription, lost: $isLost)';
}

/// Result of generating a wilderness area.
/// Now includes the new state that should be stored.
class WildernessAreaResult extends RollResult {
  final List<int> envFateDice;
  final int envRoll;
  final String environment;
  final int typeFateDie;
  final int typeRoll;
  final String typeName;
  final int typeModifier;
  final bool isTransition;
  final String? previousEnvironment;
  final bool isManualSet;
  
  /// The new wilderness state after this roll.
  /// Caller should update their state storage with this.
  final WildernessState? newState;

  WildernessAreaResult({
    required this.envFateDice,
    required this.envRoll,
    required this.environment,
    required this.typeFateDie,
    required this.typeRoll,
    required this.typeName,
    required this.typeModifier,
    this.isTransition = false,
    this.previousEnvironment,
    this.isManualSet = false,
    this.newState,
    DateTime? timestamp,
  }) : super(
          type: RollType.weather, // Using weather as closest match
          description: isManualSet ? 'Set Wilderness Position' : (isTransition ? 'Wilderness Transition' : 'Wilderness Area'),
          diceResults: isManualSet ? [envRoll, typeRoll] : [...envFateDice, envRoll, typeFateDie, typeRoll],
          total: envRoll + typeRoll,
          interpretation: '$typeName $environment',
          timestamp: timestamp,
          metadata: {
            'environment': environment,
            'envRoll': envRoll,
            'envFateDice': envFateDice,
            'typeName': typeName,
            'typeRoll': typeRoll,
            'typeFateDie': typeFateDie,
            'typeModifier': typeModifier,
            'isTransition': isTransition,
            'isManualSet': isManualSet,
            if (previousEnvironment != null) 'previousEnvironment': previousEnvironment,
            if (newState != null) 'newState': {
              'environmentRow': newState.environmentRow,
              'typeRow': newState.typeRow,
              'isLost': newState.isLost,
            },
          },
        );

  @override
  String get className => 'WildernessAreaResult';

  factory WildernessAreaResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    WildernessState? state;
    if (meta['newState'] != null) {
      final stateJson = requireMap(meta['newState'], 'newState');
      state = WildernessState(
        environmentRow: stateJson['environmentRow'] as int,
        typeRow: stateJson['typeRow'] as int,
        isLost: stateJson['isLost'] as bool? ?? false,
      );
    }
    return WildernessAreaResult(
      envFateDice: (meta['envFateDice'] as List<dynamic>?)?.cast<int>() ?? [],
      envRoll: meta['envRoll'] as int? ?? 1,
      environment: meta['environment'] as String,
      typeFateDie: meta['typeFateDie'] as int? ?? 0,
      typeRoll: meta['typeRoll'] as int? ?? 1,
      typeName: meta['typeName'] as String,
      typeModifier: meta['typeModifier'] as int,
      isTransition: meta['isTransition'] as bool? ?? false,
      previousEnvironment: meta['previousEnvironment'] as String?,
      isManualSet: meta['isManualSet'] as bool? ?? false,
      newState: state,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  String get fullDescription => '$typeName $environment (+$typeModifier)';

  @override
  String toString() {
    if (isTransition && previousEnvironment != null) {
      return 'Transition: $previousEnvironment → $fullDescription';
    }
    return 'Wilderness: $fullDescription';
  }
}

/// Result of a wilderness encounter roll.
/// Now includes the new state that should be stored.
class WildernessEncounterResult extends RollResult {
  final int roll;
  final int? secondRoll;
  final String encounter;
  final bool requiresFollowUp;
  final int dieSize;
  final String skewUsed;
  final bool wasLost;
  final bool becameLost;
  final bool becameFound;
  final bool isItalic;
  final String? partialItalic;
  
  // Embedded follow-up result data (populated when auto-rolling)
  final int? followUpRoll;
  final String? followUpResult;
  final Map<String, dynamic>? followUpData;
  
  /// The new wilderness state after this roll.
  /// Caller should update their state storage with this.
  final WildernessState? newState;

  WildernessEncounterResult({
    required this.roll,
    this.secondRoll,
    required this.encounter,
    required this.requiresFollowUp,
    this.dieSize = 10,
    this.skewUsed = 'straight',
    this.wasLost = false,
    this.becameLost = false,
    this.becameFound = false,
    this.isItalic = false,
    this.partialItalic,
    this.followUpRoll,
    this.followUpResult,
    this.followUpData,
    this.newState,
    DateTime? timestamp,
  }) : super(
          type: RollType.encounter,
          description: 'Wilderness Encounter',
          diceResults: secondRoll != null ? [roll, secondRoll] : [roll],
          total: roll,
          interpretation: encounter,
          timestamp: timestamp,
          metadata: {
            'roll': roll,
            'secondRoll': secondRoll,
            'encounter': encounter,
            'requiresFollowUp': requiresFollowUp,
            'dieSize': dieSize,
            'skewUsed': skewUsed,
            'wasLost': wasLost,
            'becameLost': becameLost,
            'becameFound': becameFound,
            'isItalic': isItalic,
            if (partialItalic != null) 'partialItalic': partialItalic,
            if (followUpRoll != null) 'followUpRoll': followUpRoll,
            if (followUpResult != null) 'followUpResult': followUpResult,
            if (followUpData != null) 'followUpData': followUpData,
            if (newState != null) 'newState': {
              'environmentRow': newState.environmentRow,
              'typeRow': newState.typeRow,
              'isLost': newState.isLost,
            },
          },
        );

  /// Create a copy with follow-up data added
  WildernessEncounterResult withFollowUp({
    required int followUpRoll,
    required String followUpResult,
    Map<String, dynamic>? followUpData,
  }) {
    return WildernessEncounterResult(
      roll: roll,
      secondRoll: secondRoll,
      encounter: encounter,
      requiresFollowUp: requiresFollowUp,
      dieSize: dieSize,
      skewUsed: skewUsed,
      wasLost: wasLost,
      becameLost: becameLost,
      becameFound: becameFound,
      isItalic: isItalic,
      partialItalic: partialItalic,
      followUpRoll: followUpRoll,
      followUpResult: followUpResult,
      followUpData: followUpData,
      newState: newState,
      timestamp: timestamp,
    );
  }

  @override
  String get className => 'WildernessEncounterResult';

  factory WildernessEncounterResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    WildernessState? state;
    if (meta['newState'] != null) {
      final stateJson = requireMap(meta['newState'], 'newState');
      state = WildernessState(
        environmentRow: stateJson['environmentRow'] as int,
        typeRow: stateJson['typeRow'] as int,
        isLost: stateJson['isLost'] as bool? ?? false,
      );
    }
    return WildernessEncounterResult(
      roll: meta['roll'] as int? ?? (json['diceResults'] as List).first as int,
      secondRoll: meta['secondRoll'] as int?,
      encounter: meta['encounter'] as String,
      requiresFollowUp: meta['requiresFollowUp'] as bool? ?? false,
      dieSize: meta['dieSize'] as int? ?? 10,
      skewUsed: meta['skewUsed'] as String? ?? 'straight',
      wasLost: meta['wasLost'] as bool? ?? false,
      becameLost: meta['becameLost'] as bool? ?? false,
      becameFound: meta['becameFound'] as bool? ?? false,
      isItalic: meta['isItalic'] as bool? ?? false,
      partialItalic: meta['partialItalic'] as String?,
      followUpRoll: meta['followUpRoll'] as int?,
      followUpResult: meta['followUpResult'] as String?,
      followUpData: safeMap(meta['followUpData']),
      newState: state,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() {
    var result = 'Encounter (d$dieSize';
    if (skewUsed != 'straight') result += '@$skewUsed';
    result += '): $encounter';
    if (becameLost) result += ' [LOST]';
    if (becameFound) result += ' [FOUND]';
    if (requiresFollowUp) result += ' (roll details)';
    return result;
  }
}

/// Result of weather roll using proper formula
class WildernessWeatherResult extends RollResult {
  final int baseRoll;
  final int? secondRoll;
  final String environmentSkew;
  final int typeModifier;
  final int weatherRow;
  final String weather;
  final String environment;
  final String typeName;

  WildernessWeatherResult({
    required this.baseRoll,
    this.secondRoll,
    required this.environmentSkew,
    required this.typeModifier,
    required this.weatherRow,
    required this.weather,
    required this.environment,
    required this.typeName,
    DateTime? timestamp,
  }) : super(
          type: RollType.weather,
          description: 'Weather',
          diceResults: secondRoll != null ? [baseRoll, secondRoll] : [baseRoll],
          total: weatherRow,
          interpretation: weather,
          timestamp: timestamp,
          metadata: {
            'baseRoll': baseRoll,
            'secondRoll': secondRoll,
            'environmentSkew': environmentSkew,
            'typeModifier': typeModifier,
            'weatherRow': weatherRow,
            'weather': weather,
            'environment': environment,
            'typeName': typeName,
          },
        );

  @override
  String get className => 'WildernessWeatherResult';

  factory WildernessWeatherResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    return WildernessWeatherResult(
      baseRoll: meta['baseRoll'] as int? ?? (json['diceResults'] as List).first as int,
      secondRoll: meta['secondRoll'] as int?,
      environmentSkew: meta['environmentSkew'] as String? ?? '@',
      typeModifier: meta['typeModifier'] as int? ?? 0,
      weatherRow: meta['weatherRow'] as int? ?? json['total'] as int,
      weather: meta['weather'] as String,
      environment: meta['environment'] as String,
      typeName: meta['typeName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  String get formula => '1d6@$environmentSkew + $typeModifier';

  @override
  String toString() => 'Weather ($typeName $environment): $weather ($formula → $weatherRow)';
}

/// Result of a wilderness detail roll.
class WildernessDetailResult extends RollResult {
  final String detailType;
  final int roll;
  final String result;

  WildernessDetailResult({
    required this.detailType,
    required this.roll,
    required this.result,
    DateTime? timestamp,
  }) : super(
          type: RollType.weather,
          description: detailType,
          diceResults: [roll],
          total: roll,
          interpretation: result,
          timestamp: timestamp,
          metadata: {
            'detailType': detailType,
            'roll': roll,
            'result': result,
          },
        );

  @override
  String get className => 'WildernessDetailResult';

  factory WildernessDetailResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    return WildernessDetailResult(
      detailType: meta['detailType'] as String,
      roll: meta['roll'] as int? ?? (json['diceResults'] as List).first as int,
      result: meta['result'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() => '$detailType: $result';
}

/// Result of monster level calculation.
class MonsterLevelResult extends RollResult {
  final int baseRoll;
  final int? secondRoll;
  final int modifier;
  final String advantageType;
  final int monsterLevel;

  MonsterLevelResult({
    required this.baseRoll,
    this.secondRoll,
    required this.modifier,
    required this.advantageType,
    required this.monsterLevel,
    DateTime? timestamp,
  }) : super(
          type: RollType.encounter,
          description: 'Monster Level',
          diceResults: secondRoll != null ? [baseRoll, secondRoll] : [baseRoll],
          total: monsterLevel,
          timestamp: timestamp,
          interpretation: 'Level $monsterLevel (+$modifier@$advantageType)',
          metadata: {
            'baseRoll': baseRoll,
            'secondRoll': secondRoll,
            'modifier': modifier,
            'advantageType': advantageType,
            'monsterLevel': monsterLevel,
          },
        );

  @override
  String get className => 'MonsterLevelResult';

  factory MonsterLevelResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    return MonsterLevelResult(
      baseRoll: meta['baseRoll'] as int? ?? (json['diceResults'] as List).first as int,
      secondRoll: meta['secondRoll'] as int?,
      modifier: meta['modifier'] as int? ?? 0,
      advantageType: meta['advantageType'] as String? ?? '@',
      monsterLevel: meta['monsterLevel'] as int? ?? json['total'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() => 'Monster Level: $monsterLevel (1d6+$modifier@$advantageType)';
}
