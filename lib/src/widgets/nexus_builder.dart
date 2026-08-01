import 'package:flutter/widgets.dart';
import '../core/nexus_state.dart';

/// A widget that automatically builds itself based on [NexusState] dependencies.
/// Any [NexusState] instances read within [builder] are dynamically detected
/// and subscribed to. When any of these states update, the widget automatically rebuilds.
class NexusBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;

  const NexusBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<NexusBuilder> createState() => _NexusBuilderState();
}

class _NexusBuilderState extends State<NexusBuilder> {
  final Set<NexusState> _observedStates = {};

  @override
  void dispose() {
    _unsubscribeFromAll();
    super.dispose();
  }

  void _unsubscribeFromAll() {
    for (final state in _observedStates) {
      state.removeListener(_onStateUpdated);
    }
    _observedStates.clear();
  }

  void _onStateUpdated(dynamic _) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<NexusState> newStates = {};

    // Use our custom tracking context to capture any read NexusState instances
    final trackedBuilderContext = NexusBuilderContext((state) {
      newStates.add(state);
    });

    final Widget result = NexusBuilderContext.track(trackedBuilderContext, () {
      return widget.builder(context);
    });

    // Unsubscribe from any previously observed states that are no longer used
    final noLongerObserved = _observedStates.difference(newStates);
    for (final state in noLongerObserved) {
      state.removeListener(_onStateUpdated);
    }

    // Subscribe to newly observed states
    final newlyObserved = newStates.difference(_observedStates);
    for (final state in newlyObserved) {
      state.addListener(_onStateUpdated);
    }

    // Update local tracked state set
    _observedStates.clear();
    _observedStates.addAll(newStates);

    return result;
  }
}
