/// Static table data for Challenge generator.
/// Extracted from challenge.dart to separate data from logic.
/// 
/// Reference: random-event-challenge.md tables
library;

/// Physical challenges - d10
const List<String> physicalChallenges = [
  'Medicine',        // 1
  'Survival',        // 2
  'Animal Handling', // 3
  'Performance',     // 4
  'Intimidation',    // 5
  'Perception',      // 6
  'Sleight of Hand', // 7
  'Stealth',         // 8
  'Acrobatics',      // 9
  'Athletics',       // 0/10
];

/// Mental challenges - d10
const List<String> mentalChallenges = [
  'Tool',        // 1
  'Nature',      // 2
  'Investigate', // 3
  'Persuasion',  // 4
  'Deception',   // 5
  'Language',    // 6
  'Religion',    // 7
  'Arcana',      // 8
  'History',     // 9
  'Insight',     // 0/10
];

/// DC values (corresponds to d10 roll) - from the table
/// Row 1 = DC 17, Row 0/10 = DC 8
const List<int> dcValues = [
  17, // 1
  16, // 2
  15, // 3
  14, // 4
  13, // 5
  12, // 6
  11, // 7
  10, // 8
  9,  // 9
  8,  // 0/10
];

/// Percentage chance ranges (corresponds to d100 roll) - for Balanced DC
/// These form a bell curve weighting toward the middle DCs.
const List<List<int>> percentageRanges = [
  [1, 2],    // 1 -> DC 17
  [3, 8],    // 2 -> DC 16
  [9, 18],   // 3 -> DC 15
  [19, 33],  // 4 -> DC 14
  [34, 50],  // 5 -> DC 13
  [51, 67],  // 6 -> DC 12
  [68, 82],  // 7 -> DC 11
  [83, 92],  // 8 -> DC 10
  [93, 98],  // 9 -> DC 9
  [99, 100], // 0/10 -> DC 8
];
