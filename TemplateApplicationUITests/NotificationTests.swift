//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions


class NotificationTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--testScheduleNotification"]
        app.deleteAndLaunch(withSpringboardAppName: "TemplateApplication")
    }
    
    
    func testSchedulerNotification() throws {
        let app = XCUIApplication()
        
        try app.conductOnboardingIfNeeded()
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.activate()
        XCTAssert(springboard.wait(for: .runningForeground, timeout: 2))
        
        let notification = springboard.otherElements["NotificationShortLookView"]
        XCTAssert(notification.waitForExistence(timeout: 120))
        notification.tap()
        
        XCTAssert(app.wait(for: .runningForeground, timeout: 2))
    }
}
