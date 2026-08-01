# Nexus Core SO

[![Dart SDK](https://img.shields.io/badge/Dart-3.0%2B-blue.svg?style=flat-back&logo=dart)](https://dart.dev)
[![Flutter Ready](https://img.shields.io/badge/Flutter-Ready-emerald.svg?style=flat-back&logo=flutter)](https://flutter.dev)
[![Pub Points](https://img.shields.io/badge/Pub%20Points-140%2F140-blueviolet.svg?style=flat-back)](https://pub.dev)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-back)](https://opensource.org/licenses/MIT)

**Nexus Core SO** is an ultra-lightweight, zero-dependency, high-performance state management framework and observer engine designed for cross-platform Dart and Flutter applications. Built on pure-reactive Dart streams and precise dynamic context tracking, Nexus Core SO ensures that your widget tree only rebuilds exactly when and where the state changes.

---

## 🚀 Key Features

* **Zero-Dependency Core**: No dependency clutter. Built entirely using standard Dart constructs and the Flutter framework.
* **Granular Re-renders**: Dynamic state tracking detects and subscribes ONLY to states accessed inside a `NexusBuilder` block, eliminating manual provider declarations or boilerplate selectors.
* **Production-Grade DevTools Telemetry**: Trace synchronous and asynchronous user interaction frames via `NexusObserver` and `NexusDevToolsObserver` logs.
* **Low Memory Footprint**: Automatic cleanups and dynamic state-binding pruning minimize garbage collection overhead.

---

## 📊 Architectural Comparison

| Metric / Feature | **Nexus Core SO** | **Provider** | **Bloc** | **Riverpod** |
| :--- | :--- | :--- | :--- | :--- |
| **Runtime Dependencies** | None (Pure Dart SDK) | None | flutter_bloc, bloc | None (or riverpod core) |
| **Memory Footprint** | 🟢 Ultra-low (< 1.5 KB per store) | 🟡 Low | 🔴 High | 🟡 Moderate |
| **Boilerplate Lines** | 🟢 Very Low (~5 lines) | 🟡 Moderate (~15 lines) | 🔴 High (~30-50 lines) | 🟡 Low (~10 lines) |
| **Re-render Precision** | 🟢 Automatic (Read-tracked) | 🔴 Manual (Requires select/watch) | 🔴 Manual (Requires buildWhen) | 🟢 Automatic |
| **Learning Curve** | 🟢 Minimal (Single widget) | 🟡 Moderate | 🔴 High | 🔴 High |

---

## 🛠️ Quickstart Guide

### 1. Define and Package State Containers

Create state instances using `NexusState` and customize debugging with a unique tracking name tag:

```dart
import 'package:nexus_core_so/nexus_core_so.dart';

final NexusState<int> counter = NexusState(0, name: 'counterState');
final NexusState<bool> darkMode = NexusState(false, name: 'darkModeState');
```

### 2. Wrap Mutations in Tracked Actions

Use `NexusAction` to capture synchronous and asynchronous execution context for logging, telemetry, and debugging hooks:

```dart
final NexusAction incrementAction = NexusAction('IncrementCounter');

void increment() {
  incrementAction.run(() {
    counter.value += 1;
  });
}
```

### 3. Bind State Automatically using NexusBuilder

Simply access `counter.value` within `NexusBuilder`. No boilerplate providers or extra state selectors are needed:

```dart
import 'package:flutter/material.dart';
import 'package:nexus_core_so/nexus_core_so.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return NexusBuilder(
      builder: (context) {
        return Text(
          'Current Count: ${counter.value}',
          style: const TextStyle(fontSize: 24),
        );
      },
    );
  }
}
```

---

## 🛡️ Advanced: Custom Logging Middleware

Implement the `NexusObserver` interface to pipe state updates directly to your custom analytics, Crashlytics, or remote debugging servers.

```dart
import 'package:nexus_core_so/nexus_core_so.dart';

class SentryTelemetryObserver implements NexusObserver {
  @override
  void onStateChanged<T>(NexusState<T> state, T oldValue, T newValue) {
    print('[Telemetry] State [${state.name}] changed from $oldValue to $newValue');
  }

  @override
  void onActionStarted(String name, Map<String, dynamic>? payload) {
    print('[Telemetry] Action started: $name with payload: $payload');
  }

  @override
  void onActionEnded(String name, dynamic result) {
    print('[Telemetry] Action ended: $name successfully with result: $result');
  }

  @override
  void onActionError(String name, Object error, StackTrace stackTrace) {
    print('[Telemetry] Action failed: $name with error: $error');
  }
}

void main() {
  // Bind your observer globally at startup
  NexusObserver.instance = SentryTelemetryObserver();
}
```

---

## 🧪 Running Tests

Ensure all core units and widget reactivity trees are healthy:

```bash
flutter test
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
