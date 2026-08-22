//
//  Copyright © Reddit. All rights reserved.
//

import FeedKit_Models
import FeedKit_ModernFeedElement
import FeedKit_Types
import Foundation
import RedditApollo
import RedditCore_ListingsInterface

enum ShoppingIntelAsyncStrategyError: Error {
  case missingFixture
}

final class ShoppingIntelAsyncStrategy: FeedElementServiceAsyncStrategy {
  typealias DataLoader = @Sendable () throws -> Data

  private let dataLoader: DataLoader

  init(dataLoader: @escaping DataLoader = ShoppingIntelAsyncStrategy.loadBundledFixture) {
    self.dataLoader = dataLoader
  }

  func fetchFeedElements(
    feedSession _: FeedSession,
    feedContext _: RedditApolloRequestMetadata?,
    crossPlatformContext _: FeedKit_Models.CrossPlatformContextInput?,
    after: String?,
    recentlyViewedPostIDs _: [String]?
  ) async throws -> FeedPage {
    guard after == nil else { return .empty }
    try Task.checkCancellation()
    let fixture = try JSONDecoder().decode(ShoppingIntelFixture.self, from: dataLoader())
    return FeedPage(
      pageInfo: PageInfo(hasNextPage: false, endCursor: nil),
      elements: Self.makeElements(from: fixture),
      unknownElements: [],
      dist: nil,
      prefetchContext: nil,
      partialErrors: []
    )
  }

  static func makeElements(from fixture: ShoppingIntelFixture) -> [ModernFeedElement] {
    fixture.units.map { unit in
      switch unit {
      case .searchHeader(let payload):
        ShoppingIntelSearchHeaderElement(payload: payload)
      case .tabs(let payload):
        ShoppingIntelTabsElement(payload: payload)
      case .summary(let payload):
        ShoppingIntelSummaryElement(payload: payload)
      case .productCards(let payload):
        ShoppingIntelProductCardsElement(payload: payload)
      case .expand(let payload):
        ShoppingIntelExpandElement(payload: payload)
      case .post(let payload):
        ShoppingIntelPostElement(payload: payload)
      }
    }
  }

  static func loadFixture() throws -> ShoppingIntelFixture {
    try JSONDecoder().decode(ShoppingIntelFixture.self, from: loadBundledFixture())
  }

  private static func loadBundledFixture() throws -> Data {
    guard let url = ShoppingIntelResources.fixtureURL else {
      throw ShoppingIntelAsyncStrategyError.missingFixture
    }
    return try Data(contentsOf: url)
  }
}
