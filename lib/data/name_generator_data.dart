/// Static table data for Name Generator.
/// Extracted from name_generator.dart to separate data from logic.
/// 
/// Reference: meaning-name-generator.md tables (pages 61-64)
library;

/// Syllable table (d20) - First column
/// Rows 1-5 have alternate forms: (f)a, (p)e, (v)i, (n)o, (s)u
/// Use the vowel form at the start of a name, consonant form otherwise.
const List<String> syllables1 = [
  'a',    // 1 - or 'fa' if not at start
  'e',    // 2 - or 'pe' if not at start
  'i',    // 3 - or 'vi' if not at start
  'o',    // 4 - or 'no' if not at start
  'u',    // 5 - or 'su' if not at start
  'de',   // 6
  'ka',   // 7
  'li',   // 8
  'ma',   // 9
  'ro',   // 10
  'be',   // 11
  'da',   // 12
  'ki',   // 13
  'le',   // 14
  'mi',   // 15
  'ne',   // 16
  'ru',   // 17
  'si',   // 18
  'ta',   // 19
  'to',   // 20
];

/// Alternate forms for syllables1 rows 1-5 (consonant + vowel)
/// Used when this syllable is not at the start of the name.
const List<String> syllables1Alt = [
  'fa',   // 1
  'pe',   // 2
  'vi',   // 3
  'no',   // 4
  'su',   // 5
];

/// Syllable table (d20) - Second column
const List<String> syllables2 = [
  'hal',   // 1
  'ris',   // 2
  'del',   // 3
  'mor',   // 4
  'bar',   // 5
  'net',   // 6
  'kel',   // 7
  'lim',   // 8
  'tur',   // 9
  'pen',   // 10
  'rond',  // 11
  'kay',   // 12
  'jam',   // 13
  'vash',  // 14
  'zab',   // 15
  'yos',   // 16
  'gran',  // 17
  'ched',  // 18
  'sark',  // 19
  'kic',   // 20
];

/// Syllable table (d20) - Third column
/// Rows 1-10: masculine-sounding endings
/// Rows 11-20: feminine-sounding endings
const List<String> syllables3 = [
  'an',    // 1 - masculine
  'ar',    // 2 - masculine
  'er',    // 3 - masculine
  'ian',   // 4 - masculine
  'ic',    // 5 - masculine
  'in',    // 6 - masculine
  'o',     // 7 - masculine
  'on',    // 8 - masculine
  'or',    // 9 - masculine
  'us',    // 10 - masculine
  'a',     // 11 - feminine
  'aea',   // 12 - feminine
  'aya',   // 13 - feminine
  'elle',  // 14 - feminine
  'ene',   // 15 - feminine
  'ess',   // 16 - feminine
  'ette',  // 17 - feminine
  'ice',   // 18 - feminine
  'id',    // 19 - feminine
  'osa',   // 20 - feminine
];

/// Pattern definitions from the instructions
const List<String> patterns = [
  '12o',    // 1
  '12',     // 2
  '12',     // 3
  '23-o',   // 4
  '23-',    // 5
  '23-',    // 6
  '123-o',  // 7
  '123-',   // 8
  '123-',   // 9
  '111',    // 10
  '111',    // 11
  '123',    // 12
  '12a',    // 13
  '12i',    // 14
  '23-a',   // 15
  '23-i',   // 16
  '23+',    // 17
  '123-a',  // 18
  '123-i',  // 19
  '123+',   // 20
];
