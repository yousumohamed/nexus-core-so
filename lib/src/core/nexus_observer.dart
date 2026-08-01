import 'nexus_state.dart';

/// Abstract class defining state lifecycle and action hooks.
abstract class NexusObserver {
  /// The global active observer instance. Defaults to a silent empty observer.
  static NexusObserver instance = _DefaultNexusObserver();

  /// Called whenever a [NexusState] has its value successfully modified.
  void onStateChanged<T>(NexusState<T> state, T oldValue, T newValue);

  /// Called before a sync or async [NexusAction] starts execution.
  void onActionStarted(String name, Map<String, dynamic>? payload);

  /// Called after a sync or async [NexusAction] has finished executing successfully.
  void onActionEnded(String name, dynamic result);

  /// Called if a sync or async [NexusAction] throws an error during execution.
  void onActionError(String name, Object error, StackTrace stackTrace);
}

class _DefaultNexusObserver implements NexusObserver {
  @override
  void onStateChanged<T>(NexusState<T> state, T oldValue, T newValue) {}

  @override
  void onActionStarted(String name, Map<String, dynamic>? payload) {}

  @override
  void onActionEnded(String name, dynamic result) {}

  @override
  void onActionError(String name, Object error, StackTrace stackTrace) {}
}
