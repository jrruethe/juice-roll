import 'package:flutter_test/flutter_test.dart';
import 'package:juice_roll/ui/home_state.dart';
import 'package:juice_roll/models/roll_result.dart';

void main() {
  group('HomeState', () {
    test('default state has expected initial values', () {
      const state = HomeState();
      
      expect(state.history, isEmpty);
      expect(state.currentSession, isNull);
      expect(state.sessions, isEmpty);
      expect(state.isLoading, isTrue);
      expect(state.isDungeonEntering, isTrue);
      expect(state.isDungeonTwoPassMode, isFalse);
      expect(state.twoPassHasFirstDoubles, isFalse);
    });

    test('copyWith creates new state with updated fields', () {
      const state = HomeState();
      
      final newState = state.copyWith(
        isLoading: false,
        isDungeonEntering: false,
        isDungeonTwoPassMode: true,
      );
      
      expect(newState.isLoading, isFalse);
      expect(newState.isDungeonEntering, isFalse);
      expect(newState.isDungeonTwoPassMode, isTrue);
      // Unchanged fields should remain
      expect(newState.twoPassHasFirstDoubles, isFalse);
    });

    test('copyWith with history creates independent list', () {
      const state = HomeState();
      final history = [
        RollResult(
          type: RollType.fateCheck,
          description: 'Test',
          diceResults: [1],
          total: 1,
        ),
      ];
      
      final newState = state.copyWith(history: history);
      
      expect(newState.history.length, 1);
      expect(newState.history.first.description, 'Test');
    });

    test('equality works correctly', () {
      const state1 = HomeState(isLoading: false);
      const state2 = HomeState(isLoading: false);
      const state3 = HomeState(isLoading: true);
      
      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('HomeStateNotifier', () {
    test('creates with default presets', () {
      final notifier = HomeStateNotifier();
      
      expect(notifier.rollEngine, isNotNull);
      expect(notifier.fateCheck, isNotNull);
      expect(notifier.discoverMeaning, isNotNull);
      expect(notifier.wilderness, isNotNull);
      expect(notifier.dungeonGenerator, isNotNull);
      
      notifier.dispose();
    });

    test('initial state is loading', () {
      final notifier = HomeStateNotifier();
      
      expect(notifier.state.isLoading, isTrue);
      expect(notifier.state.history, isEmpty);
      
      notifier.dispose();
    });

    test('addToHistory adds result to beginning', () {
      final notifier = HomeStateNotifier();
      
      final result1 = RollResult(
        type: RollType.fateCheck,
        description: 'First',
        diceResults: [1],
        total: 1,
      );
      final result2 = RollResult(
        type: RollType.fateCheck,
        description: 'Second',
        diceResults: [2],
        total: 2,
      );
      
      notifier.addToHistory(result1);
      notifier.addToHistory(result2);
      
      expect(notifier.state.history.length, 2);
      expect(notifier.state.history[0].description, 'Second');
      expect(notifier.state.history[1].description, 'First');
      
      notifier.dispose();
    });

    test('clearHistory removes all results', () {
      final notifier = HomeStateNotifier();
      
      notifier.addToHistory(RollResult(
        type: RollType.fateCheck,
        description: 'Test',
        diceResults: [1],
        total: 1,
      ));
      
      expect(notifier.state.history.length, 1);
      
      notifier.clearHistory();
      
      expect(notifier.state.history, isEmpty);
      
      notifier.dispose();
    });

    test('setDungeonPhase updates state', () {
      final notifier = HomeStateNotifier();
      
      expect(notifier.state.isDungeonEntering, isTrue);
      
      notifier.setDungeonPhase(false);
      
      expect(notifier.state.isDungeonEntering, isFalse);
      
      notifier.dispose();
    });

    test('setDungeonTwoPassMode updates state', () {
      final notifier = HomeStateNotifier();
      
      expect(notifier.state.isDungeonTwoPassMode, isFalse);
      
      notifier.setDungeonTwoPassMode(true);
      
      expect(notifier.state.isDungeonTwoPassMode, isTrue);
      
      notifier.dispose();
    });

    test('setTwoPassFirstDoubles updates state', () {
      final notifier = HomeStateNotifier();
      
      expect(notifier.state.twoPassHasFirstDoubles, isFalse);
      
      notifier.setTwoPassFirstDoubles(true);
      
      expect(notifier.state.twoPassHasFirstDoubles, isTrue);
      
      notifier.dispose();
    });

    test('notifies listeners on state change', () {
      final notifier = HomeStateNotifier();
      var notificationCount = 0;
      
      notifier.addListener(() {
        notificationCount++;
      });
      
      notifier.setDungeonPhase(false);
      expect(notificationCount, 1);
      
      notifier.addToHistory(RollResult(
        type: RollType.fateCheck,
        description: 'Test',
        diceResults: [1],
        total: 1,
      ));
      expect(notificationCount, 2);
      
      notifier.clearHistory();
      expect(notificationCount, 3);
      
      notifier.dispose();
    });

    test('rollDiscoverMeaning adds result to history', () {
      final notifier = HomeStateNotifier();
      
      expect(notifier.state.history, isEmpty);
      
      notifier.rollDiscoverMeaning();
      
      expect(notifier.state.history.length, 1);
      expect(notifier.state.history.first.type, RollType.discoverMeaning);
      
      notifier.dispose();
    });

    test('rollInterruptPlotPoint adds result to history', () {
      final notifier = HomeStateNotifier();
      
      notifier.rollInterruptPlotPoint();
      
      expect(notifier.state.history.length, 1);
      expect(notifier.state.history.first.type, RollType.interruptPlotPoint);
      
      notifier.dispose();
    });

    test('rollQuest adds result to history', () {
      final notifier = HomeStateNotifier();
      
      notifier.rollQuest();
      
      expect(notifier.state.history.length, 1);
      expect(notifier.state.history.first.type, RollType.quest);
      
      notifier.dispose();
    });

    test('rollScale adds result to history', () {
      final notifier = HomeStateNotifier();
      
      notifier.rollScale();
      
      expect(notifier.state.history.length, 1);
      expect(notifier.state.history.first.type, RollType.scale);
      
      notifier.dispose();
    });

    test('history is limited to 100 items in memory', () {
      final notifier = HomeStateNotifier();
      
      // Add 105 items
      for (var i = 0; i < 105; i++) {
        notifier.addToHistory(RollResult(
          type: RollType.fateCheck,
          description: 'Item $i',
          diceResults: [i],
          total: i,
        ));
      }
      
      // Should be capped at 100
      expect(notifier.state.history.length, 100);
      // Most recent should be first
      expect(notifier.state.history.first.description, 'Item 104');
      
      notifier.dispose();
    });

    test('setWildernessPosition adds result to history', () {
      final notifier = HomeStateNotifier();
      
      notifier.setWildernessPosition(5, 5);
      
      expect(notifier.state.history.length, 1);
      expect(notifier.state.history.first.description, 'Set Wilderness Position');
      
      // Verify wilderness state is updated in HomeState
      expect(notifier.wildernessState, isNotNull);
      expect(notifier.wildernessState!.environmentRow, 5);
      
      notifier.dispose();
    });
  });
}
