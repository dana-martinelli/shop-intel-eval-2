//
//  Copyright © Reddit. All rights reserved.
//

import Locator
import Locator_RedditLocator
import ShoppingIntel

extension Locator.Kind {
  public static let shoppingIntelScreenFactory = accountScoped(ShoppingIntelScreenFactory.self)
}
