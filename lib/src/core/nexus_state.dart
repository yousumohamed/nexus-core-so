import 'dart:async';
import 'nexus_observer.dart';

/// A tracking context for automatic dependency detection in NexusBuilder.
class NexusBuilderContext {
  static NexusBuilderContext? current;

  final void Function(NexusState state) onStateRead;

  NexusBuilderContext(this.onStateRead);

  /// Executes [callback] while marking this context as active.
  /// Any [NexusState] evaluated during [callback] will be registered.
  static R track<R>(NexusBuilderContext context, R Function() callback) {
    final previous = current;
    current = context;
    try {
      return callback();
    } finally {
      current = previous;
    }
  }
}

/// A generic reactive state container that supports dynamic dependency tracking,
/// broadcast stream notifications, and manual listener management.
class NexusState<T> {
  T _value;
  final String? name;
  final Set<void Function(T)> _listeners = {};
  StreamController<T>? _controller;

  NexusState(this._value, {this.name});

  /// Retrieves the current value and registers this state container in the active [NexusBuilderContext].
  T get value {
    if (NexusBuilderContext.current != null) {
      NexusBuilderContext.current!.onStateRead(this);
    }
    return _value;
  }

  /// Sets the new value and updates all subscribers and observers if the state has changed.
  set value(T newValue) {
    update(newValue);
  }

  /// Updates the value and dispatches change events to custom listeners,
  /// the state's stream, and the global [NexusObserver].
  void update(T newValue) {
    if (_value == newValue) return;
    final oldValue = _value;
    _value = newValue;

    // Dispatch to stream
    if (_controller != null && !_controller!.isClosed) {
      _controller!.add(newValue);
    }

    // Dispatch to local listeners
    final listenersCopy = List<void Function(T)>.from(_listeners);
    for (final listener in listenersCopy) {
      try {
        listener(newValue);
      } catch (_) {
        // Suppress listener callback errors to avoid disrupting state flow
      }
    }

    // Notify global observer
    NexusObserver.instance.onStateChanged(this, oldValue, newValue);
  }

  /// Adds a custom state listener.
  void addListener(void Function(T) listener) {
    _listeners.add(listener);
  }

  /// Removes a custom state listener.
  void removeListener(void Function(T) listener) {
    _listeners.remove(listener);
  }

  /// A broadcast stream of value updates.
  Stream<T> get stream {
    _controller ??= StreamController<T>.broadcast();
    return _controller!.stream;
  }

  /// Disposes of the state stream and clears all listeners.
  void dispose() {
    _listeners.clear();
    _controller?.close();
  }

  @override
  String toString() => 'NexusState<$T>(${name ?? "unnamed"}, value: $_value)';
}
