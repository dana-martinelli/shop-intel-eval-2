//
//  Copyright © Reddit. All rights reserved.
//

import UIKit

@MainActor
protocol ShoppingIntelNavigator: AnyObject, Sendable {
  func dismiss()
  func openPost(id: String)
}

@MainActor
final class ShoppingIntelNavigatorImpl: ShoppingIntelNavigator, @unchecked Sendable {
  weak var viewController: UIViewController?

  func dismiss() {
    if let navigationController = viewController?.navigationController {
      navigationController.popViewController(animated: true)
    } else {
      viewController?.dismiss(animated: true)
    }
  }

  func openPost(id _: String) {
    // Integration seam: the owning Search router supplies PDP navigation when
    // this module is installed in reddit-ios.
  }
}
