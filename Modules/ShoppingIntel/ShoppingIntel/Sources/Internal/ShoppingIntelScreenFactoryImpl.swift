//
//  Copyright © Reddit. All rights reserved.
//

import AppSettings
import FeedKit_Core
import FeedKit_FeedFactory
import FeedKit_Protocols
import FeedKit_Services_FeedRepository
import FeedKit_Types
import Palette_RedditPalette
import RedditCore_RedditCoreModels
import ShoppingIntel
import UIKit

package final class ShoppingIntelScreenFactoryImpl: ShoppingIntelScreenFactory {
  private let account: Account
  private let appSettings: AppSettings
  private let feedFactory: FeedFactory
  private let feedRepositoryFactory: FeedRepositoryStrategyFactory

  package init(
    account: Account,
    appSettings: AppSettings,
    feedFactory: FeedFactory,
    feedRepositoryFactory: FeedRepositoryStrategyFactory
  ) {
    self.account = account
    self.appSettings = appSettings
    self.feedFactory = feedFactory
    self.feedRepositoryFactory = feedRepositoryFactory
  }

  @MainActor
  package func makeSearchResultsViewController() -> UIViewController {
    let strategy = ShoppingIntelFeedStrategy(account: account, appSettings: appSettings)
    let repository = feedRepositoryFactory.make(
      feedStrategy: strategy,
      transformerFactory: EmptyFeedElementTransformerFactory()
    )
    let navigator = ShoppingIntelNavigatorImpl()
    let converterProvider = ShoppingIntelFeedElementConverterFactoryProvider(navigator: navigator)
    let (_, viewController) = feedFactory.makeFeedListViewModelAndViewController(
      strategy: strategy,
      converterFactoryProvider: converterProvider,
      feedRepository: repository,
      emptySectionsFactory: nil,
      feedNavigationBarConfiguration: nil,
      backgroundColorKeyPath: \.color.rpl.neutral.background,
      viewControllerLifeCycleEvents: nil,
      environmentSource: nil,
      isPaginationWaitEnabled: false,
      analyticsScreenViewContext: nil
    )
    navigator.viewController = viewController
    return viewController
  }
}
