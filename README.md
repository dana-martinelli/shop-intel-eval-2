# ShoppingIntel Phase 1 export

This repository contains a production-shaped `feature_feed` export for the
Shopping Intelligence subsection shown at the top of search results. The UI is
original SwiftUI code derived from the Phase 1 Landingpad preview and its three
approved image assets. The reference PR and `reddit-ios` checkout were used
only to verify module organization and API shape.

## Structure

1. `Modules/ShoppingIntel/ShoppingIntel/Sources/Public` contains the screen
   factory boundary and DI kind.
2. `Sources/Internal/Feed` contains the fixture payloads, six data-bearing
   `ModernFeedElement` types, six dedicated converters, the screen-specific
   converter provider, `ShoppingIntelAsyncStrategy`, and `FeedStrategy`.
3. `Sources/Internal/UI` contains the same per-unit
   `HostedListItemRepresentable` SwiftUI views used by production conversion,
   snapshots, accessibility snapshots, and the validation host. Interactive
   units are backed by `CoreStackFeature`.
4. `Resources/shopping.json` is the only ordered content fixture. The async
   strategy decodes it and emits elements without screen-level knowledge of
   the data source.
5. `ValidationHost` renders the deterministic per-unit surface. The public
   production screen itself is created through `FeedFactory`.

## Review order

1. Slice 1, feed contract: public boundary, JSON schema, ordered async strategy,
   feed elements, omission/insertion/reordering/repetition tests.
2. Slice 2, unit rendering: dedicated converters, CoreStack-backed hosted
   views, localization, and the three approved Phase 1 assets.
3. Slice 3, integration gates: FeedFactory screen construction, navigation and
   DI seams, snapshot and accessibility tests, validation host, and evidence.

The exact file membership and realistic line/file budgets for each slice are
recorded in `RPL_EXPORT_MANIFEST.json`.

## Validation status

This export is intentionally not a standalone copy of `reddit-ios`. It was
overlaid at `Modules/ShoppingIntel` in an isolated worktree pinned to
`reddit-ios` commit `be3d8aad96d7b50014ddce82c8265184a7b94082`.

The following gates passed there:

1. `ShoppingIntel_Internal`, `ShoppingIntel_ImplDI`, and the validation host
   built with Bazel.
2. Unit tests passed, including fixture omission, insertion, reordering, and
   repeated feed-unit coverage.
3. Image snapshot tests passed against committed baselines.
4. Accessibility snapshot tests passed against committed baselines.
5. The validation host installed and launched in an iOS 26.5 Simulator. Its
   captured output is included at `Evidence/production-validation.png`.

Future consumers should still run `make depsync` and the same gates after
placing the export into their current `reddit-ios` revision, since internal
target names and dependencies can drift.
