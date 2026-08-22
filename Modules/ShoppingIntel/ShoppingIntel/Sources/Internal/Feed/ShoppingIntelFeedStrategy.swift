//
//  Copyright © Reddit. All rights reserved.
//

import AppSettings
import ExperimentKit_ExperimentManagement
import FeedKit_Experiments
import FeedKit_Types
import FeedOptions
import RedditCore_RedditCoreModels
import RedditUIIdentifiers
import SliceKit
import UIKit
import UXTargeting

struct ShoppingIntelFeedStrategy: FeedStrategy {
  private let account: Account
  private let appSettings: AppSettings

  init(account: Account, appSettings: AppSettings) {
    self.account = account
    self.appSettings = appSettings
  }

  func pageItemId() -> String { "shopping-intel-search-results" }
  func description() -> String { "Shopping Intelligence Search Results" }
  func cacheKey() -> String { "shopping-intel-search-results" }
  func legacyFeedType() -> FeedType { .unknown }

  func analyticsPageType() -> String { "search_results_shopping_intel" }
  func analyticsReason() -> String { "shopping_intel" }
  func analyticsExperiment() -> FeedExperiment? { nil }
  func postInteractionType() -> String? { nil }
  func arenaEventId() -> String? { nil }
  func analyticsFeedReference() -> AnalyticsFeedReference? { nil }

  func makeAsyncServiceStrategy() -> FeedElementServiceAsyncStrategy {
    ShoppingIntelAsyncStrategy()
  }

  func defaultSort() -> FeedSort { .hot }
  func defaultRange() -> FeedRange { .unknown }
  func defaultMode() -> FeedDisplayMode { .classic }
  func experience() -> UXExperience { .pcrInHomeFeed }

  func supportsInstantCommentLoading() -> Bool { false }
  func shouldEnableInstantLoading() -> Bool { false }
  func supportsSubredditMuting() -> Bool { false }
  func supportsContributionKickstarting() -> Bool { false }
  func requiresFullscreenPostUnits() -> Bool { false }
  func shouldEnablePDPCommentsPrefetch() -> Bool { false }
  func isSkipToCommentsSupported(post _: Post) -> Bool { false }
  func isInitialFeedForAccount() -> Bool { false }
  func requiresDivider() -> Bool { false }

  func feedListContentInsetAdjustmentBehavior() -> UIScrollView.ContentInsetAdjustmentBehavior { .automatic }
  func feedListAdjustContentOffset() -> Bool { true }
  func feedListSafeAreaEdges() -> SafeAreaRespectEdges { [.horizontal] }
  func scrollingBehavior() -> ScrollingBehavior { .standard() }
  func fullScreenItemSizingBehavior() -> FullScreenItemSizingBehavior { .contentInsetAdjusted }
  func shouldAdjustFullScreenItemsByContentInset() -> Bool { true }
  func contentOffsetAnimatedFlagOn() -> Bool { false }
  func shouldShowLoadingOnSettingsChanged() -> Bool { false }
  func accessibilityIdentifier(state _: FeedListViewModelState) -> RedditUIIdentifier? { nil }
  func autoHideNavBottomEnabled() -> Bool { false }
  func autoHideNavTopEnabled() -> Bool { false }

  func layoutType(
    displayMode _: FeedDisplayMode,
    feedItemSizeVariant _: FeedEstimateItemSizeVariants
  ) -> ListSection.LayoutType {
    .defaultVertical
  }

  func showCookieConsentBanner(presentingViewController _: UIViewController) {}
  func subredditName() -> String? { nil }
  func feedPostOptions() -> FeedPostOptions {
    .defaultFeedPostOptions(account: account, appSettings: appSettings)
  }
  func delayFeedRequest() async throws {}

  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.account == rhs.account && lhs.appSettings == rhs.appSettings
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(cacheKey())
    hasher.combine(account)
    hasher.combine(appSettings)
  }
}
