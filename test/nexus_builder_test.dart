import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_core_so/nexus_core_so.dart';

void main() {
  group('NexusBuilder Tests', () {
    testWidgets('NexusBuilder rebuilds when State updates', (WidgetTester tester) async {
      final counter = NexusState<int>(0, name: 'counter');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NexusBuilder(
              builder: (context) {
                return Text('Value: ${counter.value}');
              },
            ),
          ),
        ),
      );

      expect(find.text('Value: 0'), findsOneWidget);

      counter.value = 10;
      await tester.pump();

      expect(find.text('Value: 10'), findsOneWidget);
    });

    testWidgets('NexusBuilder updates dynamic bindings correctly on conditional paths', (WidgetTester tester) async {
      final condition = NexusState<bool>(false, name: 'condition');
      final stateA = NexusState<String>('A', name: 'stateA');
      final stateB = NexusState<String>('B', name: 'stateB');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NexusBuilder(
              builder: (context) {
                if (condition.value) {
                  return Text('Active: ${stateB.value}');
                } else {
                  return Text('Active: ${stateA.value}');
                }
              },
            ),
          ),
        ),
      );

      expect(find.text('Active: A'), findsOneWidget);

      // Mutating stateB shouldn't trigger rebuilds since condition is false (stateB isn't registered)
      stateB.value = 'B2';
      await tester.pump();
      expect(find.text('Active: A'), findsOneWidget);

      // Mutating stateA should trigger a rebuild
      stateA.value = 'A2';
      await tester.pump();
      expect(find.text('Active: A2'), findsOneWidget);

      // Toggle condition to true
      condition.value = true;
      await tester.pump();
      expect(find.text('Active: B2'), findsOneWidget);

      // Mutating stateA now should NOT trigger a rebuild (it's unsubscribed)
      stateA.value = 'A3';
      await tester.pump();
      expect(find.text('Active: B2'), findsOneWidget);

      // Mutating stateB now SHOULD trigger a rebuild
      stateB.value = 'B3';
      await tester.pump();
      expect(find.text('Active: B3'), findsOneWidget);
    });
  });
}
