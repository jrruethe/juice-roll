/// Static table data for Random Event generator.
/// Extracted from random_event.dart to separate data from logic.
/// 
/// Reference: random-event-challenge.md and random-tables.md
library;

/// Event focus types - d10 (from random-event-challenge.md)
const List<String> eventFocusTypes = [
  'Advance Time',    // 1
  'Close Thread',    // 2
  'Converge Thread', // 3
  'Diverge Thread',  // 4
  'Immersion',       // 5
  'Keyed Event',     // 6
  'New Character',   // 7
  'NPC Action',      // 8
  'Plot Armor',      // 9
  'Remote Event',    // 0/10
];

/// Modifier words - d10 (from random-tables.md)
const List<String> modifierWords = [
  'Change',     // 1
  'Continue',   // 2
  'Decrease',   // 3
  'Extra',      // 4
  'Increase',   // 5
  'Mundane',    // 6
  'Mysterious', // 7
  'Start',      // 8
  'Stop',       // 9
  'Strange',    // 0/10
];

/// Idea words (1-3) - d10
const List<String> ideaWords = [
  'Attention',     // 1
  'Communication', // 2
  'Danger',        // 3
  'Element',       // 4
  'Food',          // 5
  'Home',          // 6
  'Resource',      // 7
  'Rumor',         // 8
  'Secret',        // 9
  'Vow',           // 0/10
];

/// Event words (4-6) - d10
const List<String> eventWords = [
  'Ambush',    // 1
  'Anomaly',   // 2
  'Blessing',  // 3
  'Caravan',   // 4
  'Curse',     // 5
  'Discovery', // 6
  'Escape',    // 7
  'Journey',   // 8
  'Prophecy',  // 9
  'Ritual',    // 0/10
];

/// Person words (7-8) - d10
const List<String> personWords = [
  'Criminal',    // 1
  'Entertainer', // 2
  'Expert',      // 3
  'Mage',        // 4
  'Mercenary',   // 5
  'Noble',       // 6
  'Priest',      // 7
  'Ranger',      // 8
  'Soldier',     // 9
  'Transporter', // 0/10
];

/// Object words (9-0) - d10
const List<String> objectWords = [
  'Arrow',     // 1
  'Candle',    // 2
  'Cauldron',  // 3
  'Chain',     // 4
  'Claw',      // 5
  'Hook',      // 6
  'Hourglass', // 7
  'Quill',     // 8
  'Rose',      // 9
  'Skull',     // 0/10
];
