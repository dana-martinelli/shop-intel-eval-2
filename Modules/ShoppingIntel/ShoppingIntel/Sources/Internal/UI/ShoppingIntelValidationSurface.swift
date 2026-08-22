//
//  Copyright © Reddit. All rights reserved.
//

import SwiftUI
import UIKit

public struct ShoppingIntelValidationSurfaceFactory {
  public init() {}

  @MainActor
  public func makeViewController() -> UIViewController {
    let fixture = (try? ShoppingIntelAsyncStrategy.loadFixture()) ?? .init(units: [])
    return UIHostingController(rootView: ShoppingIntelValidationSurface(fixture: fixture))
  }
}

package struct ShoppingIntelValidationSurface: View {
  let fixture: ShoppingIntelFixture

  package init() {
    fixture = (try? ShoppingIntelAsyncStrategy.loadFixture()) ?? .init(units: [])
  }

  init(fixture: ShoppingIntelFixture) {
    self.fixture = fixture
  }

  package var body: some View {
    ScrollView {
      LazyVStack(spacing: 0) {
        ForEach(Array(fixture.units.enumerated()), id: \.offset) { _, unit in
          unitView(unit)
        }
      }
    }
    .accessibilityIdentifier("shopping-intel.validation-surface")
  }

  @ViewBuilder
  private func unitView(_ unit: ShoppingIntelFixture.Unit) -> some View {
    switch unit {
    case .searchHeader(let payload):
      ShoppingIntelSearchHeaderView(
        differenceIdentifier: payload.id,
        payload: payload,
        onBack: {}
      )
    case .tabs(let payload):
      ShoppingIntelTabsView(differenceIdentifier: payload.id, payload: payload)
    case .summary(let payload):
      ShoppingIntelSummaryView(differenceIdentifier: payload.id, payload: payload)
    case .productCards(let payload):
      ShoppingIntelProductCardsView(differenceIdentifier: payload.id, payload: payload)
    case .expand(let payload):
      ShoppingIntelExpandView(differenceIdentifier: payload.id, payload: payload)
    case .post(let payload):
      ShoppingIntelPostView(
        differenceIdentifier: payload.id,
        payload: payload,
        onOpen: { _ in }
      )
    }
  }
}
