import '../core/roll_engine.dart';
import '../models/roll_result.dart';
import '../data/extended_npc_conversation_data.dart' as data;
import 'details.dart' show SkewType;

/// Extended NPC Conversation Tables preset for the Juice Oracle.
/// 
/// Alternative to the Dialog Grid mini-game for NPC conversations.
/// Provides tables for:
/// - Information (2d100): Type of Information + Topic of Information
/// - Companion Response (1d100): Ordered responses to "the plan"
/// - Extended NPC Dialog Topic (1d100): What NPCs are talking about
/// 
/// From the Juice instructions:
/// "NPCs make the world feel alive. Talking with them can help you world-build,
/// give you side quests, or give information that your character would otherwise
/// not have access to."
/// 
/// **Data Separation:**
/// Static table data is stored in data/extended_npc_conversation_data.dart.
/// This class provides backward-compatible static accessors.
class ExtendedNpcConversation {
  final RollEngine _rollEngine;

  // ========== Static Accessors (delegate to data file) ==========

  /// Type of Information (1d100) - What kind of information the NPC provides
  static List<String> get informationTypes => data.informationTypes;

  /// Topic of Information (1d100) - What the information is about
  static List<String> get informationTopics => data.informationTopics;

  /// Companion Response (1d100) - Ordered from opposed (1) to in favor (100)
  static List<String> get companionResponses => data.companionResponses;

  /// Extended NPC Dialog Topic (1d100) - What NPCs are talking about
  static List<String> get dialogTopics => data.dialogTopics;

  ExtendedNpcConversation([RollEngine? rollEngine])
      : _rollEngine = rollEngine ?? RollEngine();

  /// Roll 2d100 for Information (Type + Topic).
  /// Used when asking an NPC for information or overhearing a conversation.
  InformationResult rollInformation() {
    final typeRoll = _rollEngine.rollDie(100);
    final topicRoll = _rollEngine.rollDie(100);
    
    final informationType = informationTypes[typeRoll - 1];
    final topic = informationTopics[topicRoll - 1];

    return InformationResult(
      typeRoll: typeRoll,
      topicRoll: topicRoll,
      informationType: informationType,
      topic: topic,
    );
  }

  /// Roll 1d100 for Companion Response.
  /// Ordered such that bigger numbers are more in favor with "the plan".
  /// Use advantage for companions likely to agree, disadvantage for opposition.
  CompanionResponseResult rollCompanionResponse({SkewType skew = SkewType.none}) {
    int roll;
    List<int> allRolls = [];
    
    switch (skew) {
      case SkewType.advantage:
        final result = _rollEngine.rollWithAdvantage(1, 100);
        roll = result.chosenSum;
        allRolls = [result.sum1, result.sum2];
        break;
      case SkewType.disadvantage:
        final result = _rollEngine.rollWithDisadvantage(1, 100);
        roll = result.chosenSum;
        allRolls = [result.sum1, result.sum2];
        break;
      case SkewType.none:
        roll = _rollEngine.rollDie(100);
        allRolls = [roll];
    }
    
    final response = companionResponses[roll - 1];

    return CompanionResponseResult(
      roll: roll,
      response: response,
      skew: skew,
      allRolls: allRolls,
    );
  }

  /// Roll 1d100 for Extended NPC Dialog Topic.
  /// Can also be used for News, letters, books, writing on walls, etc.
  DialogTopicResult rollDialogTopic() {
    final roll = _rollEngine.rollDie(100);
    final topic = dialogTopics[roll - 1];

    return DialogTopicResult(
      roll: roll,
      topic: topic,
    );
  }
}

/// Result of rolling Information (2d100: Type + Topic).
class InformationResult extends RollResult {
  final int typeRoll;
  final int topicRoll;
  final String informationType;
  final String topic;

  InformationResult({
    required this.typeRoll,
    required this.topicRoll,
    required this.informationType,
    required this.topic,
    DateTime? timestamp,
  }) : super(
          type: RollType.npcAction,
          description: 'NPC Information (2d100)',
          diceResults: [typeRoll, topicRoll],
          total: typeRoll + topicRoll,
          interpretation: '$informationType $topic',
          timestamp: timestamp,
          metadata: {
            'typeRoll': typeRoll,
            'topicRoll': topicRoll,
            'informationType': informationType,
            'topic': topic,
          },
        );

  @override
  String get className => 'InformationResult';

  factory InformationResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    final diceResults = (json['diceResults'] as List).cast<int>();
    return InformationResult(
      typeRoll: meta['typeRoll'] as int? ?? diceResults[0],
      topicRoll: meta['topicRoll'] as int? ?? diceResults[1],
      informationType: meta['informationType'] as String,
      topic: meta['topic'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() => '$informationType $topic';
}

/// Result of rolling Companion Response (1d100).
class CompanionResponseResult extends RollResult {
  final int roll;
  final String response;
  final SkewType skew;
  final List<int> allRolls;

  CompanionResponseResult({
    required this.roll,
    required this.response,
    required this.skew,
    required this.allRolls,
    DateTime? timestamp,
  }) : super(
          type: RollType.npcAction,
          description: _buildDescription(skew),
          diceResults: allRolls,
          total: roll,
          interpretation: response,
          timestamp: timestamp,
          metadata: {
            'roll': roll,
            'response': response,
            'skew': skew.name,
            'favor': _getFavorLevel(roll),
          },
        );

  @override
  String get className => 'CompanionResponseResult';

  factory CompanionResponseResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    final diceResults = (json['diceResults'] as List).cast<int>();
    return CompanionResponseResult(
      roll: meta['roll'] as int? ?? diceResults[0],
      response: meta['response'] as String,
      skew: SkewType.values.firstWhere(
        (s) => s.name == meta['skew'],
        orElse: () => SkewType.none,
      ),
      allRolls: diceResults,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  static String _buildDescription(SkewType skew) {
    switch (skew) {
      case SkewType.advantage:
        return 'Companion Response (1d100@+ In Favor)';
      case SkewType.disadvantage:
        return 'Companion Response (1d100@- Opposed)';
      case SkewType.none:
        return 'Companion Response (1d100)';
    }
  }

  static String _getFavorLevel(int roll) {
    if (roll <= 20) return 'Strongly Opposed';
    if (roll <= 40) return 'Hesitant';
    if (roll <= 60) return 'Neutral/Questioning';
    if (roll <= 80) return 'Cautious Support';
    return 'Strongly In Favor';
  }

  /// Get the favor level of the response
  String get favorLevel => _getFavorLevel(roll);

  @override
  String toString() => response;
}

/// Result of rolling Extended NPC Dialog Topic (1d100).
class DialogTopicResult extends RollResult {
  final int roll;
  final String topic;

  DialogTopicResult({
    required this.roll,
    required this.topic,
    DateTime? timestamp,
  }) : super(
          type: RollType.npcAction,
          description: 'Dialog Topic (1d100)',
          diceResults: [roll],
          total: roll,
          interpretation: topic,
          timestamp: timestamp,
          metadata: {
            'roll': roll,
            'topic': topic,
          },
        );

  @override
  String get className => 'DialogTopicResult';

  factory DialogTopicResult.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>;
    final diceResults = (json['diceResults'] as List).cast<int>();
    return DialogTopicResult(
      roll: meta['roll'] as int? ?? diceResults[0],
      topic: meta['topic'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  @override
  String toString() => topic;
}
