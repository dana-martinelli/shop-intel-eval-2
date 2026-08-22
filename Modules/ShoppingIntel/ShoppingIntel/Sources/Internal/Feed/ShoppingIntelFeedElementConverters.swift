//
//  Copyright © Reddit. All rights reserved.
//

import FeedKit_FeedFactory
import FeedKit_Protocols
import FeedKit_Types
import SliceKit
import UIKit

final class ShoppingIntelSearchHeaderConverter: FeedElementConverter {
  private weak var navigator: (any ShoppingIntelNavigator)?

  init(navigator: any ShoppingIntelNavigator) {
    self.navigator = navigator
  }

  func refresh() {}

  func convert(_ data: FeedElementData, position _: Int) -> [any ListItemRepresentable] {
    guard let element = data.feedElement as? ShoppingIntelSearchHeaderElement else { return [] }
    return [ShoppingIntelSearchHeaderView(
      differenceIdentifier: element.modernFeedElementUniqueId,
      payload: element.payload,
      onBack: { [weak navigator] in navigator?.dismiss() }
    )]
  }
}

final class ShoppingIntelTabsConverter: FeedElementConverter {
  func refresh() {}

  func convert(_ data: FeedElementData, position _: Int) -> [any ListItemRepresentable] {
    guard let element = data.feedElement as? ShoppingIntelTabsElement else { return [] }
    return [ShoppingIntelTabsView(
      differenceIdentifier: element.modernFeedElementUniqueId,
      payload: element.payload
    )]
  }
}

final class ShoppingIntelSummaryConverter: FeedElementConverter {
  func refresh() {}

  func convert(_ data: FeedElementData, position _: Int) -> [any ListItemRepresentable] {
    guard let element = data.feedElement as? ShoppingIntelSummaryElement else { return [] }
    return [ShoppingIntelSummaryView(
      differenceIdentifier: element.modernFeedElementUniqueId,
      payload: element.payload
    )]
  }
}

final class ShoppingIntelProductCardsConverter: FeedElementConverter {
  func refresh() {}

  func convert(_ data: FeedElementData, position _: Int) -> [any ListItemRepresentable] {
    guard let element = data.feedElement as? ShoppingIntelProductCardsElement else { return [] }
    return [ShoppingIntelProductCardsView(
      differenceIdentifier: element.modernFeedElementUniqueId,
      payload: element.payload
    )]
  }
}

final class ShoppingIntelExpandConverter: FeedElementConverter {
  func refresh() {}

  func convert(_ data: FeedElementData, position _: Int) -> [any ListItemRepresentable] {
    guard let element = data.feedElement as? ShoppingIntelExpandElement else { return [] }
    return [ShoppingIntelExpandView(
      differenceIdentifier: element.modernFeedElementUniqueId,
      payload: element.payload
    )]
  }
}

final class ShoppingIntelPostConverter: FeedElementConverter {
  private weak var navigator: (any ShoppingIntelNavigator)?

  init(navigator: any ShoppingIntelNavigator) {
    self.navigator = navigator
  }

  func refresh() {}

  func convert(_ data: FeedElementData, position _: Int) -> [any ListItemRepresentable] {
    guard let element = data.feedElement as? ShoppingIntelPostElement else { return [] }
    return [ShoppingIntelPostView(
      differenceIdentifier: element.modernFeedElementUniqueId,
      payload: element.payload,
      onOpen: { [weak navigator] id in navigator?.openPost(id: id) }
    )]
  }
}

final class ShoppingIntelFeedElementConverterFactoryProvider: FeedElementConverterFactoryProvider {
  private let navigator: any ShoppingIntelNavigator

  init(navigator: any ShoppingIntelNavigator) {
    self.navigator = navigator
  }

  func makeFactory(viewController _: UIViewController?) -> FeedElementConverterFactory {
    ShoppingIntelFeedElementConverterFactory(navigator: navigator)
  }
}

private final class ShoppingIntelFeedElementConverterFactory: FeedElementConverterFactory {
  private let navigator: any ShoppingIntelNavigator

  init(navigator: any ShoppingIntelNavigator) {
    self.navigator = navigator
  }

  func makeConverters() -> [FeedElementConverter] {
    [
      ShoppingIntelSearchHeaderConverter(navigator: navigator),
      ShoppingIntelTabsConverter(),
      ShoppingIntelSummaryConverter(),
      ShoppingIntelProductCardsConverter(),
      ShoppingIntelExpandConverter(),
      ShoppingIntelPostConverter(navigator: navigator),
    ]
  }
}
