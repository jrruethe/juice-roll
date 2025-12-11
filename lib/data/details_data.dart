/// Static table data for Details generator.
/// Extracted from details.dart to separate data from logic.
/// 
/// Reference: details.md tables
library;

/// Colors - d10
const List<String> colors = [
  'Shade Black',       // 1
  'Leather Brown',     // 2
  'Highlight Yellow',  // 3
  'Forest Green',      // 4
  'Cobalt Blue',       // 5
  'Crimson Red',       // 6
  'Royal Violet',      // 7
  'Metallic Silver',   // 8
  'Midas Gold',        // 9
  'Holy White',        // 0/10
];

/// Color emoji (for display)
const List<String> colorEmoji = [
  '⬛', // Black
  '🟫', // Brown
  '🟨', // Yellow
  '🟩', // Green
  '🟦', // Blue
  '🟥', // Red
  '🟪', // Violet
  '⬜', // Silver
  '🟨', // Gold
  '⬜', // White
];

/// Properties - d10
const List<String> properties = [
  'Age',        // 1
  'Durability', // 2
  'Familiarity',// 3
  'Power',      // 4
  'Quality',    // 5
  'Rarity',     // 6
  'Size',       // 7
  'Style',      // 8
  'Value',      // 9
  'Weight',     // 0/10
];

/// Detail modifiers - d10
const List<String> detailModifiers = [
  'Negative Emotion',  // 1
  'Disfavors PC',      // 2
  'Disfavors Thread',  // 3
  'Disfavors NPC',     // 4
  'History',           // 5 (italic - roll on history)
  'Property',          // 6 (italic - roll on property)
  'Favors NPC',        // 7
  'Favors Thread',     // 8
  'Favors PC',         // 9
  'Positive Emotion',  // 0/10
];

/// History context - d10
const List<String> histories = [
  'Backstory',        // 1
  'Past Thread',      // 2
  'Previous Thread',  // 3
  'Past Scene',       // 4
  'Previous Scene',   // 5
  'Current Thread',   // 6
  'Past Action',      // 7
  'Current Scene',    // 8
  'Previous Action',  // 9
  'Current Action',   // 0/10
];
