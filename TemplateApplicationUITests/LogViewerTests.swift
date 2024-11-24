//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import OSLog
import XCTest
import XCTestExtensions
import XCTHealthKit
import XCTSpeziAccount
import XCTSpeziNotifications

class LogViewerTests: XCTestCase {
    @MainActor
    override func setUp() async throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    @MainActor
    func testLogViewer() throws {
        let app = XCUIApplication()

        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 2.0))
        
        sleep(2)
        
        XCTAssertTrue(app.navigationBars.buttons["Your Account"].waitForExistence(timeout: 6.0))
        app.navigationBars.buttons["Your Account"].tap()
        
        XCTAssertTrue(app.buttons["View Logs"].waitForExistence(timeout: 2.0))
        app.buttons["View Logs"].tap()
        
        XCTAssertTrue(app.staticTexts["Log Viewer"].waitForExistence(timeout: 2.0))

        XCTAssertTrue(app.staticTexts["No Logs Available"].waitForExistence(timeout: 5.0))
    }
}
