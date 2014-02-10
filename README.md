LRLDataService
==============
An sample project for Sydney CocoaHeads to show some best practice when consuming data from web services.

This App aims to show a few things:

- A Common Interface for obtaining data from local and remote sources (```LRLDataProvider```)
- Basing all service calls on configuration passed down, no global configuration. All services can react to a single change of the root configuration URL.
- Using object equality and ```distinctUntilChanged``` to avoid unnecessary activity in consumers. Consumers only need concern themselves when new data is presented to them.
- Lightweight services that only concern themselves with a small external service. Services take all their functional dependencies so that they are significantly easier to test.
- Composing Services on top of each other and combining the results. The fact that there are multiple services being called is not exposed to service consumers (e.g. the UI).
- Lightweight model objects that are easily converted to and from JSON. Keeping these object immutable so they can be bounced across threads.
- Immutable model objects that are updated with a block. A powerful pattern for thread-safety and coherence of values.
