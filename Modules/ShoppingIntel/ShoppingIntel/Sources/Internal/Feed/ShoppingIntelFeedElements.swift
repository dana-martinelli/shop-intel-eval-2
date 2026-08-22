//
//  Copyright © Reddit. All rights reserved.
//

import FeedKit_ModernFeedElement

protocol ShoppingIntelPayloadElement: ModernFeedElement {
  associatedtype Payload: Equatable
  var payload: Payload { get }
}

extension ShoppingIntelPayloadElement {
  var modernFeedElementUniqueId: String { payloadID }

  func isContentEqual(to element: ModernFeedElement) -> Bool {
    guard let other = element as? Self else { return false }
    return payload == other.payload
  }

  private var payloadID: String {
    switch payload {
    case let value as ShoppingIntelSearchHeaderPayload: return value.id
    case let value as ShoppingIntelTabsPayload: return value.id
    case let value as ShoppingIntelSummaryPayload: return value.id
    case let value as ShoppingIntelProductCardsPayload: return value.id
    case let value as ShoppingIntelExpandPayload: return value.id
    case let value as ShoppingIntelPostPayload: return value.id
    default:
      assertionFailure("Every ShoppingIntel payload must expose a stable id")
      return String(describing: Self.self)
    }
  }
}

struct ShoppingIntelSearchHeaderElement: ShoppingIntelPayloadElement {
  let payload: ShoppingIntelSearchHeaderPayload
}

struct ShoppingIntelTabsElement: ShoppingIntelPayloadElement {
  let payload: ShoppingIntelTabsPayload
}

struct ShoppingIntelSummaryElement: ShoppingIntelPayloadElement {
  let payload: ShoppingIntelSummaryPayload
}

struct ShoppingIntelProductCardsElement: ShoppingIntelPayloadElement {
  let payload: ShoppingIntelProductCardsPayload
}

struct ShoppingIntelExpandElement: ShoppingIntelPayloadElement {
  let payload: ShoppingIntelExpandPayload
}

struct ShoppingIntelPostElement: ShoppingIntelPayloadElement {
  let payload: ShoppingIntelPostPayload
}
