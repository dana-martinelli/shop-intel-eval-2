//
//  Copyright © Reddit. All rights reserved.
//

import AppSettings
import FeedKit_FeedFactory_InterfaceDI
import FeedKit_Services_FeedRepository_InterfaceDI
import Locator
import Locator_RedditLocator
import RedditCore_ServiceLocator
import ShoppingIntel_DI
import ShoppingIntel_Internal

extension Locator.Impl {
  static let shoppingIntelScreenFactory = impl(
    .shoppingIntelScreenFactory,
    dependencies: [
      .account,
      .appSettings,
      .feedFactory,
      .feedRepositoryStrategyFactory,
    ],
    hostingMode: .transient
  ) { injector in
    ShoppingIntelScreenFactoryImpl(
      account: injector.locate(.account),
      appSettings: injector.locate(.appSettings),
      feedFactory: injector.locate(.feedFactory),
      feedRepositoryFactory: injector.locate(.feedRepositoryStrategyFactory)
    )
  }
}
