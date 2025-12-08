// Character Results - Re-exports for character/NPC-related result classes
//
// This file provides a unified import point for character-related result classes.
// The actual implementations remain in the preset files for backward compatibility.
//
// Categories covered:
// - NPC Action (personality, need, motive, action, combat)
// - NPC Profiles (simple, full, complex)
// - Dialog generation
// - Extended NPC conversation
// - Name generation

// Re-export NPC result types from their original locations
export '../../presets/npc_action.dart' 
    show NpcActionResult, NpcProfileResult, SimpleNpcProfileResult, 
         ComplexNpcResult, DualPersonalityResult, MotiveWithFollowUpResult,
         NpcColumn, NpcColumnDisplay, NpcDisposition, NpcContext, 
         NpcFocus, NpcObjective, NeedSkew;

// Re-export dialog and conversation results
export '../../presets/dialog_generator.dart' 
    show DialogResult;

export '../../presets/extended_npc_conversation.dart' 
    show InformationResult, CompanionResponseResult, DialogTopicResult;

// Re-export name generation results
export '../../presets/name_generator.dart' 
    show NameResult;

// Re-export detail results (used by NPC profiles)
export '../../presets/details.dart' 
    show DetailResult, PropertyResult, DetailWithFollowUpResult, DetailType;
