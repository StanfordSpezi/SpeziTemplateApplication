//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


final class ContributionsTest: XCTestCase {
    @MainActor
    override func setUp() async throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--setupTestAccount", "--skipOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "TemplateApplication")
    }

    @MainActor
    func testLicenseInformationPage() async throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))
        
        // Waiting until the setup test accounts actions have been finished & sheets are dismissed.
        try await Task.sleep(for: .seconds(5))
        
        XCTAssertTrue(app.navigationBars.buttons["Your Account"].waitForExistence(timeout: 6.0))
        app.navigationBars.buttons["Your Account"].tap()
        
        XCTAssertTrue(app.buttons["License Information"].waitForExistence(timeout: 2))
        app.buttons["License Information"].tap()
        // Test if the sheet opens by checking if the title of the sheet is present
        XCTAssertTrue(app.staticTexts["This project is licensed under the MIT License."].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Repository Link"].exists)
    }
}
