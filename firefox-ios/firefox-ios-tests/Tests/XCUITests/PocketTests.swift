// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import XCTest

class PocketTests: BaseTestCase {
    // https://testrail.stage.mozaws.net/index.php?/cases/view/2306924
    func testPocketEnabledByDefault() {
        navigator.goto(NewTabScreen)
        mozWaitForElementToExist(app.staticTexts[AccessibilityIdentifiers.FirefoxHomepage.SectionTitles.pocket])
        XCTAssertEqual(
            app.staticTexts[AccessibilityIdentifiers.FirefoxHomepage.SectionTitles.pocket].label,
            "Thought-Provoking Stories"
        )

        // There should be at least 8 stories on iPhone and three on iPad
        let numPocketStories = app.collectionViews.containing(
            .cell,
            identifier: AccessibilityIdentifiers.FirefoxHomepage.Pocket.itemCell
        ).children(matching: .cell).count-1
        XCTAssertTrue(numPocketStories > 7)

        // Disable Pocket
        navigator.performAction(Action.TogglePocketInNewTab)

        navigator.goto(NewTabScreen)
        mozWaitForElementToNotExist(app.staticTexts[AccessibilityIdentifiers.FirefoxHomepage.SectionTitles.pocket])
        // Enable it again
        navigator.performAction(Action.TogglePocketInNewTab)
        navigator.goto(NewTabScreen)
        mozWaitForElementToExist(app.staticTexts[AccessibilityIdentifiers.FirefoxHomepage.SectionTitles.pocket])

        // Tap on the first Pocket element
        app.collectionViews.scrollViews.cells[AccessibilityIdentifiers.FirefoxHomepage.Pocket.itemCell].firstMatch.tap()
        waitUntilPageLoad()
        // The url textField is not empty
        XCTAssertNotEqual(app.textFields["url"].value as! String, "", "The url textField is empty")
    }
}
