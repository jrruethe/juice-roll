// World Results - Re-exports for world-building result classes
//
// This file provides a unified import point for world-building result classes.
// The actual implementations remain in the preset files for backward compatibility.
//
// Categories covered:
// - Settlement generation (names, establishments, NPCs)
// - Dungeon generation (areas, encounters, traps)
// - Quest generation
// - Object/Treasure generation
// - Location generation

// Re-export settlement result types
export '../../presets/settlement.dart' 
    show SettlementNameResult, SettlementDetailResult, EstablishmentCountResult,
         EstablishmentNameResult, SettlementPropertiesResult, SimpleNpcResult,
         MultiEstablishmentResult, FullSettlementResult, CompleteSettlementResult;

// Re-export dungeon result types
export '../../presets/dungeon_generator.dart' 
    show DungeonNameResult, DungeonAreaResult, DungeonDetailResult,
         FullDungeonAreaResult, DungeonMonsterResult, DungeonTrapResult,
         DungeonEncounterResult, TwoPassAreaResult, TrapProcedureResult;

// Re-export quest result types
export '../../presets/quest.dart' 
    show QuestResult;

// Re-export object/treasure result types
export '../../presets/object_treasure.dart' 
    show ObjectTreasureResult;

// Re-export location result types
export '../../presets/location.dart' 
    show LocationResult;

// Re-export immersion result types (atmosphere, sensory details)
export '../../presets/immersion.dart' 
    show SensoryDetailResult, EmotionalAtmosphereResult, FullImmersionResult;

// Re-export abstract icon results (visual oracle)
export '../../presets/abstract_icons.dart' 
    show AbstractIconResult;
