//
//  Copyright © Reddit. All rights reserved.
//

import CoreStack

struct ShoppingIntelDisplayFeature<Payload: Sendable>: CoreStackFeature {
  struct State: Sendable {
    let payload: Payload
  }

  enum Action: Sendable {
    case noOp
  }

  func handle(state _: Mutable<State>, action _: Action) async {}
}

struct ShoppingIntelHeaderFeature: CoreStackFeature {
  struct State: Sendable {
    let payload: ShoppingIntelSearchHeaderPayload
  }

  enum Action: Sendable {
    case tappedBack
  }

  struct Dependencies: CoreStackDependencyProvider, Sendable {
    let dismiss: @MainActor @Sendable () -> Void
  }

  @MainActor
  func handle(state _: Mutable<State>, action: Action, dependencies: Dependencies) async {
    if case .tappedBack = action {
      dependencies.dismiss()
    }
  }
}

struct ShoppingIntelTabsFeature: CoreStackFeature {
  struct State: Sendable {
    let payload: ShoppingIntelTabsPayload
    var selectedID: String
  }

  enum Action: Sendable {
    case selected(String)
  }

  @MainActor
  func handle(state: Mutable<State>, action: Action) async {
    if case .selected(let id) = action, state.payload.tabs.contains(where: { $0.id == id }) {
      state.selectedID = id
    }
  }
}

struct ShoppingIntelExpandFeature: CoreStackFeature {
  struct State: Sendable {
    let payload: ShoppingIntelExpandPayload
    var isExpanded = false
  }

  enum Action: Sendable {
    case tapped
  }

  @MainActor
  func handle(state: Mutable<State>, action: Action) async {
    if case .tapped = action {
      state.isExpanded.toggle()
    }
  }
}
