//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class ContactsTests: XCTestCase {
    @MainActor
    override func setUp() async throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    

    @MainActor
    func testContacts() async throws {
        let app = XCUIApplication()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))

        // Waiting until the setup test accounts actions have been finished & sheets are dismissed.
        try await Task.sleep(for: .seconds(5))
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Contacts"].waitForExistence(timeout: 1))
        app.tabBars["Tab Bar"].buttons["Contacts"].tap()

        XCTAssertTrue(app.staticTexts["Contact: Leland Stanford"].waitForExistence(timeout: 2))

        XCTAssertTrue(app.buttons["Call"].exists)
        XCTAssertTrue(app.buttons["Text"].exists)
        XCTAssertTrue(app.buttons["Email"].exists)
        XCTAssertTrue(app.buttons["Website"].exists)

        XCTAssertTrue(app.buttons["Address: 450 Serra Mall\nStanford CA 94305\nUSA"].exists)
    }
}
