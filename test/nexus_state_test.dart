import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_core_so/nexus_core_so.dart';

class TestObserver implements NexusObserver {
  final List<String> logs = [];

  @override
  void onStateChanged<T>(NexusState<T> state, T oldValue, T newValue) {
    logs.add('State: ${state.name} from $oldValue to $newValue');
  }

  @override
  void onActionStarted(String name, Map<String, dynamic>? payload) {
    logs.add('ActionStarted: $name');
  }

  @override
  void onActionEnded(String name, dynamic result) {
    logs.add('ActionEnded: $name');
  }

  @override
  void onActionError(String name, Object error, StackTrace stackTrace) {
    logs.add('ActionError: $name');
  }
}

void main() {
  group('NexusState Tests', () {
    test('Initial value matches and updating updates value', () {
      final state = NexusState<int>(10, name: 'score');
      expect(state.value, 10);
      expect(state.name, 'score');

      state.value = 20;
      expect(state.value, 20);
    });

    test('Listeners get invoked on update and can be unsubscribed', () {
      final state = NexusState<String>('hello');
      final List<String> values = [];

      void listener(String val) => values.add(val);
      state.addListener(listener);

      state.value = 'world';
      state.value = 'nexus';

      state.removeListener(listener);
      state.value = 'ignored';

      expect(values, ['world', 'nexus']);
    });

    test('Stream emits updates', () async {
      final state = NexusState<int>(100);
      final List<int> values = [];

      final subscription = state.stream.listen((val) => values.add(val));

      state.value = 200;
      state.value = 300;

      // Allow microtask queue to empty
      await Future.delayed(Duration.zero);

      expect(values, [200, 300]);
      await subscription.cancel();
    });

    test('Observer intercepts state transitions and actions', () async {
      final testObserver = TestObserver();
      NexusObserver.instance = testObserver;

      final state = NexusState<int>(0, name: 'test_state');
      final action = NexusAction('Increment');

      action.run(() {
        state.value = 1;
      });

      expect(testObserver.logs, [
        'ActionStarted: Increment',
        'State: test_state from 0 to 1',
        'ActionEnded: Increment',
      ]);
    });

    test('Observer intercepts async actions and reports errors', () async {
      final testObserver = TestObserver();
      NexusObserver.instance = testObserver;

      final action = NexusAction('AsyncIncrement');

      try {
        await action.runAsync(() async {
          throw Exception('Async Fail');
        });
      } catch (_) {}

      expect(testObserver.logs, [
        'ActionStarted: AsyncIncrement',
        'ActionError: AsyncIncrement',
      ]);
    });
  });
}
