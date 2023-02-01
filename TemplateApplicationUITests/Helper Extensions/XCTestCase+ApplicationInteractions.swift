//
// This source file is part of the Stanford CardinalKit Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


extension XCTestCase {
    func delete(applicationNamed appName: String) {
        let app = XCUIApplication()
        app.terminate()
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        XCTAssertTrue(springboard.icons[appName].waitForExistence(timeout: 0.5))
        springboard.icons[appName].press(forDuration: 1.5)
        
        XCTAssertTrue(springboard.collectionViews.buttons["Remove App"].waitForExistence(timeout: 0.5))
        springboard.collectionViews.buttons["Remove App"].tap()
        XCTAssertTrue(springboard.alerts["Remove “\(appName)”?"].scrollViews.otherElements.buttons["Delete App"].waitForExistence(timeout: 0.5))
        springboard.alerts["Remove “\(appName)”?"].scrollViews.otherElements.buttons["Delete App"].tap()
        XCTAssertTrue(springboard.alerts["Delete “\(appName)”?"].scrollViews.otherElements.buttons["Delete"].waitForExistence(timeout: 0.5))
        springboard.alerts["Delete “\(appName)”?"].scrollViews.otherElements.buttons["Delete"].tap()
    }
}
