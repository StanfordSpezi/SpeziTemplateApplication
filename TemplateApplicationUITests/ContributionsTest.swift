//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions


final class ContributionsTest: XCTestCase {
    @MainActor
    override func setUp() async throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["--setupTestAccount", "--skipOnboarding"]
        app.launch()
    }
    
    @MainActor
    func testLicenseInformationPage() {
        let app = XCUIApplication()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))
        
        // Waiting until the setup test accounts actions have been finished & sheets are dismissed.
        sleep(for: .seconds(5))
        
        XCTAssertTrue(app.navigationBars.buttons["Your Account"].waitForExistence(timeout: 6.0))
        app.navigationBars.buttons["Your Account"].tap()
        
        XCTAssertTrue(app.buttons["License Information"].waitForExistence(timeout: 2))
        app.buttons["License Information"].tap()
        XCTAssertTrue(app.buttons["Spezi, MIT, Version: 1.0.0"].waitForExistence(timeout: 3))
    }
}
