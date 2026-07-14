//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions
import XCTSpeziAccount


final class ScheduleLogoutTests: XCTestCase {
    @MainActor
    override func setUp() async throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        // Sign in a test account so we have an active user context that we can log out of.
        app.launchArguments = ["--setupTestAccount", "--skipOnboarding"]
        app.launch()
    }


    /// Regression test for https://github.com/StanfordSpezi/SpeziTemplateApplication/issues/57:
    /// logging out clears the schedule (and its queued notifications), and signing back in re-creates it.
    @MainActor
    func testScheduleResetOnLogout() throws {
        let app = XCUIApplication()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))

        // Waiting until the setup test account actions have been finished & sheets are dismissed.
        sleep(for: .seconds(5))

        // While signed in, the scheduled task is present.
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Schedule"].waitForExistence(timeout: 6.0))
        app.tabBars["Tab Bar"].buttons["Schedule"].tap()
        XCTAssertTrue(app.buttons["Start Questionnaire"].waitForExistence(timeout: 5))

        // Log out via the account overview.
        logout(app)

        // After logging out, the account sheet dismisses and the schedule (and its queued notifications) is cleared.
        XCTAssertTrue(app.buttons["Start Questionnaire"].waitForNonExistence(timeout: 10))

        // Signing back in re-creates the schedule.
        XCTAssertTrue(app.navigationBars.buttons["Your Account"].waitForExistence(timeout: 5))
        app.navigationBars.buttons["Your Account"].tap()
        try app.login(email: "lelandstanford@stanford.edu", password: "StanfordRocks!")
        XCTAssertTrue(app.buttons["Start Questionnaire"].waitForExistence(timeout: 10))
    }


    @MainActor
    private func logout(_ app: XCUIApplication) {
        XCTAssertTrue(app.navigationBars.buttons["Your Account"].waitForExistence(timeout: 6.0))
        app.navigationBars.buttons["Your Account"].tap()

        XCTAssertTrue(app.staticTexts["Account Overview"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Logout"].waitForExistence(timeout: 5))
        app.buttons["Logout"].tap()

        let logoutAlert = app.alerts["Are you sure you want to logout?"]
        XCTAssertTrue(logoutAlert.waitForExistence(timeout: 2))
        logoutAlert.buttons["Logout"].tap()
    }
}
