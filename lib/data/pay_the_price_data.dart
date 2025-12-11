/// Static table data for Pay the Price generator.
/// Extracted from pay_the_price.dart to separate data from logic.
/// 
/// Reference: pay-the-price.md tables
library;

/// Standard consequences - d10
const List<String> consequences = [
  'Action has Unintended Effect',       // 1
  'Current Situation Worsens',          // 2
  'Delayed / Disadvantaged',            // 3
  'Forced to Act Against Intentions',   // 4
  'New Danger / Foe Revealed',          // 5
  'Person / Community Exposed to Danger', // 6
  'Separated from Person / Thing',      // 7
  'Something of Value Lost / Destroyed', // 8
  'Surprise Complication',              // 9
  'Trusted Person Betrays You',         // 0/10
];

/// Major plot twists (for critical failures) - d10
const List<String> majorTwists = [
  'Actions Benefit Enemy',            // 1
  'Assumption Is False',              // 2
  'Dark Secret Revealed',             // 3
  'Enemy Gains New Allies',           // 4
  'Enemy Shares a Common Goal',       // 5
  'It was all a Diversion',           // 6
  'Secret Alliance Revealed',         // 7
  'Someone Returns Unexpectedly',     // 8
  'Unrelated Situations Connected',   // 9
  'You are too late',                 // 0/10
];
