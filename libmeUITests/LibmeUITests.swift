//
//  libmeUITests.swift
//  libmeUITests
//
//  Created by Ian Macpherson Rojas on 11/13/23.
//

import XCTest

final class LibmeUITests: XCTestCase {
  // Disabling this rule to make initializing test variables not require init
  // swiftlint:disable implicitly_unwrapped_optional
  var app: XCUIApplication!
  // swiftlint:enable implicitly_unwrapped_optional

  func skipFirstRunIfExists() {
    if app.buttons["x.circle.fill"].waitForExistence(timeout: 2) {
      app.buttons["x.circle.fill"].tap()
    }
  }

  func setToFirstTab() {
    app.tabBars["Tab Bar"].buttons["Search"].tap()
  }

  func removeAddedBook() {
    app.tabBars["Tab Bar"].buttons["Bookshelf"].tap()
    if app.collectionViews.cells.element(boundBy: 0).exists {
      app.collectionViews.cells.element(boundBy: 0).swipeLeft()
      app.buttons["Delete"].tap()
    }
  }

  override func setUpWithError() throws {
    app = XCUIApplication()
    app.launch()

    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    skipFirstRunIfExists()
    removeAddedBook()
    setToFirstTab()
  }

  // Should not rely on dynamic data for the test, but let's do it just this once
  func testAddingBook() throws {
    let textField = app.textFields["Search..."]
    textField.tap()
    textField.typeText("Lord of the Rings")
    app.keyboards.buttons["return"].tap()
    app.collectionViews
      .children(matching: .cell)
      .element(boundBy: 0)
      .buttons["The Lord of the Rings, J.R.R. Tolkien"]
      .tap()
    app.buttons["Add to shelf"].tap()
    app.tabBars["Tab Bar"].buttons["Bookshelf"].tap()
    app.collectionViews
      .cells
      .buttons["The Lord of the Rings, J.R.R. Tolkien"]
      .staticTexts["J.R.R. Tolkien"]
      .tap()
    XCTAssertTrue(app.staticTexts["Published in 1954"].exists)
  }
}
