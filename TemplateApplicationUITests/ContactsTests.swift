//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class ContactsTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    func testContacts() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Contacts"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Contacts"].tap()

        XCTAssertTrue(app.staticTexts["Contact: Leland Stanford"].waitForExistence(timeout: 2))

        XCTAssertTrue(app.buttons["Call"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Text"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Email"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Website"].waitForExistence(timeout: 2))

        XCTAssertTrue(app.buttons["Address: 450 Serra Mall\nStanford CA 94305\nUSA"].waitForExistence(timeout: 2))
    }
}
