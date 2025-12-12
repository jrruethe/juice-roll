/// Example consequences/prompts for each Intensity value (1-6) for Fate Check "Because" results.
/// These are based on the Juice Oracle instructions and the "six M's" scale.
const Map<int, String> fateCheckIntensityExamples = {
  1: 'Minimal: The reason is barely relevant, a trivial detail or weak justification.',
  2: 'Minor: The reason is small, a slight influence or minor factor.',
  3: 'Mundane: The reason is ordinary, a typical or expected cause.',
  4: 'Moderate: The reason is significant, a clear and meaningful cause.',
  5: 'Major: The reason is dramatic, a strong and impactful justification.',
  6: 'Maximum: The reason is overwhelming, a total or game-changing cause.'
};

/// Example narrative prompts for each Intensity value, for use in the Fate Check display.
const Map<int, String> fateCheckIntensityPrompts = {
  1: 'Because... it barely matters. (e.g. a passing comment, a weak wind, a minor distraction)',
  2: 'Because... something small tipped the scales. (e.g. a subtle clue, a minor obstacle)',
  3: 'Because... it was the expected outcome. (e.g. routine, average, what you thought would happen)',
  4: 'Because... a clear reason stands out. (e.g. a strong clue, a direct cause, a meaningful event)',
  5: 'Because... something dramatic happened. (e.g. a major twist, a powerful force, a big reveal)',
  6: 'Because... the reason is overwhelming. (e.g. fate intervenes, a total reversal, a game-changer)'
};
