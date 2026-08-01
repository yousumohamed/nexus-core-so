import 'dart:async';
import 'nexus_observer.dart';

/// A class that wraps synchronous or asynchronous callbacks to trace operational execution.
class NexusAction {
  final String name;

  NexusAction(this.name);

  /// Executes a synchronous operation, reporting state changes and lifecycle events to [NexusObserver].
  R run<R>(R Function() action, {Map<String, dynamic>? payload}) {
    NexusObserver.instance.onActionStarted(name, payload);
    try {
      final result = action();
      NexusObserver.instance.onActionEnded(name, result);
      return result;
    } catch (error, stackTrace) {
      NexusObserver.instance.onActionError(name, error, stackTrace);
      rethrow;
    }
  }

  /// Executes an asynchronous operation, reporting state changes and lifecycle events to [NexusObserver].
  Future<R> runAsync<R>(Future<R> Function() action, {Map<String, dynamic>? payload}) async {
    NexusObserver.instance.onActionStarted(name, payload);
    try {
      final result = await action();
      NexusObserver.instance.onActionEnded(name, result);
      return result;
    } catch (error, stackTrace) {
      NexusObserver.instance.onActionError(name, error, stackTrace);
      rethrow;
    }
  }
}
