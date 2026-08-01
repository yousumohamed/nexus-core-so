import 'package:flutter/material.dart';
import 'package:nexus_core_so/nexus_core_so.dart';

void main() {
  // Set up logging observer
  NexusObserver.instance = const NexusDevToolsObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus Core SO Example',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  // Create state containers
  final NexusState<int> _counter = NexusState(0, name: 'counter');
  final NexusState<bool> _isDark = NexusState(false, name: 'darkMode');

  // Actions for wrapping mutation blocks
  late final NexusAction _incrementAction = NexusAction('IncrementCounter');
  late final NexusAction _decrementAction = NexusAction('DecrementCounter');
  late final NexusAction _toggleThemeAction = NexusAction('ToggleTheme');
  late final NexusAction _asyncIncrementAction = NexusAction('AsyncIncrement');

  void _increment() {
    _incrementAction.run(() {
      _counter.value += 1;
    }, payload: {'current': _counter.value});
  }

  void _decrement() {
    _decrementAction.run(() {
      if (_counter.value > 0) {
        _counter.value -= 1;
      }
    }, payload: {'current': _counter.value});
  }

  void _toggleTheme() {
    _toggleThemeAction.run(() {
      _isDark.value = !_isDark.value;
    });
  }

  Future<void> _asyncIncrement() async {
    await _asyncIncrementAction.runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      _counter.value += 5;
    });
  }

  @override
  void dispose() {
    _counter.dispose();
    _isDark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NexusBuilder(
      builder: (context) {
        final darkMode = _isDark.value;
        return Scaffold(
          backgroundColor: darkMode ? Colors.grey[900] : Colors.grey[50],
          appBar: AppBar(
            title: const Text('Nexus Core SO Counter'),
            backgroundColor: darkMode ? Colors.grey[800] : Colors.indigo,
            actions: [
              IconButton(
                icon: Icon(darkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: _toggleTheme,
              )
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Counter Value:',
                  style: TextStyle(
                    fontSize: 18,
                    color: darkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                // Another nested NexusBuilder, showing modular reactivity
                NexusBuilder(
                  builder: (context) {
                    return Text(
                      '${_counter.value}',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: darkMode ? Colors.indigo[300] : Colors.indigo,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _decrement,
                      icon: const Icon(Icons.remove),
                      label: const Text('Decrement'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton.icon(
                      onPressed: _increment,
                      icon: const Icon(Icons.add),
                      label: const Text('Increment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _asyncIncrement,
                  icon: const Icon(Icons.bolt),
                  label: const Text('Async Increment (+5)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
