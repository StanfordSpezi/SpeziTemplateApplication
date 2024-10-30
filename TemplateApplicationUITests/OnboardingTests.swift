//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions
import XCTHealthKit
import XCTSpeziAccount
import XCTSpeziNotifications


class OnboardingTests: XCTestCase {
    @MainActor
    override func setUp() async throws {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "TemplateApplication")
    }
    

    @MainActor
    func testOnboardingFlow() throws {
        let app = XCUIApplication()
        let email = "leland@onboarding.stanford.edu"
        
        try app.navigateOnboardingFlow(email: email)

        app.assertOnboardingComplete()
        try app.assertAccountInformation(email: email)
    }

    @MainActor
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
    fileprivate func navigateOnboardingFlow(
        email: String = "leland@stanford.edu",
        repeated skippedIfRepeated: Bool = false
    ) throws {
        try navigateOnboardingFlowWelcome()
        try navigateOnboardingFlowInterestingModules()
        if staticTexts["Your Account"].waitForExistence(timeout: 2.0) {
            try navigateOnboardingAccount(email: email)
        }
        if staticTexts["Consent"].waitForExistence(timeout: 2.0) {
            try navigateOnboardingFlowConsent()
        }
        if !skippedIfRepeated {
            try navigateOnboardingFlowHealthKitAccess()
            try navigateOnboardingFlowNotification()
        }
    }
    
    private func navigateOnboardingFlowWelcome() throws {
        XCTAssertTrue(staticTexts["Spezi\nTemplate Application"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(buttons["Learn More"].exists)
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
        if buttons["Logout"].exists {
            buttons["Logout"].tap()
        }
        
        XCTAssertTrue(buttons["Signup"].exists)
        buttons["Signup"].tap()


        XCTAssertTrue(staticTexts["Create a new Account"].waitForExistence(timeout: 2))

        try fillSignupForm(email: email, password: "StanfordRocks", name: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))

        XCTAssertTrue(collectionViews.buttons["Signup"].exists)
        collectionViews.buttons["Signup"].tap()

        if staticTexts["Consent"].waitForExistence(timeout: 4.0) && navigationBars.buttons["Back"].exists {
            navigationBars.buttons["Back"].tap()
            
            XCTAssertTrue(staticTexts["Leland Stanford"].waitForExistence(timeout: 2))
            XCTAssertTrue(staticTexts[email].exists)

            XCTAssertTrue(buttons["Next"].exists)
            buttons["Next"].tap()
        }
    }
    
    private func navigateOnboardingFlowConsent() throws {
        XCTAssertTrue(staticTexts["Consent"].waitForExistence(timeout: 2))

        XCTAssertTrue(staticTexts["First Name"].exists)
        try textFields["Enter your first name ..."].enter(value: "Leland")
        
        XCTAssertTrue(staticTexts["Last Name"].exists)
        try textFields["Enter your last name ..."].enter(value: "Stanford")

        XCTAssertTrue(scrollViews["Signature Field"].exists)
        scrollViews["Signature Field"].swipeRight()

        XCTAssertTrue(buttons["I Consent"].exists)
        buttons["I Consent"].tap()
    }

    private func navigateOnboardingFlowHealthKitAccess() throws {
        XCTAssertTrue(staticTexts["HealthKit Access"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(buttons["Grant Access"].exists)
        buttons["Grant Access"].tap()
        
        try handleHealthKitAuthorization()
    }
    
    private func navigateOnboardingFlowNotification() throws {
        XCTAssertTrue(staticTexts["Notifications"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(buttons["Allow Notifications"].exists)
        buttons["Allow Notifications"].tap()

        confirmNotificationAuthorization(action: .allow)
    }
    
    fileprivate func assertOnboardingComplete() {
        let tabBar = tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.buttons["Schedule"].waitForExistence(timeout: 2))
        XCTAssertTrue(tabBar.buttons["Contacts"].exists)
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

        XCTAssertTrue(navigationBars.buttons["Close"].waitForNonExistence(timeout: 0.5))

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

        try login(email: email, password: "StanfordRocks")

        XCTAssertTrue(alerts["Invalid Credentials"].waitForExistence(timeout: 2.0))
    }
}
