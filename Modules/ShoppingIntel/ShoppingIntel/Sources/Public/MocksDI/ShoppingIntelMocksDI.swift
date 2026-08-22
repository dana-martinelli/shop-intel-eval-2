//
//  Copyright © Reddit. All rights reserved.
//

import Locator
import Locator_RedditLocator
import ShoppingIntel_DI
import ShoppingIntel_TestDoubles

extension Locator.Mock {
  static let shoppingIntelScreenFactory = mock(
    .shoppingIntelScreenFactory,
    dependencies: [],
    hostingMode: .transient
  ) { _ in
    ShoppingIntelScreenFactoryMock()
  }
}
