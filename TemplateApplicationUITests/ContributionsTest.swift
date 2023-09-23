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
        // Test if the sheet opens by checking if the title of the sheet is present
        XCTAssertTrue(app.staticTexts["SpeziTemplateApplication"].waitForExistence(timeout: 2))
    }
    
    func testPackageList() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.buttons["Info"].waitForExistence(timeout: 2))
        app.buttons["Info"].tap()
        // Test if one Repository Link button exists, so at least one element exists in the package list
        XCTAssertTrue(app.buttons["Repository Link"].waitForExistence(timeout: 2))
    }
}
