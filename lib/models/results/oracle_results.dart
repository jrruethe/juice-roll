// Oracle Results - Re-exports for oracle/fate mechanics result classes
//
// This file provides a unified import point for oracle-related result classes.
// The actual implementations remain in the preset files for backward compatibility.
//
// Categories covered:
// - Fate Check (yes/no with modifiers)
// - Expectation Check (testing assumptions)
// - Random Event generation
// - Next Scene determination
// - Discover Meaning (2-word prompts)
// - Interrupt/Plot Point generation

// Re-export oracle result types from their original locations
// This provides a single import point while maintaining backward compatibility
export '../../presets/fate_check.dart' 
    show FateCheckResult, FateCheckOutcome, FateCheckOutcomeDisplay, 
         SpecialTrigger, SpecialTriggerDisplay;

export '../../presets/expectation_check.dart' 
    show ExpectationCheckResult, ExpectationOutcome, ExpectationOutcomeDisplay;

export '../../presets/random_event.dart' 
    show RandomEventResult, RandomEventFocusResult, IdeaResult, 
         SingleTableResult, IdeaCategory;

export '../../presets/next_scene.dart' 
    show NextSceneResult, NextSceneWithFollowUpResult, FocusResult,
         SceneType, SceneTypeDisplay;

export '../../presets/discover_meaning.dart' 
    show DiscoverMeaningResult;

export '../../presets/interrupt_plot_point.dart' 
    show InterruptPlotPointResult;

// =============================================================================
// EMBEDDED HELPER CLASSES - For future use with consolidated results
// =============================================================================

/// Lightweight embedded random event data for use in composite results.
/// Used when a random event is embedded in another result (e.g., FateCheck).
class EmbeddedRandomEvent {
  final String focus;
  final int focusRoll;
  final String modifier;
  final int modifierRoll;
  final String idea;
  final int ideaRoll;
  
  const EmbeddedRandomEvent({
    required this.focus,
    required this.focusRoll,
    required this.modifier,
    required this.modifierRoll,
    required this.idea,
    required this.ideaRoll,
  });
  
  String get phrase => '$modifier $idea';
  String get full => '$focus: $modifier $idea';
  
  Map<String, dynamic> toJson() => {
    'focus': focus,
    'focusRoll': focusRoll,
    'modifier': modifier,
    'modifierRoll': modifierRoll,
    'idea': idea,
    'ideaRoll': ideaRoll,
  };
  
  factory EmbeddedRandomEvent.fromJson(Map<String, dynamic> json) {
    return EmbeddedRandomEvent(
      focus: json['focus'] as String,
      focusRoll: json['focusRoll'] as int? ?? 0,
      modifier: json['modifier'] as String,
      modifierRoll: json['modifierRoll'] as int? ?? 0,
      idea: json['idea'] as String,
      ideaRoll: json['ideaRoll'] as int? ?? 0,
    );
  }
}

/// Lightweight embedded meaning data for composite results.
class EmbeddedMeaning {
  final String adjective;
  final int adjectiveRoll;
  final String noun;
  final int nounRoll;
  
  const EmbeddedMeaning({
    required this.adjective,
    required this.adjectiveRoll,
    required this.noun,
    required this.nounRoll,
  });
  
  String get meaning => '$adjective $noun';
  
  Map<String, dynamic> toJson() => {
    'adjective': adjective,
    'adjectiveRoll': adjectiveRoll,
    'noun': noun,
    'nounRoll': nounRoll,
  };
  
  factory EmbeddedMeaning.fromJson(Map<String, dynamic> json) {
    return EmbeddedMeaning(
      adjective: json['adjective'] as String,
      adjectiveRoll: json['adjectiveRoll'] as int? ?? 0,
      noun: json['noun'] as String,
      nounRoll: json['nounRoll'] as int? ?? 0,
    );
  }
}
