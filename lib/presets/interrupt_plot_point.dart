import '../core/roll_engine.dart';
import '../data/interrupt_plot_point_data.dart' as data;
import '../models/roll_result.dart';

/// Interrupt / Plot Point preset for the Juice Oracle.
/// Uses interrupt-plot-point.md for story interruptions.
class InterruptPlotPoint {
  final RollEngine _rollEngine;

  /// Categories (first d10 determines column) - mapped by ranges
  static Map<int, String> get categories => data.categories;

  /// Action events (1-2 column) - d10
  static List<String> get actionEvents => data.actionEvents;

  /// Tension events (3-4 column) - d10
  static List<String> get tensionEvents => data.tensionEvents;

  /// Mystery events (5-6 column) - d10
  static List<String> get mysteryEvents => data.mysteryEvents;

  /// Social events (7-8 column) - d10
  static List<String> get socialEvents => data.socialEvents;

  /// Personal events (9-0 column) - d10
  static List<String> get personalEvents => data.personalEvents;

  InterruptPlotPoint([RollEngine? rollEngine])
      : _rollEngine = rollEngine ?? RollEngine();

  /// Generate an interrupt/plot point (2d10).
  InterruptPlotPointResult generate() {
    final categoryRoll = _rollEngine.rollDie(10);
    final eventRoll = _rollEngine.rollDie(10);

    // Determine category
    final categoryKey = categoryRoll == 10 ? 0 : categoryRoll;
    final category = categories[categoryKey] ?? 'Action';

    // Get event from appropriate list
    final eventIndex = eventRoll == 10 ? 9 : eventRoll - 1;
    String event;
    switch (category) {
      case 'Action':
        event = actionEvents[eventIndex];
        break;
      case 'Tension':
        event = tensionEvents[eventIndex];
        break;
      case 'Mystery':
        event = mysteryEvents[eventIndex];
        break;
      case 'Social':
        event = socialEvents[eventIndex];
        break;
      case 'Personal':
        event = personalEvents[eventIndex];
        break;
      default:
        event = actionEvents[eventIndex];
    }

    return InterruptPlotPointResult(
      categoryRoll: categoryRoll,
      category: category,
      eventRoll: eventRoll,
      event: event,
    );
  }
}

/// Result of an Interrupt/Plot Point roll.
class InterruptPlotPointResult extends RollResult {
  final int categoryRoll;
  final String category;
  final int eventRoll;
  final String event;

  InterruptPlotPointResult({
    required this.categoryRoll,
    required this.category,
    required this.eventRoll,
    required this.event,
    DateTime? timestamp,
  }) : super(
          type: RollType.interruptPlotPoint,
          description: 'Interrupt / Plot Point',
          diceResults: [categoryRoll, eventRoll],
          total: categoryRoll + eventRoll,
          interpretation: '$category: $event',
          timestamp: timestamp,
          metadata: {
            'category': category,
            'event': event,
            'categoryRoll': categoryRoll,
            'eventRoll': eventRoll,
          },
        );

  @override
  String get className => 'InterruptPlotPointResult';

  factory InterruptPlotPointResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    final diceResults = (json['diceResults'] as List).cast<int>();
    return InterruptPlotPointResult(
      categoryRoll: meta['categoryRoll'] as int? ?? diceResults[0],
      category: meta['category'] as String,
      eventRoll: meta['eventRoll'] as int? ?? diceResults[1],
      event: meta['event'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() => 'Interrupt ($category): $event';
}
