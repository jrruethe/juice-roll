import 'roll_engine.dart';
import '../presets/fate_check.dart';
import '../presets/expectation_check.dart';
import '../presets/next_scene.dart';
import '../presets/random_event.dart';
import '../presets/discover_meaning.dart';
import '../presets/npc_action.dart';
import '../presets/dialog_generator.dart';
import '../presets/pay_the_price.dart';
import '../presets/quest.dart';
import '../presets/interrupt_plot_point.dart';
import '../presets/settlement.dart';
import '../presets/object_treasure.dart';
import '../presets/challenge.dart';
import '../presets/details.dart';
import '../presets/immersion.dart';
import '../presets/name_generator.dart';
import '../presets/dungeon_generator.dart';
import '../presets/scale.dart';
import '../presets/wilderness.dart';
import '../presets/extended_npc_conversation.dart';
import '../presets/abstract_icons.dart';

/// Registry that lazily instantiates and caches all oracle presets.
/// 
/// This consolidates the 22+ preset dependencies that were previously
/// injected individually into HomeStateNotifier, making the code:
/// - **Easier to test**: Mock a single registry instead of 22 presets
/// - **Easier to extend**: Add new presets in one place
/// - **Lazily initialized**: Presets are created only when first accessed
/// 
/// Usage:
/// ```dart
/// final registry = PresetRegistry();
/// final result = registry.fateCheck.check();
/// ```
class PresetRegistry {
  /// The shared roll engine used by all presets.
  final RollEngine rollEngine;

  // Cached preset instances (lazily initialized)
  FateCheck? _fateCheck;
  ExpectationCheck? _expectationCheck;
  NextScene? _nextScene;
  RandomEvent? _randomEvent;
  DiscoverMeaning? _discoverMeaning;
  InterruptPlotPoint? _interruptPlotPoint;
  NpcAction? _npcAction;
  DialogGenerator? _dialogGenerator;
  NameGenerator? _nameGenerator;
  Settlement? _settlement;
  ObjectTreasure? _objectTreasure;
  Quest? _quest;
  DungeonGenerator? _dungeonGenerator;
  Wilderness? _wilderness;
  ExtendedNpcConversation? _extendedNpcConversation;
  Challenge? _challenge;
  PayThePrice? _payThePrice;
  Scale? _scale;
  Details? _details;
  Immersion? _immersion;
  AbstractIcons? _abstractIcons;

  /// Creates a PresetRegistry with optional dependency injection for testing.
  /// 
  /// If [rollEngine] is not provided, a new one will be created.
  /// Individual presets can be overridden for testing purposes.
  PresetRegistry({
    RollEngine? rollEngine,
    FateCheck? fateCheck,
    ExpectationCheck? expectationCheck,
    NextScene? nextScene,
    RandomEvent? randomEvent,
    DiscoverMeaning? discoverMeaning,
    InterruptPlotPoint? interruptPlotPoint,
    NpcAction? npcAction,
    DialogGenerator? dialogGenerator,
    NameGenerator? nameGenerator,
    Settlement? settlement,
    ObjectTreasure? objectTreasure,
    Quest? quest,
    DungeonGenerator? dungeonGenerator,
    Wilderness? wilderness,
    ExtendedNpcConversation? extendedNpcConversation,
    Challenge? challenge,
    PayThePrice? payThePrice,
    Scale? scale,
    Details? details,
    Immersion? immersion,
    AbstractIcons? abstractIcons,
  })  : rollEngine = rollEngine ?? RollEngine(),
        _fateCheck = fateCheck,
        _expectationCheck = expectationCheck,
        _nextScene = nextScene,
        _randomEvent = randomEvent,
        _discoverMeaning = discoverMeaning,
        _interruptPlotPoint = interruptPlotPoint,
        _npcAction = npcAction,
        _dialogGenerator = dialogGenerator,
        _nameGenerator = nameGenerator,
        _settlement = settlement,
        _objectTreasure = objectTreasure,
        _quest = quest,
        _dungeonGenerator = dungeonGenerator,
        _wilderness = wilderness,
        _extendedNpcConversation = extendedNpcConversation,
        _challenge = challenge,
        _payThePrice = payThePrice,
        _scale = scale,
        _details = details,
        _immersion = immersion,
        _abstractIcons = abstractIcons;

  // ========== Core Oracle Presets ==========

  /// Fate Check: Yes/No questions with 2dF + 1d6 Intensity
  FateCheck get fateCheck => _fateCheck ??= FateCheck(rollEngine);

  /// Expectation Check: Test assumptions about the world
  ExpectationCheck get expectationCheck => 
      _expectationCheck ??= ExpectationCheck(rollEngine);

  /// Next Scene: Determine what happens next
  NextScene get nextScene => _nextScene ??= NextScene(rollEngine);

  /// Random Event: Generate unexpected events
  RandomEvent get randomEvent => _randomEvent ??= RandomEvent(rollEngine);

  /// Discover Meaning: Two-word prompts for interpretation
  DiscoverMeaning get discoverMeaning => 
      _discoverMeaning ??= DiscoverMeaning(rollEngine);

  /// Interrupt Plot Point: Story interruptions
  InterruptPlotPoint get interruptPlotPoint => 
      _interruptPlotPoint ??= InterruptPlotPoint(rollEngine);

  // ========== Character Presets ==========

  /// NPC Action: Determine what NPCs do
  NpcAction get npcAction => _npcAction ??= NpcAction(rollEngine);

  /// Dialog Generator: Generate NPC dialog
  DialogGenerator get dialogGenerator => 
      _dialogGenerator ??= DialogGenerator(rollEngine);

  /// Name Generator: Generate character and place names
  NameGenerator get nameGenerator => _nameGenerator ??= NameGenerator(rollEngine);

  /// Extended NPC Conversation: Deep dialog system
  ExtendedNpcConversation get extendedNpcConversation => 
      _extendedNpcConversation ??= ExtendedNpcConversation(rollEngine);

  // ========== World Building Presets ==========

  /// Settlement: Generate towns and cities
  Settlement get settlement => _settlement ??= Settlement(rollEngine);

  /// Object Treasure: Generate loot and items
  ObjectTreasure get objectTreasure => _objectTreasure ??= ObjectTreasure(rollEngine);

  /// Quest: Generate adventure hooks
  Quest get quest => _quest ??= Quest(rollEngine);

  /// Dungeon Generator: Generate dungeon areas
  DungeonGenerator get dungeonGenerator => 
      _dungeonGenerator ??= DungeonGenerator(rollEngine);

  /// Wilderness: Exploration and encounters
  Wilderness get wilderness => _wilderness ??= Wilderness(rollEngine);

  // ========== Challenge Presets ==========

  /// Challenge: Generate obstacles and DCs
  Challenge get challenge => _challenge ??= Challenge(rollEngine);

  /// Pay the Price: Consequences for failure
  PayThePrice get payThePrice => _payThePrice ??= PayThePrice(rollEngine);

  /// Scale: Determine magnitude/scope
  Scale get scale => _scale ??= Scale(rollEngine);

  // ========== Flavor Presets ==========

  /// Details: Generate descriptive properties
  Details get details => _details ??= Details(rollEngine);

  /// Immersion: Sensory and emotional details
  Immersion get immersion => _immersion ??= Immersion(rollEngine);

  /// Abstract Icons: Visual oracle prompts
  AbstractIcons get abstractIcons => _abstractIcons ??= AbstractIcons(rollEngine);
}
