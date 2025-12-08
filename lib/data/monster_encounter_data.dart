/// Static table data for Monster Encounter generator.
/// Extracted from monster_encounter.dart to separate data from logic.
/// 
/// Reference: Monster tables from wilderness exploration
library;

/// Monster table rows (index 0-11)
/// Rows 0-9 are standard, 10 is *, 11 is **
/// Each entry: [Tracks, Easy, Medium, Hard, Boss]
/// + prefix = half CR, - prefix = double CR
const List<List<String>> monsterTable = [
  // Row 1 (index 0)
  ['+ Wolf', '- Ice Mephit', '- Winter Wolf', 'Yeti', 'Werebear'],
  // Row 2 (index 1)
  ['+ Skeleton', '- Warhorse S', '- Wight', '- Nightmare', 'Wraith'],
  // Row 3 (index 2)
  ['+ Drow', '- G Spider', '- Quaggoth', '- Phase Spider', 'Drider'],
  // Row 4 (index 3)
  ['+ Goblin', '- Worg', '+ Hobgoblin', '+ Bugbear', 'Hob C'],
  // Row 5 (index 4)
  ['Orc', '- Orog', 'Orc EoG', '- Troll', 'Orc WC'],
  // Row 6* (index 5)
  ['Kobold', '+ G Weasel', '+ W Kobold', '+ Stirge', 'Y Dragon'],
  // Row 7 (index 6)
  ['Lizardfolk', 'G Lizard', 'L Shaman', '- G Crocodile', 'L King'],
  // Row 8 (index 7)
  ['+ Zombie', 'Ghoul', '- Mummy', 'Ogre Z', 'V Spawn'],
  // Row 9 (index 8)
  ['Yuan-ti PB', '- Cockatrice', '- Yuan-ti M', 'Basilisk', 'Medusa'],
  // Row 0 (index 9)
  ['Gnoll', '- G Hyena', 'Gnoll PL', '+ Jackalwere', 'Lamia'],
  // Row * (index 10)
  ['+ T Blight', '+ N Blight', '+ V Blight', '- S Mound', 'G Hag'],
  // Row ** (index 11)
  ['+ Bandit', 'Thug', 'Scout', '- Veteran', 'Bandit C'],
];

/// Full monster names for display
const Map<String, String> monsterFullNames = {
  '+ Wolf': 'Wolf (½ CR)',
  '- Ice Mephit': 'Ice Mephit (2× CR)',
  '- Winter Wolf': 'Winter Wolf (2× CR)',
  'Yeti': 'Yeti',
  'Werebear': 'Werebear',
  '+ Skeleton': 'Skeleton (½ CR)',
  '- Warhorse S': 'Warhorse Skeleton (2× CR)',
  '- Wight': 'Wight (2× CR)',
  '- Nightmare': 'Nightmare (2× CR)',
  'Wraith': 'Wraith',
  '+ Drow': 'Drow (½ CR)',
  '- G Spider': 'Giant Spider (2× CR)',
  '- Quaggoth': 'Quaggoth (2× CR)',
  '- Phase Spider': 'Phase Spider (2× CR)',
  'Drider': 'Drider',
  '+ Goblin': 'Goblin (½ CR)',
  '- Worg': 'Worg (2× CR)',
  '+ Hobgoblin': 'Hobgoblin (½ CR)',
  '+ Bugbear': 'Bugbear (½ CR)',
  'Hob C': 'Hobgoblin Captain',
  'Orc': 'Orc',
  '- Orog': 'Orog (2× CR)',
  'Orc EoG': 'Orc Eye of Gruumsh',
  '- Troll': 'Troll (2× CR)',
  'Orc WC': 'Orc War Chief',
  'Kobold': 'Kobold',
  '+ G Weasel': 'Giant Weasel (½ CR)',
  '+ W Kobold': 'Winged Kobold (½ CR)',
  '+ Stirge': 'Stirge (½ CR)',
  'Y Dragon': 'Young Dragon',
  'Lizardfolk': 'Lizardfolk',
  'G Lizard': 'Giant Lizard',
  'L Shaman': 'Lizardfolk Shaman',
  '- G Crocodile': 'Giant Crocodile (2× CR)',
  'L King': 'Lizard King',
  '+ Zombie': 'Zombie (½ CR)',
  'Ghoul': 'Ghoul',
  '- Mummy': 'Mummy (2× CR)',
  'Ogre Z': 'Ogre Zombie',
  'V Spawn': 'Vampire Spawn',
  'Yuan-ti PB': 'Yuan-ti Pureblood',
  '- Cockatrice': 'Cockatrice (2× CR)',
  '- Yuan-ti M': 'Yuan-ti Malison (2× CR)',
  'Basilisk': 'Basilisk',
  'Medusa': 'Medusa',
  'Gnoll': 'Gnoll',
  '- G Hyena': 'Giant Hyena (2× CR)',
  'Gnoll PL': 'Gnoll Pack Lord',
  '+ Jackalwere': 'Jackalwere (½ CR)',
  'Lamia': 'Lamia',
  '+ T Blight': 'Twig Blight (½ CR)',
  '+ N Blight': 'Needle Blight (½ CR)',
  '+ V Blight': 'Vine Blight (½ CR)',
  '- S Mound': 'Shambling Mound (2× CR)',
  'G Hag': 'Green Hag',
  '+ Bandit': 'Bandit (½ CR)',
  'Thug': 'Thug',
  'Scout': 'Scout',
  '- Veteran': 'Veteran (2× CR)',
  'Bandit C': 'Bandit Captain',
};

/// Environment-based monster formulas from the wilderness table
/// Format: {'modifier': int, 'advantage': String} where advantage is '+', '-', or '0'
const List<Map<String, dynamic>> environmentFormulas = [
  {'modifier': 0, 'advantage': '-'},  // 1: Arctic +0@-
  {'modifier': 0, 'advantage': '0'},  // 2: Mountains +0@0
  {'modifier': 1, 'advantage': '-'},  // 3: Cavern +1@-
  {'modifier': 1, 'advantage': '0'},  // 4: Hills +1@0
  {'modifier': 3, 'advantage': '-'},  // 5: Grassland +3@-
  {'modifier': 2, 'advantage': '0'},  // 6: Forest +2@0 (special: row 6 = Blights)
  {'modifier': 3, 'advantage': '+'},  // 7: Swamp +3@+
  {'modifier': 3, 'advantage': '0'},  // 8: Water +3@0
  {'modifier': 4, 'advantage': '-'},  // 9: Coast +4@-
  {'modifier': 4, 'advantage': '+'},  // 10: Desert +4@+
];

/// Environment names for display
const List<String> environmentNames = [
  'Arctic', 'Mountains', 'Cavern', 'Hills', 'Grassland',
  'Forest', 'Swamp', 'Water', 'Coast', 'Desert'
];
