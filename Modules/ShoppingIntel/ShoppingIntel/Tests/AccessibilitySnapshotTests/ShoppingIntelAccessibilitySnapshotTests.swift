//
//  Copyright © Reddit. All rights reserved.
//

@testable import ShoppingIntel_Internal
import RedditSliceKit_SwiftUITestHelpers
import SwiftUI
import TestHelpers_Snapshots
import XCTest

@MainActor
final class ShoppingIntelAccessibilitySnapshotTests: AccessibilitySnapshotTestCase {
  func testPhase1SearchResultsAccessibilityTree() {
    assertSwiftUIAccessibilitySnapshot(suffixes: ["phase-1-search-results"]) {
      ShoppingIntelValidationSurface()
        .frame(width: 393, height: 1400, alignment: .top)
    }
  }

  func testRepeatedPostUnitsRemainDistinct() throws {
    let fixture = try ShoppingIntelAsyncStrategy.loadFixture()
    assertSwiftUIAccessibilitySnapshot(suffixes: ["repeated-post-units"]) {
      ShoppingIntelValidationSurface(fixture: fixture)
        .frame(width: 393, height: 1400, alignment: .top)
    }
  }
}
