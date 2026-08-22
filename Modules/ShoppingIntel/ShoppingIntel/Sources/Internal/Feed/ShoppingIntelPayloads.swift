//
//  Copyright © Reddit. All rights reserved.
//

import Foundation

struct ShoppingIntelSearchHeaderPayload: Codable, Equatable, Sendable {
  let id: String
  let query: String
}

struct ShoppingIntelTabsPayload: Codable, Equatable, Sendable {
  let id: String
  let selectedID: String
  let tabs: [Tab]

  struct Tab: Codable, Equatable, Sendable {
    let id: String
    let title: String
  }
}

struct ShoppingIntelSummaryPayload: Codable, Equatable, Sendable {
  let id: String
  let title: String
  let body: String
}

struct ShoppingIntelProductCardsPayload: Codable, Equatable, Sendable {
  let id: String
  let products: [Product]

  struct Product: Codable, Equatable, Identifiable, Sendable {
    let id: String
    let imageName: String
    let title: String
    let mentions: String
  }
}

struct ShoppingIntelExpandPayload: Codable, Equatable, Sendable {
  let id: String
  let collapsedTitle: String
  let expandedTitle: String
  let expandedHeading: String
  let expandedBody: String
}

struct ShoppingIntelPostPayload: Codable, Equatable, Sendable {
  let id: String
  let community: String
  let age: String
  let title: String
  let votes: String
  let comments: String
  let imageName: String?
}

struct ShoppingIntelFixture: Decodable, Sendable {
  let units: [Unit]

  enum Unit: Decodable, Sendable {
    case searchHeader(ShoppingIntelSearchHeaderPayload)
    case tabs(ShoppingIntelTabsPayload)
    case summary(ShoppingIntelSummaryPayload)
    case productCards(ShoppingIntelProductCardsPayload)
    case expand(ShoppingIntelExpandPayload)
    case post(ShoppingIntelPostPayload)

    private enum CodingKeys: String, CodingKey {
      case type
    }

    private enum Kind: String, Decodable {
      case searchHeader
      case tabs
      case summary
      case productCards
      case expand
      case post
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      switch try container.decode(Kind.self, forKey: .type) {
      case .searchHeader:
        self = .searchHeader(try ShoppingIntelSearchHeaderPayload(from: decoder))
      case .tabs:
        self = .tabs(try ShoppingIntelTabsPayload(from: decoder))
      case .summary:
        self = .summary(try ShoppingIntelSummaryPayload(from: decoder))
      case .productCards:
        self = .productCards(try ShoppingIntelProductCardsPayload(from: decoder))
      case .expand:
        self = .expand(try ShoppingIntelExpandPayload(from: decoder))
      case .post:
        self = .post(try ShoppingIntelPostPayload(from: decoder))
      }
    }
  }
}
