//
//  Copyright © Reddit. All rights reserved.
//

@testable import ShoppingIntel_Internal
import Palette_RedditPalette
import RedditSliceKit_SwiftUITestHelpers
import SnapshotHelpers
import SwiftUI
import TestHelpers_Snapshots
import XCTest

@MainActor
final class ShoppingIntelSnapshotTests: SnapshotTestCase {
  func testPhase1SearchResultsSurface() {
    assertSwiftUISnapshot(
      themeType: .alienblue,
      suffixes: ["phase-1-search-results"]
    ) {
      ShoppingIntelValidationSurface()
        .frame(width: 472, height: 1024, alignment: .top)
    }
  }

  func testPerUnitViewsAtAccessibilityTextSize() throws {
    let fixture = try ShoppingIntelAsyncStrategy.loadFixture()
    assertSwiftUISnapshot(
      themeType: .alienblue,
      fontSize: .watermelon,
      suffixes: ["per-unit-watermelon"]
    ) {
      ShoppingIntelValidationSurface(fixture: fixture)
        .frame(width: 472, height: 1400, alignment: .top)
    }
  }
}
