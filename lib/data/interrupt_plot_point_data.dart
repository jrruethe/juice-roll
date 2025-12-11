/// Static table data for Interrupt/Plot Point generator.
/// Extracted from interrupt_plot_point.dart to separate data from logic.
/// 
/// Reference: interrupt-plot-point.md tables
library;

/// Categories (first d10 determines column) - mapped by ranges
const Map<int, String> categories = {
  1: 'Action',
  2: 'Action',
  3: 'Tension',
  4: 'Tension',
  5: 'Mystery',
  6: 'Mystery',
  7: 'Social',
  8: 'Social',
  9: 'Personal',
  0: 'Personal', // 10 = 0
};

/// Action events (1-2 column) - d10
const List<String> actionEvents = [
  'Abduction',    // 1
  'Barrier',      // 2
  'Battle',       // 3
  'Chase',        // 4
  'Collateral',   // 5
  'Crash',        // 6
  'Culmination',  // 7
  'Distraction',  // 8
  'Harm',         // 9
  'Intensify',    // 0/10
];

/// Tension events (3-4 column) - d10
const List<String> tensionEvents = [
  'Choice',       // 1
  'Depletion',    // 2
  'Enemy',        // 3
  'Intimidation', // 4
  'Night',        // 5
  'Public',       // 6
  'Recurrence',   // 7
  'Remote',       // 8
  'Shady',        // 9
  'Trapped',      // 0/10
];

/// Mystery events (5-6 column) - d10
const List<String> mysteryEvents = [
  'Alternate',     // 1
  'Behavior',      // 2
  'Connected',     // 3
  'Information',   // 4
  'Intercept',     // 5
  'Lucky',         // 6
  'Reappearance',  // 7
  'Revelation',    // 8
  'Secret',        // 9
  'Source',        // 0/10
];

/// Social events (7-8 column) - d10
const List<String> socialEvents = [
  'Agreement',      // 1
  'Gathering',      // 2
  'Government',     // 3
  'Inadequate',     // 4
  'Injustice',      // 5
  'Misbehave',      // 6
  'Outcast',        // 7
  'Outside',        // 8
  'Reinforcements', // 9
  'Savior',         // 0/10
];

/// Personal events (9-0 column) - d10
const List<String> personalEvents = [
  'Animosity',   // 1
  'Connection',  // 2
  'Dependent',   // 3
  'Ethical',     // 4
  'Flee',        // 5
  'Friend',      // 6
  'Help',        // 7
  'Home',        // 8
  'Humiliation', // 9
  'Offer',       // 0/10
];
