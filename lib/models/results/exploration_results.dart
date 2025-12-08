// Exploration Results - Re-exports for exploration/encounter result classes
//
// This file provides a unified import point for exploration-related result classes.
// The actual implementations remain in the preset files for backward compatibility.
//
// Categories covered:
// - Wilderness exploration (areas, weather, encounters)
// - Monster encounters
// - Challenge/skill checks
// - Scale (distance, time, quantity)
// - Pay the Price (consequences)

// Re-export wilderness result types
export '../../presets/wilderness.dart' 
    show WildernessAreaResult, WildernessEncounterResult, WildernessWeatherResult,
         WildernessDetailResult, MonsterLevelResult;

// Re-export monster encounter result types
export '../../presets/monster_encounter.dart' 
    show FullMonsterEncounterResult, MonsterEncounterResult, MonsterTracksResult;

// Re-export challenge result types
export '../../presets/challenge.dart' 
    show FullChallengeResult, ChallengeSkillResult, QuickDcResult;

// Re-export scale result types
export '../../presets/scale.dart' 
    show ScaleResult;

// Re-export pay the price result types
export '../../presets/pay_the_price.dart' 
    show PayThePriceResult;
