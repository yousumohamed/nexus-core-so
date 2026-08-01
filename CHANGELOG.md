# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-07-20

### Added
- Complete rewrite of "nexus-core-so" state management core.
- Introduced `NexusState<T>` with broadcast stream and dynamic dynamic context evaluation hook `NexusBuilderContext`.
- Introduced `NexusObserver` with full telemetry hooks for states and synchronous/asynchronous actions.
- Introduced `NexusAction` supporting transaction tracking execution.
- Added standard `NexusBuilder` Flutter stateful widget with dynamic auto-unsubscription logic.
- Provided standard development tracking middleware `NexusDevToolsObserver`.
- Fully written tests asserting state reactivity, listener removal, async updates, and widget lifecycle cleanup.
- Wrote full-featured Counter mobile app usage example in `example/main.dart`.
