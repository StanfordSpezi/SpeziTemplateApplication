//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions


class SchedulerTests: XCTestCase {
    @MainActor
    override func setUp() async throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "TemplateApplication")
    }
    

    @MainActor
    func testScheduler() throws {
        let app = XCUIApplication()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))

        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Schedule"].exists)
        app.tabBars["Tab Bar"].buttons["Schedule"].tap()
        
        XCTAssertTrue(app.buttons["Start Questionnaire"].waitForExistence(timeout: 2))
        app.buttons["Start Questionnaire"].tap()
        
        XCTAssertTrue(app.staticTexts["Social Support"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.navigationBars.buttons["Cancel"].exists)

        XCTAssertTrue(app.staticTexts["None of the time"].exists)
        let noButton = app.staticTexts["None of the time"]

        let nextButton = app.buttons["Next"]

        for _ in 1...4 {
            XCTAssertFalse(nextButton.isEnabled)
            noButton.tap()
            XCTAssertTrue(nextButton.isEnabled)
            nextButton.tap()
            usleep(500_000)
        }

        XCTAssert(app.staticTexts["What is your age?"].waitForExistence(timeout: 0.5))
        XCTAssert(app.textFields["Tap to answer"].exists)
        try app.textFields["Tap to answer"].enter(value: "25")
        app.buttons["Done"].tap()

        XCTAssert(nextButton.isEnabled)
        nextButton.tap()

        XCTAssert(app.staticTexts["What is your preferred contact method?"].waitForExistence(timeout: 0.5))
        XCTAssert(app.staticTexts["E-mail"].exists)
        app.staticTexts["E-mail"].tap()

        XCTAssert(nextButton.isEnabled)
        nextButton.tap()

        XCTAssert(app.staticTexts["Thank you for taking the survey!"].waitForExistence(timeout: 0.5))
        XCTAssert(app.buttons["Done"].exists)
        app.buttons["Done"].tap()

        XCTAssert(app.staticTexts["Completed"].waitForExistence(timeout: 0.5))
    }
}
