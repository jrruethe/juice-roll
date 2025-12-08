/// Static table data for Settlement generator.
/// Extracted from settlement.dart to separate data from logic.
/// 
/// Reference: settlement.md tables
library;

/// Name prefixes - d10
const List<String> settlementNamePrefixes = [
  'Frost',  // 1
  'High',   // 2
  'Long',   // 3
  'Lost',   // 4
  'Raven',  // 5
  'Shield', // 6
  'Storm',  // 7
  'Sword',  // 8
  'Thorn',  // 9
  'Wolf',   // 0/10
];

/// Name suffixes - d10
const List<String> settlementNameSuffixes = [
  'Barrow', // 1
  'Brook',  // 2
  'Fall',   // 3
  'Haven',  // 4
  'Ridge',  // 5
  'River',  // 6
  'Rock',   // 7
  'Stead',  // 8
  'Stone',  // 9
  'Wood',   // 0/10
];

/// Establishments - d10 (d6 for villages, d10 for cities)
const List<String> settlementEstablishments = [
  'Stable',        // 1
  'Tavern',        // 2
  'Inn',           // 3
  'Entertainment', // 4
  'General Store', // 5
  'Artisan',       // 6 (roll on artisan table)
  'Courier',       // 7
  'Temple',        // 8
  'Guild Hall',    // 9
  'Magic Shop',    // 0/10
];

/// Establishment descriptions for display.
const Map<String, String> settlementEstablishmentDescriptions = {
  'Stable': 'Rent/buy horses, pay for transportation to another area.',
  'Tavern': 'Food, drink, stories, rumors. Great for NPC info and side quests.',
  'Inn': 'Spend the night and rest safely. Sometimes combined with Tavern.',
  'Entertainment': 'Market, bath house, casino, brothel, etc.',
  'General Store': 'Basics and common items. Stock up on rations and torches.',
  'Artisan': 'Specialist craftsperson. Better quality, repairs, custom orders.',
  'Courier': 'Send messages, money, packages. Receive news from other settlements.',
  'Temple': 'Pray, receive blessings, remove curses. Library access for history.',
  'Guild Hall': 'Quest distribution, guild services. May offer food and lodging.',
  'Magic Shop': 'Potions, arcane books, dark secrets, trinkets, artificers.',
};

/// Artisans - d10
const List<String> settlementArtisans = [
  'Artist',     // 1
  'Baker',      // 2
  'Tailor',     // 3
  'Tanner',     // 4
  'Archer',     // 5
  'Blacksmith', // 6
  'Carpenter',  // 7
  'Apothecary', // 8
  'Jeweler',    // 9
  'Scribe',     // 0/10
];

/// Artisan descriptions.
const Map<String, String> settlementArtisanDescriptions = {
  'Artist': 'Painter, calligrapher, cartologist (maps), glassblower.',
  'Baker': 'Delicious meals, breads, rations.',
  'Tailor': 'Clothing, costumes, light armor.',
  'Tanner': 'Leather armor (medium), accessories, saddles.',
  'Archer': 'Bows, bowstrings, arrows, quivers.',
  'Blacksmith': 'Weapons, heavy armor, metal accessories.',
  'Carpenter': 'Wagons, structures, furniture, wood items.',
  'Apothecary': 'Medicine, herbs, pharmacy. Knowledge of flora.',
  'Jeweler': 'Gems, appraisal, cutting, magic infusion, engravings.',
  'Scribe': 'Formal letters, magical scrolls, legal documents, forgery.',
};

/// News/Events - d10
const List<String> settlementNews = [
  'War',              // 1
  'Sickness',         // 2
  'Natural Disaster', // 3
  'Crime',            // 4
  'Succession',       // 5
  'Remote Event',     // 6
  'Arrival',          // 7
  'Mail',             // 8
  'Sale',             // 9
  'Celebration',      // 0/10
];

/// News descriptions.
const Map<String, String> settlementNewsDescriptions = {
  'War': 'Battle, civil war, trade war, gang rivalry, shop competition, debate.',
  'Sickness': 'Plague, celebrity illness, crop fungus, dying trees.',
  'Natural Disaster': 'Fire, earthquake, flood, tornado.',
  'Crime': 'Assassination, theft, racketeering, smuggling.',
  'Succession': 'Death, term ended, coming of age, election, retirement.',
  'Remote Event': 'News from far away. Update on a previous Remote Event.',
  'Arrival': 'Someone/something is coming. King? Army? Music group? Adventurers?',
  'Mail': 'You\'ve got mail! Letter or package. Good or bad news?',
  'Sale': 'Shop or market sale today. Act quick for discount!',
  'Celebration': 'Festival or event. Holiday? Birthday? Anniversary?',
};
