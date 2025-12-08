/// Static table data for Wilderness Generator.
/// Extracted from wilderness.dart to separate data from logic.
/// 
/// Reference: wilderness-table.md
/// Formula: 2dF Env → 1dF Type; W: 1d6@E+T; M: 1d6+E
library;

/// Full environment list (d10, rows 1-10)
const List<String> wildernessEnvironments = [
  'Arctic',     // 1
  'Mountains',  // 2
  'Cavern',     // 3
  'Hills',      // 4
  'Grassland',  // 5
  'Forest',     // 6
  'Swamp',      // 7
  'Water',      // 8
  'Coast',      // 9
  'Desert',     // 10
];

/// Type data: modifier for weather, name, and weather skew symbol
/// Indexed 0-9 for rows 1-10
const List<Map<String, dynamic>> wildernessTypes = [
  {'modifier': 0, 'name': 'Snowy', 'skew': '-'},     // 1
  {'modifier': 2, 'name': 'Rocky', 'skew': '-'},     // 2
  {'modifier': 3, 'name': 'Expansive', 'skew': '0'}, // 3
  {'modifier': 2, 'name': 'Windy', 'skew': '-'},     // 4
  {'modifier': 4, 'name': 'Scrub', 'skew': '0'},     // 5
  {'modifier': 3, 'name': 'Tropical', 'skew': '0'},  // 6
  {'modifier': 1, 'name': 'Dark', 'skew': '+'},      // 7
  {'modifier': 3, 'name': 'Exotic', 'skew': '+'},    // 8
  {'modifier': 4, 'name': 'Sandy', 'skew': '0'},     // 9
  {'modifier': 4, 'name': 'Arid', 'skew': '+'},      // 10
];

/// Encounter types (d10)
/// Italicized encounters in the reference table are marked with isItalic: true
/// These represent: Natural Hazard, Monster, Weather, Challenge, Dungeon, Feature, and Settlement (but not Camp)
const List<Map<String, dynamic>> wildernessEncounters = [
  {'name': 'Natural Hazard', 'isItalic': true},    // 1
  {'name': 'Monster', 'isItalic': true},           // 2
  {'name': 'Weather', 'isItalic': true},           // 3
  {'name': 'Challenge', 'isItalic': true},         // 4
  {'name': 'Dungeon', 'isItalic': true},           // 5
  {'name': 'River/Road', 'isItalic': false},       // 6
  {'name': 'Feature', 'isItalic': true},           // 7
  {'name': 'Settlement/Camp', 'isItalic': true, 'partialItalic': 'Settlement'},   // 8 - Only "Settlement" is italic
  {'name': 'Advance Plot', 'isItalic': false},     // 9
  {'name': 'Destination/Lost', 'isItalic': false}, // 10
];

/// Weather conditions (rows 1-10)
const List<String> wildernessWeatherTypes = [
  'Blizzard',       // 1
  'Snow Flurries',  // 2
  'Freezing Cold',  // 3
  'Thunder Storm',  // 4
  'Heavy Rain',     // 5
  'Light Rain',     // 6
  'Heavy Clouds',   // 7
  'High Winds',     // 8
  'Clear Skies',    // 9
  'Scorching Heat', // 10
];

/// Monster level formulas (modifier + advantage type) by environment
const List<Map<String, dynamic>> wildernessMonsterFormulas = [
  {'modifier': 0, 'advantage': '-'},  // 1: Arctic +0@-
  {'modifier': 0, 'advantage': '0'},  // 2: Mountains +0@0
  {'modifier': 1, 'advantage': '-'},  // 3: Cavern +1@-
  {'modifier': 1, 'advantage': '0'},  // 4: Hills +1@0
  {'modifier': 3, 'advantage': '-'},  // 5: Grassland +3@-
  {'modifier': 2, 'advantage': '0'},  // 6: Forest +2@0
  {'modifier': 3, 'advantage': '+'},  // 7: Swamp +3@+
  {'modifier': 3, 'advantage': '0'},  // 8: Water +3@0
  {'modifier': 4, 'advantage': '-'},  // 9: Coast +4@-
  {'modifier': 4, 'advantage': '+'},  // 10: Desert +4@+
];

/// Natural hazards (d10)
const List<String> wildernessNaturalHazards = [
  'Creature Tracks',  // 1
  'Dust Storm',       // 2
  'Flood',            // 3
  'Fog',              // 4
  'Rockslide',        // 5
  'Unstable Ground',  // 6
  'Crevice',          // 7
  'Escarpment',       // 8
  'River Crossing',   // 9
  'Thick Plants',     // 10
];

/// Wilderness features (d10)
const List<String> wildernessFeatures = [
  'Bones',     // 1
  'Cairn',     // 2
  'Chasm',     // 3
  'Circle',    // 4
  'Spring',    // 5
  'Grave',     // 6
  'Monument',  // 7
  'Tower',     // 8
  'Tree',      // 9
  'Well',      // 10
];

// ========== Helper Functions ==========

/// Get encounter name by index
String getWildernessEncounterName(int index) {
  return wildernessEncounters[index]['name'] as String;
}

/// Check if encounter should be displayed in italics
bool isWildernessEncounterItalic(int index) {
  return wildernessEncounters[index]['isItalic'] as bool;
}

/// For partial italic (Settlement/Camp), get the italic portion
String? getWildernessPartialItalic(int index) {
  return wildernessEncounters[index]['partialItalic'] as String?;
}
