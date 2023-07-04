//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest


class MockUploadTestsTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.launch()
    }
    
    
    func testMockUpload() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.tabBars["Tab Bar"].buttons["Mock Upload"].waitForExistence(timeout: 2))
        app.tabBars["Tab Bar"].buttons["Mock Upload"].tap()
        
        XCTAssertTrue(app.staticTexts["Mock Upload"].waitForExistence(timeout: 2))
    }
}
