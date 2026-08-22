//
//  Copyright © Reddit. All rights reserved.
//

@testable import ShoppingIntel_Internal
import FeedKit_ModernFeedElement
import FeedKit_Protocols
import FeedKit_ServingID
import FeedKit_Types
import SliceKit
import XCTest

final class ShoppingIntelFeedTests: XCTestCase {
  func testFixturePreservesDeclaredOrder() throws {
    let elements = ShoppingIntelAsyncStrategy.makeElements(from: try ShoppingIntelAsyncStrategy.loadFixture())

    XCTAssertEqual(
      elements.map(\.modernFeedElementUniqueId),
      [
        "search-header",
        "result-tabs",
        "shopping-summary",
        "product-cards",
        "summary-expand",
        "best-running-shoes",
        "budget-running-shoes",
        "favorite-daily-running-shoe",
      ]
    )
  }

  func testOmissionRemovesOnlyRequestedUnit() throws {
    let fixture = try ShoppingIntelAsyncStrategy.loadFixture()
    let omitted = ShoppingIntelFixture(units: fixture.units.filter {
      if case .summary = $0 { return false }
      return true
    })

    let ids = ShoppingIntelAsyncStrategy.makeElements(from: omitted).map(\.modernFeedElementUniqueId)
    XCTAssertFalse(ids.contains("shopping-summary"))
    XCTAssertEqual(ids.count, fixture.units.count - 1)
  }

  func testInsertionAppearsAtDeclaredPosition() throws {
    let fixture = try ShoppingIntelAsyncStrategy.loadFixture()
    var units = fixture.units
    units.insert(.post(.init(
      id: "inserted-post",
      community: "r/running",
      age: "1h",
      title: "Inserted by the service response",
      votes: "1 vote",
      comments: "0 comments",
      imageName: nil
    )), at: 2)

    let ids = ShoppingIntelAsyncStrategy.makeElements(from: .init(units: units))
      .map(\.modernFeedElementUniqueId)
    XCTAssertEqual(ids[2], "inserted-post")
  }

  func testReorderingRequiresNoConverterChanges() throws {
    let fixture = try ShoppingIntelAsyncStrategy.loadFixture()
    let reversed = ShoppingIntelFixture(units: Array(fixture.units.reversed()))

    XCTAssertEqual(
      ShoppingIntelAsyncStrategy.makeElements(from: reversed).map(\.modernFeedElementUniqueId),
      Array(ShoppingIntelAsyncStrategy.makeElements(from: fixture).map(\.modernFeedElementUniqueId).reversed())
    )
  }

  func testRepeatableUnitsRemainIndependent() throws {
    let elements = ShoppingIntelAsyncStrategy.makeElements(from: try ShoppingIntelAsyncStrategy.loadFixture())

    XCTAssertEqual(elements.compactMap { $0 as? ShoppingIntelPostElement }.count, 3)
    XCTAssertEqual(
      try XCTUnwrap(elements.compactMap { $0 as? ShoppingIntelProductCardsElement }.first)
        .payload.products.count,
      2
    )
  }

  func testEveryElementUsesItsDedicatedConverterAndView() throws {
    let fixture = try ShoppingIntelAsyncStrategy.loadFixture()
    let elements = ShoppingIntelAsyncStrategy.makeElements(from: fixture)
    let navigator = ShoppingIntelNavigatorImpl()
    let converters: [FeedElementConverter] = [
      ShoppingIntelSearchHeaderConverter(navigator: navigator),
      ShoppingIntelTabsConverter(),
      ShoppingIntelSummaryConverter(),
      ShoppingIntelProductCardsConverter(),
      ShoppingIntelExpandConverter(),
      ShoppingIntelPostConverter(navigator: navigator),
    ]

    let converted = elements.enumerated().flatMap { index, element in
      let data = FeedElementData(
        feedElement: element,
        servingID: ServingID(predefinedID: "shopping-intel-tests"),
        shouldExcludeFromPosition: false
      )
      return converters.flatMap { $0.convert(data, position: index) }
    }

    XCTAssertEqual(converted.count, elements.count)
    XCTAssertTrue(converted.contains { $0 is ShoppingIntelSearchHeaderView })
    XCTAssertTrue(converted.contains { $0 is ShoppingIntelTabsView })
    XCTAssertTrue(converted.contains { $0 is ShoppingIntelSummaryView })
    XCTAssertTrue(converted.contains { $0 is ShoppingIntelProductCardsView })
    XCTAssertTrue(converted.contains { $0 is ShoppingIntelExpandView })
    XCTAssertEqual(converted.compactMap { $0 as? ShoppingIntelPostView }.count, 3)
  }
}
