/// Static table data for Dungeon Generator.
/// Extracted from dungeon_generator.dart to separate data from logic.
/// 
/// Reference: Dungeon tables from juice-oracle docs
/// Heading: NA: 1d10@- Until Doubles, Then NA: 1d10@+
library;

/// Next Area results - d10
/// Disadvantage = Sprawling, Branching Dungeons
/// Advantage = Interconnected Dungeons with many Exits
const List<String> dungeonAreaTypes = [
  'Passage',                       // 1
  'Small Chamber: 3 Doors',        // 2
  'Large Chamber: 3 Doors',        // 3
  'Small Chamber: 2 Doors',        // 4
  'Small Chamber: 1 Door',         // 5 (dead end!)
  'Locked Door',                   // 6
  'Known / Expected',              // 7
  'Exit / Stairs',                 // 8
  'Connection to Previous Area',   // 9
  'Passage',                       // 0/10
];

/// Passage details - d10
/// Die Size: d6 = Linear Dungeons, d10 = Branching Dungeons
/// Skew: Disadvantage = Smaller Dungeons, Advantage = Larger Dungeons
const List<String> dungeonPassageTypes = [
  'Dead End',            // 1
  'Narrow Crawlspace',   // 2
  'Bridge',              // 3
  'Long',                // 4
  'Wide',                // 5
  'Expected',            // 6
  'Right Angle Turn',    // 7
  'Side Passage',        // 8
  '3-Way Intersection',  // 9
  '4-Way Intersection',  // 0/10
];

/// Room condition - d10
/// Die Size: d6 = Unoccupied, d10 = Occupied
/// Skew: Disadvantage = Worse Conditions, Advantage = Better Conditions
const List<String> dungeonRoomConditions = [
  'Partially Collapsed',    // 1
  'Holes in Floor',         // 2
  'Flooded',                // 3
  'Ashes / Burned',         // 4
  'Damaged',                // 5
  'Expected',               // 6
  'Stripped Bare',          // 7
  'Used as Campsite',       // 8
  'Converted to Other Use', // 9
  'Pristine',               // 0/10
];

/// Dungeon types - d10 (from natural-hazard-feature-dungeon.md)
/// Format: "[Dungeon] of the [Description] [Subject]"
const List<String> dungeonTypes = [
  'Catacombs',   // 1
  'Cavern',      // 2
  'Crypt',       // 3
  'Fortress',    // 4
  'Hideout',     // 5
  'Lair',        // 6
  'Mine',        // 7
  'Ruins',       // 8
  'Sanctuary',   // 9
  'Temple',      // 0/10
];

/// Dungeon name descriptions - d10 (from natural-hazard-feature-dungeon.md)
const List<String> dungeonDescriptions = [
  'Bloodstained',  // 1
  'Chaotic',       // 2
  'Endless',       // 3
  'Fallen',        // 4
  'Forbidden',     // 5
  'Forgotten',     // 6
  'Shattered',     // 7
  'Shrouded',      // 8
  'Silent',        // 9
  'Unknown',       // 0/10
];

/// Dungeon name subjects - d10 (from natural-hazard-feature-dungeon.md)
const List<String> dungeonSubjects = [
  'Blades',     // 1
  'Blight',     // 2
  'Darkness',   // 3
  'Fury',       // 4
  'Lies',       // 5
  'Madness',    // 6
  'Mist',       // 7
  'Prophecy',   // 8
  'Runes',      // 9
  'Terror',     // 0/10
];

// ============ DUNGEON ENCOUNTER TABLES ============

/// Dungeon encounter types - d10
/// Die Size: d6 = Lingering (10+ min in unsafe area), d10 = First entry
/// Skew: Advantage = Better Encounters, Disadvantage = Worse Encounters
/// 
/// Heading: 10m 1d6 (NH: d6); Trap: 10m AP@+ A/L, PP L/T
const List<String> dungeonEncounterTypes = [
  'Monster',         // 1
  'Natural Hazard',  // 2
  'Challenge',       // 3
  'Immersion',       // 4
  'Safety',          // 5
  'Known',           // 6
  'Trap',            // 7
  'Feature',         // 8
  'Key',             // 9
  'Treasure',        // 0/10
];

/// Monster descriptors - Column 1 of Monster table (d10)
const List<String> dungeonMonsterDescriptors = [
  'Agile',        // 1
  'Beast',        // 2
  'Clothed',      // 3
  'Composite',    // 4
  'Decayed',      // 5
  'Elemental',    // 6
  'Inscribed',    // 7
  'Intimidating', // 8
  'Levitating',   // 9
  'Nightmarish',  // 0/10
];

/// Monster special abilities - Column 2 of Monster table (d10)
const List<String> dungeonMonsterAbilities = [
  'Climb',     // 1
  'Detect',    // 2
  'Drain',     // 3
  'Entangle',  // 4
  'Illusion',  // 5
  'Immune',    // 6
  'Magic',     // 7
  'Paralyze',  // 8
  'Pierce',    // 9
  'Ranged',    // 0/10
];

/// Trap actions - Column 1 of Trap table (d10)
const List<String> dungeonTrapActions = [
  'Ambush',    // 1
  'Collapse',  // 2
  'Divert',    // 3
  'Imitate',   // 4
  'Lure',      // 5
  'Obscure',   // 6
  'Summon',    // 7
  'Surprise',  // 8
  'Surround',  // 9
  'Trigger',   // 0/10
];

/// Trap subjects - Column 2 of Trap table (d10)
const List<String> dungeonTrapSubjects = [
  'Alarm',      // 1
  'Barrier',    // 2
  'Decay',      // 3
  'Denizen',    // 4
  'Fall',       // 5
  'Fire',       // 6
  'Light',      // 7
  'Path',       // 8
  'Poison',     // 9
  'Projectile', // 0/10
];

/// Feature types - d10
const List<String> dungeonFeatureTypes = [
  'Library',    // 1
  'Mural',      // 2
  'Mushrooms',  // 3
  'Prison',     // 4
  'Runes',      // 5
  'Shrine',     // 6
  'Storage',    // 7
  'Vault',      // 8
  'Well',       // 9
  'Workshop',   // 0/10
];

/// Trap procedure info from heading:
/// "10m AP@+ A/L, PP L/T"
/// - Spend 10 minutes for Active Perception check with advantage
/// - Pass: Avoid, Fail: Locate
/// - Passive Perception: Pass: Locate, Fail: Trigger
const String dungeonTrapProcedure = '''
Trap Procedure:
• Active Perception (10 min, @+): Pass = Avoid, Fail = Locate
• Passive Perception: Pass = Locate, Fail = Trigger
  - Avoid: Find and completely bypass the trap
  - Locate: Find the trap, must disarm or bypass
  - Trigger: Suffer the consequences''';
