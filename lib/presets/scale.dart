import '../core/roll_engine.dart';
import '../core/fate_dice_formatter.dart';
import '../models/roll_result.dart';
import '../models/results/json_utils.dart';

/// Scale preset for the Juice Oracle.
/// Converts 2dF + 1d6 to percentage modifiers for quantity/value adjustments.
/// 
/// Based on expectation-behavior-intensity-scale.md Scale column.
/// Used when you need to modify a value (price, distance, duration, etc.)
class Scale {
  final RollEngine _rollEngine;

  /// Scale modifiers mapped by 2dF+1d6 sum (-1 to 8)
  static const Map<int, String> scaleModifiers = {
    -1: '-100%',  // -- (with low intensity)
    0: '-50%',
    1: '-25%',
    2: '-10%',
    3: '-',       // No change
    4: '-',       // No change
    5: '+10%',
    6: '+25%',
    7: '+50%',
    8: '+100%',
  };

  /// Numeric multipliers for programmatic use
  static const Map<int, double> scaleMultipliers = {
    -1: 0.0,    // -100%
    0: 0.5,     // -50%
    1: 0.75,    // -25%
    2: 0.9,     // -10%
    3: 1.0,     // No change
    4: 1.0,     // No change
    5: 1.1,     // +10%
    6: 1.25,    // +25%
    7: 1.5,     // +50%
    8: 2.0,     // +100%
  };

  Scale([RollEngine? rollEngine])
      : _rollEngine = rollEngine ?? RollEngine();

  /// Roll for a scale modifier (2dF + 1d6).
  ScaleResult roll() {
    // Roll 2 Fate dice
    final fateDice = _rollEngine.rollFateDice(2);
    final fateSum = fateDice[0] + fateDice[1];
    
    // Roll intensity die (1d6)
    final intensity = _rollEngine.rollDie(6);
    
    // Calculate total for scale lookup
    final total = fateSum + intensity;
    
    // Clamp to valid range (-1 to 8)
    final clampedTotal = total.clamp(-1, 8);
    
    final modifier = scaleModifiers[clampedTotal] ?? '-';
    final multiplier = scaleMultipliers[clampedTotal] ?? 1.0;

    return ScaleResult(
      fateDice: fateDice,
      fateSum: fateSum,
      intensity: intensity,
      total: total,
      modifier: modifier,
      multiplier: multiplier,
    );
  }

  /// Apply scale to a base value.
  ScaledValueResult applyToValue(num baseValue) {
    final scaleRoll = roll();
    final scaledValue = baseValue * scaleRoll.multiplier;
    
    return ScaledValueResult(
      scaleResult: scaleRoll,
      baseValue: baseValue,
      scaledValue: scaledValue,
    );
  }
}

/// Result of a Scale roll.
class ScaleResult extends RollResult {
  final List<int> fateDice;
  final int fateSum;
  final int intensity;
  @override
  // ignore: overridden_fields
  final int total;
  final String modifier;
  final double multiplier;

  ScaleResult({
    required this.fateDice,
    required this.fateSum,
    required this.intensity,
    required this.total,
    required this.modifier,
    required this.multiplier,
    DateTime? timestamp,
  }) : super(
          type: RollType.scale,
          description: 'Scale',
          diceResults: [...fateDice, intensity],
          total: total,
          interpretation: modifier,
          timestamp: timestamp,
          metadata: {
            'fateDice': fateDice,
            'fateSum': fateSum,
            'intensity': intensity,
            'modifier': modifier,
            'multiplier': multiplier,
          },
        );

  @override
  String get className => 'ScaleResult';

  factory ScaleResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    final diceResults = (json['diceResults'] as List).cast<int>();
    final fateDice = (meta['fateDice'] as List?)?.cast<int>() ?? diceResults.take(2).toList();
    return ScaleResult(
      fateDice: fateDice,
      fateSum: meta['fateSum'] as int? ?? fateDice.fold(0, (a, b) => a + b),
      intensity: meta['intensity'] as int? ?? diceResults.last,
      total: json['total'] as int,
      modifier: meta['modifier'] as String,
      multiplier: (meta['multiplier'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Get symbolic representation of the Fate dice.
  String get fateSymbols => FateDiceFormatter.diceToSymbols(fateDice);

  /// Whether this is an increase.
  bool get isIncrease => multiplier > 1.0;

  /// Whether this is a decrease.
  bool get isDecrease => multiplier < 1.0;

  /// Whether this is no change.
  bool get isNoChange => multiplier == 1.0;

  @override
  String toString() => 'Scale: [$fateSymbols] + $intensity = $modifier';
}

/// Result of applying scale to a value.
class ScaledValueResult extends RollResult {
  final ScaleResult scaleResult;
  final num baseValue;
  final num scaledValue;

  ScaledValueResult({
    required this.scaleResult,
    required this.baseValue,
    required this.scaledValue,
  }) : super(
          type: RollType.scale,
          description: 'Scaled Value',
          diceResults: scaleResult.diceResults,
          total: scaleResult.total,
          interpretation: '$baseValue → $scaledValue (${scaleResult.modifier})',
          metadata: {
            'baseValue': baseValue,
            'scaledValue': scaledValue,
            'modifier': scaleResult.modifier,
            'multiplier': scaleResult.multiplier,
            'scaleResult': scaleResult.toJson(),
          },
        );

  @override
  String get className => 'ScaledValueResult';

  /// Serialization - keep in sync with fromJson below.
  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'metadata': {
      'baseValue': baseValue,
      'scaledValue': scaledValue,
      'modifier': scaleResult.modifier,
      'multiplier': scaleResult.multiplier,
      'scaleResult': scaleResult.toJson(),
    },
  };

  /// Deserialization - keep in sync with toJson above.
  factory ScaledValueResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    final scaleResultJson = safeMap(meta['scaleResult']);
    
    // Reconstruct ScaleResult from metadata
    ScaleResult scaleResult;
    if (scaleResultJson != null) {
      scaleResult = ScaleResult.fromJson(scaleResultJson);
    } else {
      // Fallback for older data without embedded scaleResult
      final diceResults = (json['diceResults'] as List).cast<int>();
      scaleResult = ScaleResult(
        fateDice: diceResults.take(2).toList(),
        fateSum: diceResults.take(2).fold(0, (a, b) => a + b),
        intensity: diceResults.last,
        total: json['total'] as int,
        modifier: meta['modifier'] as String,
        multiplier: (meta['multiplier'] as num).toDouble(),
      );
    }
    
    return ScaledValueResult(
      scaleResult: scaleResult,
      baseValue: meta['baseValue'] as num,
      scaledValue: meta['scaledValue'] as num,
    );
  }

  @override
  String toString() => 'Scale: $baseValue ${scaleResult.modifier} = $scaledValue';
}
