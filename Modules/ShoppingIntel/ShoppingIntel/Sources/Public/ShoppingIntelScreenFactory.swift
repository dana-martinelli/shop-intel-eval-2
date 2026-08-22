//
//  Copyright © Reddit. All rights reserved.
//

import UIKit

/// Creates the Phase 1 Shopping Intelligence subsection as a production feed.
public protocol ShoppingIntelScreenFactory {
  @MainActor
  func makeSearchResultsViewController() -> UIViewController
}
