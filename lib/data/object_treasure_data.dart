/// Static table data for Object and Treasure generator.
/// Extracted from object_treasure.dart to separate data from logic.
/// 
/// Reference: object-treasure.md tables
library;

// === TRINKET (1) ===
const List<String> trinketQualities = [
  'Broken',      // 1
  'Damaged',     // 2
  'Worn',        // 3
  'Simple',      // 4
  'Exceptional', // 5
  'Magic',       // 6
];

const List<String> trinketMaterials = [
  'Wood',    // 1
  'Bone',    // 2
  'Leather', // 3
  'Silver',  // 4
  'Gold',    // 5
  'Gem',     // 6
];

const List<String> trinketTypes = [
  'Toy/Game',   // 1
  'Bottle',     // 2
  'Instrument', // 3
  'Charm',      // 4
  'Tool',       // 5
  'Key',        // 6
];

// === TREASURE (2) ===
const List<String> treasureQualities = [
  'Dusty',  // 1
  'Worn',   // 2
  'Sturdy', // 3
  'Fine',   // 4
  'New',    // 5
  'Ornate', // 6
];

const List<String> treasureContainers = [
  'None',    // 1
  'Pouch',   // 2
  'Box',     // 3
  'Satchel', // 4
  'Crate',   // 5
  'Chest',   // 6
];

const List<String> treasureContents = [
  'Food',         // 1
  'Art',          // 2
  'Deed',         // 3
  'Silver Coins', // 4
  'Gold Coins',   // 5
  'Gems',         // 6
];

// === DOCUMENT (3) ===
const List<String> documentTypes = [
  'Song',        // 1
  'Picture',     // 2
  'Letter/Note', // 3
  'Scroll',      // 4
  'Journal',     // 5
  'Book',        // 6
];

const List<String> documentContents = [
  'Lewd',      // 1
  'Common',    // 2
  'Map',       // 3
  'Prophecy',  // 4
  'Arcane',    // 5
  'Forbidden', // 6
];

const List<String> documentSubjects = [
  'Religion',  // 1
  'Art',       // 2
  'Science',   // 3
  'Creatures', // 4
  'History',   // 5
  'Magic',     // 6
];

// === ACCESSORY (4) ===
const List<String> accessoryQualities = [
  'Ruined',  // 1
  'Crude',   // 2
  'Simple',  // 3
  'Fine',    // 4
  'Crafted', // 5
  'Magic',   // 6
];

const List<String> accessoryMaterials = [
  'Wood',    // 1
  'Bone',    // 2
  'Leather', // 3
  'Silver',  // 4
  'Gold',    // 5
  'Gem',     // 6
];

const List<String> accessoryTypes = [
  'Headpiece', // 1
  'Emblem',    // 2
  'Earring',   // 3
  'Bracelet',  // 4
  'Necklace',  // 5
  'Ring',      // 6
];

// === WEAPON (5) ===
const List<String> weaponQualities = [
  'Broken',     // 1
  'Improvised', // 2
  'Rough',      // 3
  'Simple',     // 4
  'Martial',    // 5
  'Masterwork', // 6
];

const List<String> weaponMaterials = [
  'Wood',       // 1
  'Bone',       // 2
  'Steel',      // 3
  'Silver',     // 4
  'Mithral',    // 5
  'Adamantine', // 6
];

const List<String> weaponTypes = [
  'Axe/Hammer',     // 1
  'Halberd/Spear',  // 2
  'Sword/Dagger',   // 3
  'Staff/Wand',     // 4
  'Bow',            // 5
  'Exotic',         // 6
];

// === ARMOR (6) ===
const List<String> armorQualities = [
  'Broken',   // 1
  'Crude',    // 2
  'Rough',    // 3
  'Simple',   // 4
  'Martial',  // 5
  'Masterwork', // 6
];

const List<String> armorMaterials = [
  'Cloth',      // 1
  'Leather',    // 2
  'Bone',       // 3
  'Steel',      // 4
  'Mithral',    // 5
  'Adamantine', // 6
];

const List<String> armorTypes = [
  'Helmet',     // 1
  'Torso',      // 2
  'Arms',       // 3
  'Legs',       // 4
  'Shield',     // 5
  'Full Suit',  // 6
];

/// Object types for d6 roll
const List<String> objectTypes = [
  'Trinket',   // 1
  'Treasure',  // 2
  'Document',  // 3
  'Accessory', // 4
  'Weapon',    // 5
  'Armor',     // 6
];

/// Treasure categories (d6) - alias for objectTypes
const List<String> treasureCategories = [
  'Trinket',   // 1
  'Treasure',  // 2
  'Document',  // 3
  'Accessory', // 4
  'Weapon',    // 5
  'Armor',     // 6
];
