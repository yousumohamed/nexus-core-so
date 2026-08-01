import 'dart:developer' as developer;
import '../core/nexus_observer.dart';
import '../core/nexus_state.dart';

/// A robust [NexusObserver] implementation that logs state transitions and
/// action payloads to the Dart developer tools console using the standard log routing.
class NexusDevToolsObserver implements NexusObserver {
  final bool enableStateLogs;
  final bool enableActionLogs;

  const NexusDevToolsObserver({
    this.enableStateLogs = true,
    this.enableActionLogs = true,
  });

  @override
  void onStateChanged<T>(NexusState<T> state, T oldValue, T newValue) {
    if (!enableStateLogs) return;
    developer.log(
      'State Changed | [${state.name ?? "unnamed"}] <$T> : $oldValue ➔ $newValue',
      name: 'NexusCore',
    );
  }

  @override
  void onActionStarted(String name, Map<String, dynamic>? payload) {
    if (!enableActionLogs) return;
    developer.log(
      'Action Started | "$name" with payload: ${payload ?? "{}"}',
      name: 'NexusCore',
    );
  }

  @override
  void onActionEnded(String name, dynamic result) {
    if (!enableActionLogs) return;
    developer.log(
      'Action Ended   | "$name" returned: $result',
      name: 'NexusCore',
    );
  }

  @override
  void onActionError(String name, Object error, StackTrace stackTrace) {
    if (!enableActionLogs) return;
    developer.log(
      'Action Error   | "$name" failed with error: $error',
      name: 'NexusCore',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
