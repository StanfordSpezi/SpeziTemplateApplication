//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions


class AccountTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()

        try disablePasswordAutofill()

        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments = ["--skipOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "TemplateApplication")
    }

    func testAccountSheet() throws {
        let app = XCUIApplication()
    }
}
