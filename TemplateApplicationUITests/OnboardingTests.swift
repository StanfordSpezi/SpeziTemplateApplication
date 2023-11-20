//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions
import XCTHealthKit


class OnboardingTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        try disablePasswordAutofill()

        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "TemplateApplication")
    }
    
    
    func testOnboardingFlow() throws {
        let app = XCUIApplication()
        let email = "leland@onboarding.stanford.edu"
        
        try app.navigateOnboardingFlow(email: email)

        app.assertOnboardingComplete()
        try app.assertAccountInformation(email: email)
    }
    
    func testOnboardingFlowRepeated() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding", "--disableFirebase"]
        app.terminate()
        app.launch()
        
        try app.navigateOnboardingFlow()
        app.assertOnboardingComplete()
        
        app.terminate()
        
        // Second onboarding round shouldn't display HealthKit and Notification authorizations anymore
        app.activate()
        
        try app.navigateOnboardingFlow(repeated: true)
        // Do not show HealthKit and Notification authorization view again
        app.assertOnboardingComplete()
    }
}


extension XCUIApplication {
    func conductOnboardingIfNeeded(email: String = "leland@stanford.edu") throws {
        let app = XCUIApplication()
        
        if app.staticTexts["Spezi\nTemplate Application"].waitForExistence(timeout: 5) {
            try app.navigateOnboardingFlow(email: email)
        }
    }
    
    fileprivate func navigateOnboardingFlow(
        email: String = "leland@stanford.edu",
        repeated skippedIfRepeated: Bool = false
    ) throws {
        try navigateOnboardingFlowWelcome()
        try navigateOnboardingFlowInterestingModules()
        if staticTexts["Your Account"].waitForExistence(timeout: 5) {
            try navigateOnboardingAccount(email: email)
        }
        if staticTexts["Consent"].waitForExistence(timeout: 5) {
            try navigateOnboardingFlowConsent()
        }
        if !skippedIfRepeated {
            try navigateOnboardingFlowHealthKitAccess()
            try navigateOnboardingFlowNotification()
        }
    }
    
    private func navigateOnboardingFlowWelcome() throws {
        XCTAssertTrue(staticTexts["Spezi\nTemplate Application"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(buttons["Learn More"].waitForExistence(timeout: 2))
        buttons["Learn More"].tap()
    }
    
    private func navigateOnboardingFlowInterestingModules() throws {
        XCTAssertTrue(staticTexts["Interesting Modules"].waitForExistence(timeout: 5))
        
        for _ in 1..<4 {
            XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
            buttons["Next"].tap()
        }
        
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
        buttons["Next"].tap()
    }
    
    private func navigateOnboardingAccount(email: String) throws {
        guard !buttons["Next"].waitForExistence(timeout: 5) else {
            buttons["Next"].tap()
            return
        }
        
        XCTAssertTrue(buttons["Signup"].waitForExistence(timeout: 2))
        buttons["Signup"].tap()

        XCTAssertTrue(staticTexts["Create a new Account"].waitForExistence(timeout: 2))
        
        try collectionViews.textFields["E-Mail Address"].enter(value: email)
        try collectionViews.secureTextFields["Password"].enter(value: "StanfordRocks")
        try textFields["enter first name"].enter(value: "Leland")
        try textFields["enter last name"].enter(value: "Stanford")

        XCTAssertTrue(collectionViews.buttons["Signup"].waitForExistence(timeout: 2))
        collectionViews.buttons["Signup"].tap()

        sleep(3)
        
        if staticTexts["HealthKit Access"].waitForExistence(timeout: 5) && navigationBars.buttons["Back"].waitForExistence(timeout: 5) {
            navigationBars.buttons["Back"].tap()
            
            XCTAssertTrue(staticTexts["Leland Stanford"].waitForExistence(timeout: 2))
            XCTAssertTrue(staticTexts[email].waitForExistence(timeout: 2))
            
            XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 2))
            buttons["Next"].tap()
        }
    }
    
    private func navigateOnboardingFlowConsent() throws {
        XCTAssertTrue(staticTexts["Consent"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(staticTexts["First Name"].waitForExistence(timeout: 2))
        try textFields["Enter your first name ..."].enter(value: "Leland")
        
        XCTAssertTrue(staticTexts["Last Name"].waitForExistence(timeout: 2))
        try textFields["Enter your last name ..."].enter(value: "Stanford")

        XCTAssertTrue(scrollViews["Signature Field"].waitForExistence(timeout: 2))
        scrollViews["Signature Field"].swipeRight()

        XCTAssertTrue(buttons["I Consent"].waitForExistence(timeout: 2))
        buttons["I Consent"].tap()
    }

    private func navigateOnboardingFlowHealthKitAccess() throws {
        XCTAssertTrue(staticTexts["HealthKit Access"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(buttons["Grant Access"].waitForExistence(timeout: 2))
        buttons["Grant Access"].tap()
        
        try handleHealthKitAuthorization()
    }
    
    private func navigateOnboardingFlowNotification() throws {
        XCTAssertTrue(staticTexts["Notifications"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(buttons["Allow Notifications"].waitForExistence(timeout: 2))
        buttons["Allow Notifications"].tap()
        
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alertAllowButton = springboard.buttons["Allow"]
        if alertAllowButton.waitForExistence(timeout: 5) {
           alertAllowButton.tap()
        }
    }
    
    fileprivate func assertOnboardingComplete() {
        let tabBar = tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.buttons["Schedule"].waitForExistence(timeout: 2))
        XCTAssertTrue(tabBar.buttons["Contacts"].waitForExistence(timeout: 2))
    }

    fileprivate func assertAccountInformation(email: String) throws {
        XCTAssertTrue(navigationBars.buttons["Your Account"].waitForExistence(timeout: 2))
        navigationBars.buttons["Your Account"].tap()

        XCTAssertTrue(staticTexts["Account Overview"].waitForExistence(timeout: 5.0))
        XCTAssertTrue(staticTexts["Leland Stanford"].exists)
        XCTAssertTrue(staticTexts[email].exists)
        XCTAssertTrue(staticTexts["Gender Identity, Choose not to answer"].exists)


        XCTAssertTrue(navigationBars.buttons["Close"].waitForExistence(timeout: 0.5))
        navigationBars.buttons["Close"].tap()

        XCTAssertTrue(navigationBars.buttons["Your Account"].waitForExistence(timeout: 2))
        navigationBars.buttons["Your Account"].tap()

        XCTAssertTrue(navigationBars.buttons["Edit"].waitForExistence(timeout: 2))
        navigationBars.buttons["Edit"].tap()

        usleep(500_00)
        XCTAssertFalse(navigationBars.buttons["Close"].exists)

        XCTAssertTrue(buttons["Delete Account"].waitForExistence(timeout: 2))
        buttons["Delete Account"].tap()

        let alert = "Are you sure you want to delete your account?"
        XCTAssertTrue(alerts[alert].waitForExistence(timeout: 6.0))
        alerts[alert].buttons["Delete"].tap()

        XCTAssertTrue(alerts["Authentication Required"].waitForExistence(timeout: 2.0))
        XCTAssertTrue(alerts["Authentication Required"].secureTextFields["Password"].waitForExistence(timeout: 0.5))
        typeText("StanfordRocks") // the password field has focus already
        XCTAssertTrue(alerts["Authentication Required"].buttons["Login"].waitForExistence(timeout: 0.5))
        alerts["Authentication Required"].buttons["Login"].tap()

        sleep(2)

        // Login
        try textFields["E-Mail Address"].enter(value: email)
        try secureTextFields["Password"].enter(value: "StanfordRocks")

        XCTAssertTrue(buttons["Login"].waitForExistence(timeout: 0.5))
        buttons["Login"].tap()

        XCTAssertTrue(alerts["Invalid Credentials"].waitForExistence(timeout: 2.0))
    }
}
