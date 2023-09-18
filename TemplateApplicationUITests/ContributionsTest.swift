//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class ContributionsTest: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding", "--disableFirebase"]
        app.launch()
    }

    func testInfoButton() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.buttons["Info"].waitForExistence(timeout: 2))
        app.buttons["Info"].tap()
        
        XCTAssertTrue(app.staticTexts["SpeziTemplateApplication"].waitForExistence(timeout: 2))
    }
}
