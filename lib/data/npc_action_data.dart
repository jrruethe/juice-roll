/// Static table data for NPC Action generator.
/// Extracted from npc_action.dart to separate data from logic.
/// 
/// Reference: npc-action.md tables
/// Header notation: Disp: d 10A/6P; Ctx: @+A/-P; WH: ΔCtx, SH: ΔCtx & +/-1
library;

/// Personality traits - d10 (0-9 mapped to 1-10)
const List<String> npcPersonalities = [
  'Cautious',      // 1
  'Curious',       // 2
  'Careless',      // 3
  'Organized',     // 4
  'Reserved',      // 5
  'Outgoing',      // 6
  'Critical',      // 7
  'Compassionate', // 8
  'Confident',     // 9
  'Sensitive',     // 0/10
];

/// NPC needs - d10
const List<String> npcNeeds = [
  'Sustenance',   // 1
  'Shelter',      // 2
  'Recovery',     // 3
  'Security',     // 4
  'Stability',    // 5
  'Friendship',   // 6
  'Acceptance',   // 7
  'Status',       // 8
  'Recognition',  // 9
  'Fulfillment',  // 0/10
];

/// Motive/Topic - d10
const List<String> npcMotives = [
  'History',      // 1 (italic in original - past)
  'Family',       // 2
  'Experience',   // 3
  'Flaws',        // 4
  'Reputation',   // 5
  'Superiors',    // 6
  'Wealth',       // 7
  'Equipment',    // 8
  'Treasure',     // 9
  'Focus',        // 0/10 (italic - context)
];

/// Actions - d10
const List<String> npcActions = [
  'Ambiguous Action', // 1
  'Talks',            // 2
  'Continues',        // 3
  'Act: PC Interest', // 4
  'Next Most Logical',// 5
  'Gives Something',  // 6
  'End Encounter',    // 7
  'Act: Self Interest',// 8
  'Takes Something',  // 9
  'Enters Combat',    // 0/10
];

/// Combat actions - d10
const List<String> npcCombatActions = [
  'Defend',      // 1
  'Shift Focus', // 2
  'Seize',       // 3
  'Intimidate',  // 4
  'Advantage',   // 5
  'Coordinate',  // 6
  'Lure',        // 7
  'Destroy',     // 8
  'Precision',   // 9
  'Power',       // 0/10
];

/// Focus entries that require sub-rolls (italic in the original table)
const Set<String> npcItalicFocuses = {
  'Monster', 'Event', 'Environment', 'Person', 'Location', 'Object'
};
