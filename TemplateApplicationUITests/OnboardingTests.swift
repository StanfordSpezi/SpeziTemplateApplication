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
        
        try app.navigateOnboardingFlow()
        
        try app.assertOnboardingComplete()
    }
    
    func testOnboardingFlowRepeated() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding"]
        
        try app.navigateOnboardingFlow()
        try app.assertOnboardingComplete()
        
        app.terminate()
        
        // Second onboarding round shouldn't display HealthKit and Notification authorizations anymore
        app.activate()
        
        try app.navigateOnboardingFlow(repeated: true)
        // Do not show HealthKit and Notification authorization view again
        try app.assertOnboardingComplete()
    }
}


extension XCUIApplication {
    func conductOnboardingIfNeeded() throws {
        let app = XCUIApplication()
        
        if app.staticTexts["Spezi\nTemplate Application"].waitForExistence(timeout: 5) {
            try app.navigateOnboardingFlow()
        }
    }
    
    fileprivate func navigateOnboardingFlow(repeated skippedIfRepeated: Bool = false) throws {
        try navigateOnboardingFlowWelcome()
        try navigateOnboardingFlowInterestingModules()
        if staticTexts["Consent Example"].waitForExistence(timeout: 5) {
            try navigateOnboardingFlowConsent()
        }
        try navigateOnboardingAccount()
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
    
    private func navigateOnboardingFlowConsent() throws {
        XCTAssertTrue(staticTexts["Consent Example"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(staticTexts["First Name"].waitForExistence(timeout: 2))
        try textFields["Enter your first name ..."].enter(value: "Leland")
        
        XCTAssertTrue(staticTexts["Last Name"].waitForExistence(timeout: 2))
        try textFields["Enter your last name ..."].enter(value: "Stanford")
        
        XCTAssertTrue(staticTexts["Leland Stanford"].waitForExistence(timeout: 2))
        staticTexts["Leland Stanford"].firstMatch.swipeUp()
        
        XCTAssertTrue(buttons["I Consent"].waitForExistence(timeout: 2))
        buttons["I Consent"].tap()
    }
    
    private func navigateOnboardingAccount() throws {
        XCTAssertTrue(staticTexts["Your Account"].waitForExistence(timeout: 5))
        
        guard !buttons["Next"].waitForExistence(timeout: 5) else {
            buttons["Next"].tap()
            return
        }
        
        XCTAssertTrue(buttons["Sign Up"].waitForExistence(timeout: 2))
        buttons["Sign Up"].tap()
        
        XCTAssertTrue(navigationBars.staticTexts["Sign Up"].waitForExistence(timeout: 2))
        
        XCTAssertTrue(buttons["Email and Password"].waitForExistence(timeout: 2))
        buttons["Email and Password"].tap()
        
        try textFields["Enter your email ..."].enter(value: "leland@stanford.edu")
        try secureTextFields["Enter your password ..."].enter(value: "StanfordRocks")
        try secureTextFields["Repeat your password ..."].enter(value: "StanfordRocks")
        try textFields["Enter your first name ..."].enter(value: "Leland")
        try textFields["Enter your last name ..."].enter(value: "Stanford")
        
        XCTAssertTrue(buttons["Sign Up"].waitForExistence(timeout: 2))
        collectionViews.buttons["Sign Up"].tap()
        
        sleep(3)
        
        if staticTexts["HealthKit Access"].waitForExistence(timeout: 5) && navigationBars.buttons["Back"].waitForExistence(timeout: 5) {
            navigationBars.buttons["Back"].tap()
            
            XCTAssertTrue(staticTexts["Leland Stanford"].waitForExistence(timeout: 2))
            XCTAssertTrue(staticTexts["leland@stanford.edu"].waitForExistence(timeout: 2))
            
            XCTAssertTrue(scrollViews.otherElements.buttons["Next"].waitForExistence(timeout: 2))
            scrollViews.otherElements.buttons["Next"].tap()
        }
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
    
    fileprivate func assertOnboardingComplete() throws {
        let tabBar = tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.buttons["Schedule"].waitForExistence(timeout: 2))
        XCTAssertTrue(tabBar.buttons["Contacts"].waitForExistence(timeout: 2))
        XCTAssertTrue(tabBar.buttons["Mock Web Service"].waitForExistence(timeout: 2))
    }
}
