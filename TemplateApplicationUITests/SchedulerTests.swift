//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions


class SchedulerTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding", "--testSchedule"]
        app.deleteAndLaunch(withSpringboardAppName: "TemplateApplication")
    }
    
    
    func testScheduler() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Schedule"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Schedule"].tap()
        
        XCTAssertTrue(app.staticTexts["Start Test"].waitForExistence(timeout: 2))
        app.staticTexts["Start Test"].tap()

        XCTAssertTrue(app.staticTexts["This is a test"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Close"].waitForExistence(timeout: 5))
        app.buttons["Close"].tap()
        
        XCTAssertTrue(!app.staticTexts["Start Test"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.images["Selected"].waitForExistence(timeout: 2))
    }
}
