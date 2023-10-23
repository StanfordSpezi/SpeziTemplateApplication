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
        
        try disablePasswordAutofill()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "TemplateApplication")
    }

    func testLicenseInformationPage() throws {
        let app = XCUIApplication()

        // complete onboarding so user is logged in
        try app.conductOnboardingIfNeeded(email: "leland@contributions.stanford.edu")

        
        XCTAssertTrue(app.buttons["Your Account"].waitForExistence(timeout: 6.0))
        app.buttons["Your Account"].tap()
        
        XCTAssertTrue(app.buttons["License Information"].waitForExistence(timeout: 2))
        app.buttons["License Information"].tap()
        // Test if the sheet opens by checking if the title of the sheet is present
        XCTAssertTrue(app.staticTexts["This project is licensed under the MIT License."].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["Repository Link"].waitForExistence(timeout: 2))
    }
}
