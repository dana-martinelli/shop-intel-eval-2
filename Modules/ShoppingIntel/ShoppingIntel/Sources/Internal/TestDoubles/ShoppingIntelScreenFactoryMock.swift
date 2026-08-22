//
//  Copyright © Reddit. All rights reserved.
//

import ShoppingIntel
import UIKit

public final class ShoppingIntelScreenFactoryMock: ShoppingIntelScreenFactory {
  public var makeSearchResultsViewControllerHandler: (@MainActor () -> UIViewController)?

  public init() {}

  @MainActor
  public func makeSearchResultsViewController() -> UIViewController {
    makeSearchResultsViewControllerHandler?() ?? UIViewController()
  }
}
