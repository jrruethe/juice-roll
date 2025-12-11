/// Static table data for Quest generator.
/// Extracted from quest.dart to separate data from logic.
/// 
/// Reference: quest.md tables
library;

/// Objectives - d10
const List<String> objectives = [
  'Attain',     // 1
  'Create',     // 2
  'Deliver',    // 3
  'Destroy',    // 4
  'Fetch',      // 5
  'Infiltrate', // 6
  'Investigate',// 7
  'Negotiate',  // 8
  'Protect',    // 9
  'Survive',    // 0/10
];

/// Descriptions - d10 (row 3 Colorful is italicized - references Color table)
const List<String> descriptions = [
  'Abandoned',  // 1
  'Cold',       // 2
  'Colorful',   // 3 (italic - roll Color table)
  'Connected',  // 4
  'Dark',       // 5
  'Friendly',   // 6
  'Hidden',     // 7
  'Mystical',   // 8
  'Remote',     // 9
  'Wounded',    // 0/10
];

/// Focus - d10 (italicized entries reference other tables)
const List<String> focuses = [
  'Enemy',       // 1
  'Monster',     // 2 (italic - roll Monster Descriptors)
  'Event',       // 3 (italic - roll Event)
  'Environment', // 4 (italic - roll Environment)
  'Community',   // 5
  'Person',      // 6 (italic - roll Person)
  'Information', // 7
  'Location',    // 8 (italic - roll Settlement Name)
  'Object',      // 9 (italic - roll Object)
  'Ally',        // 0/10
];

/// Prepositions - d10
const List<String> prepositions = [
  'Around',      // 1
  'Behind',      // 2
  'In Front Of', // 3
  'Near',        // 4
  'On Top Of',   // 5
  'At',          // 6
  'From',        // 7
  'Inside Of',   // 8
  'Outside Of',  // 9
  'Under',       // 0/10
];

/// Locations - d10 (italicized entries reference other tables)
const List<String> locations = [
  'Community',         // 1
  'Dungeon Feature',   // 2 (italic - roll Dungeon Feature)
  'Dungeon',           // 3 (italic - roll Dungeon Name)
  'Environment',       // 4 (italic - roll Environment)
  'Event',             // 5 (italic - roll Event)
  'Natural Hazard',    // 6 (italic - roll Natural Hazard)
  'Outpost',           // 7
  'Settlement',        // 8 (italic - roll Settlement Name)
  'Transportation',    // 9
  'Wilderness Feature',// 0/10 (italic - roll Wilderness Feature)
];

/// Description entries that require sub-rolls (italic in the original table)
const Set<String> italicDescriptions = {'Colorful'};

/// Focus entries that require sub-rolls (italic in the original table)
const Set<String> italicFocuses = {
  'Monster', 'Event', 'Environment', 'Person', 'Location', 'Object'
};

/// Location entries that require sub-rolls (italic in the original table)
const Set<String> italicLocations = {
  'Dungeon Feature', 'Dungeon', 'Environment', 'Event', 
  'Natural Hazard', 'Settlement', 'Wilderness Feature'
};
