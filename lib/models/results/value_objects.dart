// Value objects for embedded data within RollResults.
//
// These lightweight immutable data classes replace full RollResult subclasses
// for nested/embedded data. They're smaller, faster to serialize, and don't
// carry the overhead of being full results.

import 'package:flutter/foundation.dart' show immutable;

/// Data for a random event (focus + modifier + idea).
/// Used as embedded data in FateCheckResult when a random event is triggered.
@immutable
class RandomEventData {
  final int focusRoll;
  final String focus;
  final int modifierRoll;
  final String modifier;
  final int ideaRoll;
  final String idea;
  final String ideaCategory;

  const RandomEventData({
    required this.focusRoll,
    required this.focus,
    required this.modifierRoll,
    required this.modifier,
    required this.ideaRoll,
    required this.idea,
    this.ideaCategory = 'Idea',
  });

  /// All dice rolls for this event.
  List<int> get diceResults => [focusRoll, modifierRoll, ideaRoll];

  /// The combined event phrase (e.g., "Change Secret").
  String get eventPhrase => '$modifier $idea';

  /// Full description including focus.
  String get fullDescription => '$focus: $modifier $idea';

  Map<String, dynamic> toJson() => {
        'focusRoll': focusRoll,
        'focus': focus,
        'modifierRoll': modifierRoll,
        'modifier': modifier,
        'ideaRoll': ideaRoll,
        'idea': idea,
        'ideaCategory': ideaCategory,
      };

  factory RandomEventData.fromJson(Map<String, dynamic> json) =>
      RandomEventData(
        focusRoll: json['focusRoll'] as int,
        focus: json['focus'] as String,
        modifierRoll: json['modifierRoll'] as int,
        modifier: json['modifier'] as String,
        ideaRoll: json['ideaRoll'] as int,
        idea: json['idea'] as String,
        ideaCategory: json['ideaCategory'] as String? ?? 'Idea',
      );

  @override
  String toString() => fullDescription;
}

/// Data for a modifier + idea pair.
/// Used in altered scenes, simple events, etc.
@immutable
class IdeaData {
  final int modifierRoll;
  final String modifier;
  final int ideaRoll;
  final String idea;
  final String ideaCategory;

  const IdeaData({
    required this.modifierRoll,
    required this.modifier,
    required this.ideaRoll,
    required this.idea,
    this.ideaCategory = 'Idea',
  });

  List<int> get diceResults => [modifierRoll, ideaRoll];

  String get phrase => '$modifier $idea';

  Map<String, dynamic> toJson() => {
        'modifierRoll': modifierRoll,
        'modifier': modifier,
        'ideaRoll': ideaRoll,
        'idea': idea,
        'ideaCategory': ideaCategory,
      };

  factory IdeaData.fromJson(Map<String, dynamic> json) => IdeaData(
        modifierRoll: json['modifierRoll'] as int,
        modifier: json['modifier'] as String,
        ideaRoll: json['ideaRoll'] as int,
        idea: json['idea'] as String,
        ideaCategory: json['ideaCategory'] as String? ?? 'Idea',
      );

  @override
  String toString() => phrase;
}

/// Data for a property with intensity value.
/// Used for NPC traits, location qualities, item properties.
@immutable
class PropertyData {
  final int propertyRoll;
  final String property;
  final int intensityRoll;

  const PropertyData({
    required this.propertyRoll,
    required this.property,
    required this.intensityRoll,
  });

  List<int> get diceResults => [propertyRoll, intensityRoll];

  /// Intensity as descriptive text (1-6 scale).
  String get intensityText {
    return switch (intensityRoll) {
      1 => 'barely',
      2 => 'slightly',
      3 => 'somewhat',
      4 => 'notably',
      5 => 'very',
      6 => 'extremely',
      _ => 'moderately',
    };
  }

  /// Full description (e.g., "very Sturdy").
  String get fullDescription => '$intensityText $property';

  Map<String, dynamic> toJson() => {
        'propertyRoll': propertyRoll,
        'property': property,
        'intensityRoll': intensityRoll,
      };

  factory PropertyData.fromJson(Map<String, dynamic> json) => PropertyData(
        propertyRoll: json['propertyRoll'] as int,
        property: json['property'] as String,
        intensityRoll: json['intensityRoll'] as int,
      );

  @override
  String toString() => fullDescription;
}

/// Data for a simple table lookup result.
/// Used for colors, sizes, shapes, conditions, etc.
@immutable
class DetailData {
  final int roll;
  final String value;
  final String? emoji;

  const DetailData({
    required this.roll,
    required this.value,
    this.emoji,
  });

  List<int> get diceResults => [roll];

  String get displayValue => emoji != null ? '$emoji $value' : value;

  Map<String, dynamic> toJson() => {
        'roll': roll,
        'value': value,
        if (emoji != null) 'emoji': emoji,
      };

  factory DetailData.fromJson(Map<String, dynamic> json) => DetailData(
        roll: json['roll'] as int,
        value: json['value'] as String,
        emoji: json['emoji'] as String?,
      );

  @override
  String toString() => displayValue;
}

/// Data for NPC personality traits.
/// Used in NPC profiles for primary/secondary personality.
@immutable
class PersonalityData {
  final int traitRoll;
  final String trait;
  final int intensityRoll;
  final bool isPrimary;

  const PersonalityData({
    required this.traitRoll,
    required this.trait,
    required this.intensityRoll,
    this.isPrimary = true,
  });

  List<int> get diceResults => [traitRoll, intensityRoll];

  String get intensityText {
    return switch (intensityRoll) {
      1 => 'barely',
      2 => 'slightly',
      3 => 'somewhat',
      4 => 'notably',
      5 => 'very',
      6 => 'extremely',
      _ => 'moderately',
    };
  }

  String get fullDescription => '$intensityText $trait';

  Map<String, dynamic> toJson() => {
        'traitRoll': traitRoll,
        'trait': trait,
        'intensityRoll': intensityRoll,
        'isPrimary': isPrimary,
      };

  factory PersonalityData.fromJson(Map<String, dynamic> json) =>
      PersonalityData(
        traitRoll: json['traitRoll'] as int,
        trait: json['trait'] as String,
        intensityRoll: json['intensityRoll'] as int,
        isPrimary: json['isPrimary'] as bool? ?? true,
      );

  @override
  String toString() => fullDescription;
}

/// Data for an NPC's motive (need + motivation).
@immutable
class MotiveData {
  final int needRoll;
  final String need;
  final int motiveRoll;
  final String motivation;

  const MotiveData({
    required this.needRoll,
    required this.need,
    required this.motiveRoll,
    required this.motivation,
  });

  List<int> get diceResults => [needRoll, motiveRoll];

  String get fullDescription => '$need $motivation';

  Map<String, dynamic> toJson() => {
        'needRoll': needRoll,
        'need': need,
        'motiveRoll': motiveRoll,
        'motivation': motivation,
      };

  factory MotiveData.fromJson(Map<String, dynamic> json) => MotiveData(
        needRoll: json['needRoll'] as int,
        need: json['need'] as String,
        motiveRoll: json['motiveRoll'] as int,
        motivation: json['motivation'] as String,
      );

  @override
  String toString() => fullDescription;
}

/// Data for a dungeon area (type + shape + size).
@immutable
class AreaData {
  final int typeRoll;
  final String areaType;
  final int shapeRoll;
  final String shape;
  final int sizeRoll;
  final String size;
  final bool hasExit;
  final bool isDoubles;

  const AreaData({
    required this.typeRoll,
    required this.areaType,
    required this.shapeRoll,
    required this.shape,
    required this.sizeRoll,
    required this.size,
    this.hasExit = true,
    this.isDoubles = false,
  });

  List<int> get diceResults => [typeRoll, shapeRoll, sizeRoll];

  String get fullDescription => '$size $shape $areaType';

  Map<String, dynamic> toJson() => {
        'typeRoll': typeRoll,
        'areaType': areaType,
        'shapeRoll': shapeRoll,
        'shape': shape,
        'sizeRoll': sizeRoll,
        'size': size,
        'hasExit': hasExit,
        'isDoubles': isDoubles,
      };

  factory AreaData.fromJson(Map<String, dynamic> json) => AreaData(
        typeRoll: json['typeRoll'] as int,
        areaType: json['areaType'] as String,
        shapeRoll: json['shapeRoll'] as int,
        shape: json['shape'] as String,
        sizeRoll: json['sizeRoll'] as int,
        size: json['size'] as String,
        hasExit: json['hasExit'] as bool? ?? true,
        isDoubles: json['isDoubles'] as bool? ?? false,
      );

  @override
  String toString() => fullDescription;
}

/// Data for an encounter (type + optional details).
@immutable
class EncounterData {
  final int roll;
  final String encounterType;
  final String? detail;
  final int? detailRoll;

  const EncounterData({
    required this.roll,
    required this.encounterType,
    this.detail,
    this.detailRoll,
  });

  List<int> get diceResults =>
      detailRoll != null ? [roll, detailRoll!] : [roll];

  String get fullDescription =>
      detail != null ? '$encounterType: $detail' : encounterType;

  Map<String, dynamic> toJson() => {
        'roll': roll,
        'encounterType': encounterType,
        if (detail != null) 'detail': detail,
        if (detailRoll != null) 'detailRoll': detailRoll,
      };

  factory EncounterData.fromJson(Map<String, dynamic> json) => EncounterData(
        roll: json['roll'] as int,
        encounterType: json['encounterType'] as String,
        detail: json['detail'] as String?,
        detailRoll: json['detailRoll'] as int?,
      );

  @override
  String toString() => fullDescription;
}

/// Data for a passage/exit in a dungeon.
@immutable
class PassageData {
  final int roll;
  final String direction;
  final String? description;

  const PassageData({
    required this.roll,
    required this.direction,
    this.description,
  });

  List<int> get diceResults => [roll];

  String get fullDescription =>
      description != null ? '$direction: $description' : direction;

  Map<String, dynamic> toJson() => {
        'roll': roll,
        'direction': direction,
        if (description != null) 'description': description,
      };

  factory PassageData.fromJson(Map<String, dynamic> json) => PassageData(
        roll: json['roll'] as int,
        direction: json['direction'] as String,
        description: json['description'] as String?,
      );

  @override
  String toString() => fullDescription;
}

/// Data for room condition.
@immutable
class ConditionData {
  final int roll;
  final String condition;
  final String? effect;

  const ConditionData({
    required this.roll,
    required this.condition,
    this.effect,
  });

  List<int> get diceResults => [roll];

  String get fullDescription =>
      effect != null ? '$condition: $effect' : condition;

  Map<String, dynamic> toJson() => {
        'roll': roll,
        'condition': condition,
        if (effect != null) 'effect': effect,
      };

  factory ConditionData.fromJson(Map<String, dynamic> json) => ConditionData(
        roll: json['roll'] as int,
        condition: json['condition'] as String,
        effect: json['effect'] as String?,
      );

  @override
  String toString() => fullDescription;
}

/// Data for a color lookup.
@immutable
class ColorData {
  final int roll;
  final String color;
  final String emoji;

  const ColorData({
    required this.roll,
    required this.color,
    required this.emoji,
  });

  List<int> get diceResults => [roll];

  String get displayValue => '$emoji $color';

  Map<String, dynamic> toJson() => {
        'roll': roll,
        'color': color,
        'emoji': emoji,
      };

  factory ColorData.fromJson(Map<String, dynamic> json) => ColorData(
        roll: json['roll'] as int,
        color: json['color'] as String,
        emoji: json['emoji'] as String,
      );

  @override
  String toString() => displayValue;
}

/// Data for a name (first + last or establishment name).
@immutable
class NameData {
  final int roll1;
  final String part1;
  final int? roll2;
  final String? part2;

  const NameData({
    required this.roll1,
    required this.part1,
    this.roll2,
    this.part2,
  });

  List<int> get diceResults =>
      roll2 != null ? [roll1, roll2!] : [roll1];

  String get fullName => part2 != null ? '$part1 $part2' : part1;

  Map<String, dynamic> toJson() => {
        'roll1': roll1,
        'part1': part1,
        if (roll2 != null) 'roll2': roll2,
        if (part2 != null) 'part2': part2,
      };

  factory NameData.fromJson(Map<String, dynamic> json) => NameData(
        roll1: json['roll1'] as int,
        part1: json['part1'] as String,
        roll2: json['roll2'] as int?,
        part2: json['part2'] as String?,
      );

  @override
  String toString() => fullName;
}

/// Data for a challenge (physical/mental + DC).
@immutable
class ChallengeData {
  final int roll;
  final String challenge;
  final int dcRoll;
  final int dc;

  const ChallengeData({
    required this.roll,
    required this.challenge,
    required this.dcRoll,
    required this.dc,
  });

  List<int> get diceResults => [roll, dcRoll];

  String get fullDescription => '$challenge (DC $dc)';

  Map<String, dynamic> toJson() => {
        'roll': roll,
        'challenge': challenge,
        'dcRoll': dcRoll,
        'dc': dc,
      };

  factory ChallengeData.fromJson(Map<String, dynamic> json) => ChallengeData(
        roll: json['roll'] as int,
        challenge: json['challenge'] as String,
        dcRoll: json['dcRoll'] as int,
        dc: json['dc'] as int,
      );

  @override
  String toString() => fullDescription;
}

/// Data for wilderness exploration state.
/// Persists between rolls to track current environment position and lost status.
@immutable
class WildernessStateData {
  final int environmentRow;
  final int typeRow;
  final bool isLost;

  const WildernessStateData({
    required this.environmentRow,
    required this.typeRow,
    this.isLost = false,
  });

  Map<String, dynamic> toJson() => {
        'environmentRow': environmentRow,
        'typeRow': typeRow,
        'isLost': isLost,
      };

  factory WildernessStateData.fromJson(Map<String, dynamic> json) =>
      WildernessStateData(
        environmentRow: json['environmentRow'] as int,
        typeRow: json['typeRow'] as int,
        isLost: json['isLost'] as bool? ?? false,
      );

  @override
  String toString() => 'Env: $environmentRow, Type: $typeRow${isLost ? ' (LOST)' : ''}';
}

/// Data for fate dice results with symbol conversion.
/// Used in FateCheck, NextScene, ExpectationCheck, etc.
@immutable
class FateDiceData {
  final List<int> dice;
  
  const FateDiceData({required this.dice});

  int get sum => dice.fold(0, (a, b) => a + b);

  /// Convert dice values to symbols: + (1), O (0), - (-1)
  String get symbols {
    return dice.map((d) {
      if (d > 0) return '+';
      if (d < 0) return '-';
      return 'O';
    }).join(' ');
  }

  /// Check for doubles (both dice same value)
  bool get isDoubles => dice.length == 2 && dice[0] == dice[1];

  /// Check for double blanks (both O)
  bool get isDoubleBlanks => dice.length == 2 && dice[0] == 0 && dice[1] == 0;

  /// Check for double plus
  bool get isDoublePlus => dice.length == 2 && dice[0] == 1 && dice[1] == 1;

  /// Check for double minus
  bool get isDoubleMinus => dice.length == 2 && dice[0] == -1 && dice[1] == -1;

  List<int> get diceResults => dice;

  Map<String, dynamic> toJson() => {'dice': dice};

  factory FateDiceData.fromJson(Map<String, dynamic> json) =>
      FateDiceData(dice: (json['dice'] as List).cast<int>());

  @override
  String toString() => '[$symbols] = $sum';
}

/// Data for sensory detail (sense + detail + location).
/// Used in immersion results.
@immutable
class SensoryData {
  final int senseRoll;
  final String sense;
  final int detailRoll;
  final String detail;
  final int whereRoll;
  final String where;

  const SensoryData({
    required this.senseRoll,
    required this.sense,
    required this.detailRoll,
    required this.detail,
    required this.whereRoll,
    required this.where,
  });

  List<int> get diceResults => [senseRoll, detailRoll, whereRoll];

  String get fullDescription => 'You $sense something $detail $where';

  Map<String, dynamic> toJson() => {
        'senseRoll': senseRoll,
        'sense': sense,
        'detailRoll': detailRoll,
        'detail': detail,
        'whereRoll': whereRoll,
        'where': where,
      };

  factory SensoryData.fromJson(Map<String, dynamic> json) => SensoryData(
        senseRoll: json['senseRoll'] as int,
        sense: json['sense'] as String,
        detailRoll: json['detailRoll'] as int,
        detail: json['detail'] as String,
        whereRoll: json['whereRoll'] as int,
        where: json['where'] as String,
      );

  @override
  String toString() => fullDescription;
}

/// Data for emotional atmosphere (emotion pair + cause).
/// Used in immersion results.
@immutable
class EmotionData {
  final int emotionRoll;
  final String negativeEmotion;
  final String positiveEmotion;
  final String selectedEmotion;
  final bool isPositive;
  final int causeRoll;
  final String cause;

  const EmotionData({
    required this.emotionRoll,
    required this.negativeEmotion,
    required this.positiveEmotion,
    required this.selectedEmotion,
    required this.isPositive,
    required this.causeRoll,
    required this.cause,
  });

  List<int> get diceResults => [emotionRoll, causeRoll];

  String get fullDescription => 'It causes $selectedEmotion because $cause';

  Map<String, dynamic> toJson() => {
        'emotionRoll': emotionRoll,
        'negativeEmotion': negativeEmotion,
        'positiveEmotion': positiveEmotion,
        'selectedEmotion': selectedEmotion,
        'isPositive': isPositive,
        'causeRoll': causeRoll,
        'cause': cause,
      };

  factory EmotionData.fromJson(Map<String, dynamic> json) => EmotionData(
        emotionRoll: json['emotionRoll'] as int,
        negativeEmotion: json['negativeEmotion'] as String,
        positiveEmotion: json['positiveEmotion'] as String,
        selectedEmotion: json['selectedEmotion'] as String,
        isPositive: json['isPositive'] as bool,
        causeRoll: json['causeRoll'] as int,
        cause: json['cause'] as String,
      );

  @override
  String toString() => fullDescription;
}

/// Data for a focus table roll.
/// Used in next scene follow-ups and NPC motives.
@immutable
class FocusData {
  final int roll;
  final String focus;
  final bool requiresExpansion;
  final int? expansionRoll;
  final String? expandedValue;

  const FocusData({
    required this.roll,
    required this.focus,
    this.requiresExpansion = false,
    this.expansionRoll,
    this.expandedValue,
  });

  List<int> get diceResults =>
      expansionRoll != null ? [roll, expansionRoll!] : [roll];

  String get fullDescription =>
      expandedValue != null ? '$focus → $expandedValue' : focus;

  Map<String, dynamic> toJson() => {
        'roll': roll,
        'focus': focus,
        'requiresExpansion': requiresExpansion,
        if (expansionRoll != null) 'expansionRoll': expansionRoll,
        if (expandedValue != null) 'expandedValue': expandedValue,
      };

  factory FocusData.fromJson(Map<String, dynamic> json) => FocusData(
        roll: json['roll'] as int,
        focus: json['focus'] as String,
        requiresExpansion: json['requiresExpansion'] as bool? ?? false,
        expansionRoll: json['expansionRoll'] as int?,
        expandedValue: json['expandedValue'] as String?,
      );

  @override
  String toString() => fullDescription;
}

/// Data for object/treasure generation (4-column: category/quality/material/type).
@immutable
class ObjectTreasureData {
  final int categoryRoll;
  final String category;
  final int qualityRoll;
  final String quality;
  final int materialRoll;
  final String material;
  final int typeRoll;
  final String itemType;
  final List<String> columnLabels;

  const ObjectTreasureData({
    required this.categoryRoll,
    required this.category,
    required this.qualityRoll,
    required this.quality,
    required this.materialRoll,
    required this.material,
    required this.typeRoll,
    required this.itemType,
    this.columnLabels = const ['Quality', 'Material', 'Type'],
  });

  List<int> get diceResults => [categoryRoll, qualityRoll, materialRoll, typeRoll];

  String get fullDescription {
    if (category == 'Treasure' && material == 'None') {
      return '$quality $itemType';
    }
    if (category == 'Treasure') {
      return '$quality $material full of $itemType';
    }
    return '$quality $material $itemType';
  }

  Map<String, dynamic> toJson() => {
        'categoryRoll': categoryRoll,
        'category': category,
        'qualityRoll': qualityRoll,
        'quality': quality,
        'materialRoll': materialRoll,
        'material': material,
        'typeRoll': typeRoll,
        'itemType': itemType,
        'columnLabels': columnLabels,
      };

  factory ObjectTreasureData.fromJson(Map<String, dynamic> json) =>
      ObjectTreasureData(
        categoryRoll: json['categoryRoll'] as int,
        category: json['category'] as String,
        qualityRoll: json['qualityRoll'] as int,
        quality: json['quality'] as String,
        materialRoll: json['materialRoll'] as int,
        material: json['material'] as String,
        typeRoll: json['typeRoll'] as int,
        itemType: json['itemType'] as String,
        columnLabels: (json['columnLabels'] as List?)?.cast<String>() ??
            const ['Quality', 'Material', 'Type'],
      );

  @override
  String toString() => '$category: $fullDescription';
}

/// Data for a trap (trigger + effect + DC).
@immutable
class TrapData {
  final int triggerRoll;
  final String trigger;
  final int effectRoll;
  final String effect;
  final int? dcRoll;
  final int? dc;

  const TrapData({
    required this.triggerRoll,
    required this.trigger,
    required this.effectRoll,
    required this.effect,
    this.dcRoll,
    this.dc,
  });

  List<int> get diceResults =>
      dcRoll != null ? [triggerRoll, effectRoll, dcRoll!] : [triggerRoll, effectRoll];

  String get fullDescription =>
      dc != null ? '$trigger → $effect (DC $dc)' : '$trigger → $effect';

  Map<String, dynamic> toJson() => {
        'triggerRoll': triggerRoll,
        'trigger': trigger,
        'effectRoll': effectRoll,
        'effect': effect,
        if (dcRoll != null) 'dcRoll': dcRoll,
        if (dc != null) 'dc': dc,
      };

  factory TrapData.fromJson(Map<String, dynamic> json) => TrapData(
        triggerRoll: json['triggerRoll'] as int,
        trigger: json['trigger'] as String,
        effectRoll: json['effectRoll'] as int,
        effect: json['effect'] as String,
        dcRoll: json['dcRoll'] as int?,
        dc: json['dc'] as int?,
      );

  @override
  String toString() => fullDescription;
}

/// Data for a monster encounter.
@immutable
class MonsterData {
  final int levelRoll;
  final String level;
  final int typeRoll;
  final String monsterType;
  final int? behaviorRoll;
  final String? behavior;

  const MonsterData({
    required this.levelRoll,
    required this.level,
    required this.typeRoll,
    required this.monsterType,
    this.behaviorRoll,
    this.behavior,
  });

  List<int> get diceResults => behaviorRoll != null
      ? [levelRoll, typeRoll, behaviorRoll!]
      : [levelRoll, typeRoll];

  String get fullDescription =>
      behavior != null ? '$level $monsterType ($behavior)' : '$level $monsterType';

  Map<String, dynamic> toJson() => {
        'levelRoll': levelRoll,
        'level': level,
        'typeRoll': typeRoll,
        'monsterType': monsterType,
        if (behaviorRoll != null) 'behaviorRoll': behaviorRoll,
        if (behavior != null) 'behavior': behavior,
      };

  factory MonsterData.fromJson(Map<String, dynamic> json) => MonsterData(
        levelRoll: json['levelRoll'] as int,
        level: json['level'] as String,
        typeRoll: json['typeRoll'] as int,
        monsterType: json['monsterType'] as String,
        behaviorRoll: json['behaviorRoll'] as int?,
        behavior: json['behavior'] as String?,
      );

  @override
  String toString() => fullDescription;
}

/// Data for an interrupt plot point.
@immutable
class PlotPointData {
  final int categoryRoll;
  final String category;
  final int eventRoll;
  final String event;

  const PlotPointData({
    required this.categoryRoll,
    required this.category,
    required this.eventRoll,
    required this.event,
  });

  List<int> get diceResults => [categoryRoll, eventRoll];

  String get fullDescription => '$category: $event';

  Map<String, dynamic> toJson() => {
        'categoryRoll': categoryRoll,
        'category': category,
        'eventRoll': eventRoll,
        'event': event,
      };

  factory PlotPointData.fromJson(Map<String, dynamic> json) => PlotPointData(
        categoryRoll: json['categoryRoll'] as int,
        category: json['category'] as String,
        eventRoll: json['eventRoll'] as int,
        event: json['event'] as String,
      );

  @override
  String toString() => fullDescription;
}

/// Data for discover meaning (adjective + noun pair).
@immutable
class MeaningData {
  final int adjectiveRoll;
  final String adjective;
  final int nounRoll;
  final String noun;

  const MeaningData({
    required this.adjectiveRoll,
    required this.adjective,
    required this.nounRoll,
    required this.noun,
  });

  List<int> get diceResults => [adjectiveRoll, nounRoll];

  String get phrase => '$adjective $noun';

  Map<String, dynamic> toJson() => {
        'adjectiveRoll': adjectiveRoll,
        'adjective': adjective,
        'nounRoll': nounRoll,
        'noun': noun,
      };

  factory MeaningData.fromJson(Map<String, dynamic> json) => MeaningData(
        adjectiveRoll: json['adjectiveRoll'] as int,
        adjective: json['adjective'] as String,
        nounRoll: json['nounRoll'] as int,
        noun: json['noun'] as String,
      );

  @override
  String toString() => phrase;
}

/// Data for a weather result.
@immutable
class WeatherData {
  final int roll;
  final String weather;
  final int environmentModifier;
  final String severity;

  const WeatherData({
    required this.roll,
    required this.weather,
    required this.environmentModifier,
    this.severity = 'normal',
  });

  List<int> get diceResults => [roll];

  String get fullDescription => severity != 'normal' 
      ? '$severity $weather' 
      : weather;

  Map<String, dynamic> toJson() => {
        'roll': roll,
        'weather': weather,
        'environmentModifier': environmentModifier,
        'severity': severity,
      };

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        roll: json['roll'] as int,
        weather: json['weather'] as String,
        environmentModifier: json['environmentModifier'] as int,
        severity: json['severity'] as String? ?? 'normal',
      );

  @override
  String toString() => fullDescription;
}

/// Data for a dialog/conversation response.
@immutable
class DialogData {
  final int responseRoll;
  final String response;
  final int? topicRoll;
  final String? topic;
  final String? mood;

  const DialogData({
    required this.responseRoll,
    required this.response,
    this.topicRoll,
    this.topic,
    this.mood,
  });

  List<int> get diceResults =>
      topicRoll != null ? [responseRoll, topicRoll!] : [responseRoll];

  String get fullDescription {
    final parts = <String>[response];
    if (topic != null) parts.add('about $topic');
    if (mood != null) parts.add('($mood)');
    return parts.join(' ');
  }

  Map<String, dynamic> toJson() => {
        'responseRoll': responseRoll,
        'response': response,
        if (topicRoll != null) 'topicRoll': topicRoll,
        if (topic != null) 'topic': topic,
        if (mood != null) 'mood': mood,
      };

  factory DialogData.fromJson(Map<String, dynamic> json) => DialogData(
        responseRoll: json['responseRoll'] as int,
        response: json['response'] as String,
        topicRoll: json['topicRoll'] as int?,
        topic: json['topic'] as String?,
        mood: json['mood'] as String?,
      );

  @override
  String toString() => fullDescription;
}

/// Data for a quest (focus + location + objective pattern).
@immutable
class QuestData {
  final int focusRoll;
  final String focus;
  final int locationRoll;
  final String location;
  final int? objectiveRoll;
  final String? objective;
  final String? focusExpanded;
  final String? locationExpanded;

  const QuestData({
    required this.focusRoll,
    required this.focus,
    required this.locationRoll,
    required this.location,
    this.objectiveRoll,
    this.objective,
    this.focusExpanded,
    this.locationExpanded,
  });

  List<int> get diceResults => objectiveRoll != null
      ? [focusRoll, locationRoll, objectiveRoll!]
      : [focusRoll, locationRoll];

  String get displayFocus => focusExpanded ?? focus;
  String get displayLocation => locationExpanded ?? location;

  String get fullDescription =>
      objective != null 
          ? '$displayFocus at $displayLocation: $objective'
          : '$displayFocus at $displayLocation';

  Map<String, dynamic> toJson() => {
        'focusRoll': focusRoll,
        'focus': focus,
        'locationRoll': locationRoll,
        'location': location,
        if (objectiveRoll != null) 'objectiveRoll': objectiveRoll,
        if (objective != null) 'objective': objective,
        if (focusExpanded != null) 'focusExpanded': focusExpanded,
        if (locationExpanded != null) 'locationExpanded': locationExpanded,
      };

  factory QuestData.fromJson(Map<String, dynamic> json) => QuestData(
        focusRoll: json['focusRoll'] as int,
        focus: json['focus'] as String,
        locationRoll: json['locationRoll'] as int,
        location: json['location'] as String,
        objectiveRoll: json['objectiveRoll'] as int?,
        objective: json['objective'] as String?,
        focusExpanded: json['focusExpanded'] as String?,
        locationExpanded: json['locationExpanded'] as String?,
      );

  @override
  String toString() => fullDescription;
}

/// Data for dungeon phase tracking.
@immutable
class DungeonPhaseData {
  final String phase;
  final int roll1;
  final int roll2;
  final int chosenRoll;
  final bool isDoubles;
  final bool phaseChange;

  const DungeonPhaseData({
    required this.phase,
    required this.roll1,
    required this.roll2,
    required this.chosenRoll,
    this.isDoubles = false,
    this.phaseChange = false,
  });

  List<int> get diceResults => [roll1, roll2];

  Map<String, dynamic> toJson() => {
        'phase': phase,
        'roll1': roll1,
        'roll2': roll2,
        'chosenRoll': chosenRoll,
        'isDoubles': isDoubles,
        'phaseChange': phaseChange,
      };

  factory DungeonPhaseData.fromJson(Map<String, dynamic> json) =>
      DungeonPhaseData(
        phase: json['phase'] as String,
        roll1: json['roll1'] as int,
        roll2: json['roll2'] as int,
        chosenRoll: json['chosenRoll'] as int,
        isDoubles: json['isDoubles'] as bool? ?? false,
        phaseChange: json['phaseChange'] as bool? ?? false,
      );

  @override
  String toString() => '$phase (roll: $chosenRoll)${isDoubles ? ' DOUBLES!' : ''}';
}
