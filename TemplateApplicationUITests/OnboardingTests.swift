//
// This source file is part of the Stanford CardinalKit Template Application project
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
        
        try app.navigateOnboardingFlow(assertThatHealthKitConsentIsShown: true)
        
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.buttons["Schedule"].waitForExistence(timeout: 5))
        XCTAssertTrue(tabBar.buttons["Contacts"].waitForExistence(timeout: 5))
        XCTAssertTrue(tabBar.buttons["Mock Upload"].waitForExistence(timeout: 5))
    }
}


extension XCUIApplication {
    func conductOnboardingIfNeeded() throws {
        if self.staticTexts["CardinalKit\nTemplate Application"].waitForExistence(timeout: 5) {
            try navigateOnboardingFlow(assertThatHealthKitConsentIsShown: false)
        }
    }
    
    func navigateOnboardingFlow(assertThatHealthKitConsentIsShown: Bool = true) throws {
        try navigateOnboardingFlowWelcome()
        try navigateOnboardingFlowInterestingModules()
        if staticTexts["Consent Example"].waitForExistence(timeout: 5) {
            try navigateOnboardingFlowConsent()
        }
        try navigateOnboardingAccount()
        try navigateOnboardingFlowHealthKitAccess(assertThatHealthKitConsentIsShown: assertThatHealthKitConsentIsShown)
    }
    
    private func navigateOnboardingFlowWelcome() throws {
        XCTAssertTrue(staticTexts["CardinalKit\nTemplate Application"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["This application demonstrates several CardinalKit features & modules."]
                .waitForExistence(timeout: 5)
        )
        
        XCTAssertTrue(staticTexts["The CardinalKit Framework"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["The CardinalKit Framework builds the foundation of this template application."]
                .waitForExistence(timeout: 5)
        )
        
        XCTAssertTrue(staticTexts["Swift Package Manager"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["CardinalKit uses the Swift Package Manager to import it as a dependency."]
                .waitForExistence(timeout: 5)
        )
        
        XCTAssertTrue(staticTexts["CardinalKit Modules"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["CardinalKit offers several modules including HealthKit integration, questionnaires, and more ..."]
                .waitForExistence(timeout: 5)
        )
        
        XCTAssertTrue(buttons["Learn More"].waitForExistence(timeout: 5))
        buttons["Learn More"].tap()
    }
    
    private func navigateOnboardingFlowInterestingModules() throws {
        XCTAssertTrue(staticTexts["Interesting Modules"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["Here are a few CardinalKit modules that are interesting to know about ..."]
                .waitForExistence(timeout: 5)
        )
        
        XCTAssertTrue(staticTexts["Onboarding"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["The onboarding module allows you to build an onboarding flow like this one."]
                .waitForExistence(timeout: 5)
        )
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 5))
        buttons["Next"].tap()
        
        XCTAssertTrue(staticTexts["FHIR"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["The FHIR module provides a CardinalKit standard that can be used as a communication standard between modules."]
                .waitForExistence(timeout: 5)
        )
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 5))
        buttons["Next"].tap()
        
        XCTAssertTrue(staticTexts["Contact"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["The contact module allows you to display contact information in your application."]
                .waitForExistence(timeout: 5)
        )
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 5))
        buttons["Next"].tap()
        
        XCTAssertTrue(staticTexts["HealthKit Data Source"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["The HealthKit data source module allows you to fetch data from HealthKit and e.g. transform it to FHIR resources."]
                .waitForExistence(timeout: 5)
        )
        
        XCTAssertTrue(buttons["Next"].waitForExistence(timeout: 5))
        buttons["Next"].tap()
    }
    
    private func navigateOnboardingFlowConsent() throws {
        XCTAssertTrue(staticTexts["Consent Example"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["CardinalKit can collect consent from a user. You can provide the consent document using a markdown file."]
                .waitForExistence(timeout: 5)
        )
        XCTAssertTrue(
            staticTexts["CardinalKit can render consent documents in the markdown format: This is a markdown example.\n"]
                .waitForExistence(timeout: 5)
        )
        
        XCTAssertTrue(staticTexts["Given Name"].waitForExistence(timeout: 5))
        try textFields["Enter your given name ..."].enter(value: "Leland")
        textFields["Enter your given name ..."].typeText("\n")
        
        XCTAssertTrue(staticTexts["Family Name"].waitForExistence(timeout: 5))
        try textFields["Enter your family name ..."].enter(value: "Stanford")
        textFields["Enter your family name ..."].typeText("\n")
        
        XCTAssertTrue(staticTexts["Leland Stanford"].waitForExistence(timeout: 5))
        staticTexts["Leland Stanford"].firstMatch.swipeUp()
        
        XCTAssertTrue(buttons["I Consent"].waitForExistence(timeout: 5))
        buttons["I Consent"].tap()
    }
    
    private func navigateOnboardingAccount() throws {
        XCTAssertTrue(staticTexts["Your Account"].waitForExistence(timeout: 5))
        
        guard !buttons["Next"].waitForExistence(timeout: 5) else {
            buttons["Next"].tap()
            return
        }
        
        XCTAssertTrue(buttons["Sign Up"].waitForExistence(timeout: 5))
        buttons["Sign Up"].tap()
        
        XCTAssertTrue(navigationBars.staticTexts["Sign Up"].waitForExistence(timeout: 5))
        XCTAssertTrue(images["App Icon"].waitForExistence(timeout: 5))
        XCTAssertTrue(buttons["Email and Password"].waitForExistence(timeout: 5))
        
        buttons["Email and Password"].tap()
        
        try textFields["Enter your email ..."].enter(value: "leland@stanford.edu")
        textFields["Enter your email ..."].typeText("\n")
        
        try secureTextFields["Enter your password ..."].enter(value: "StanfordRocks!")
        secureTextFields["Enter your password ..."].typeText("\n")
        
        try secureTextFields["Repeat your password ..."].enter(value: "StanfordRocks!")
        secureTextFields["Repeat your password ..."].typeText("\n")
        
        try textFields["Enter your given name ..."].enter(value: "Leland")
        textFields["Enter your given name ..."].typeText("\n")
        
        try textFields["Enter your family name ..."].enter(value: "Stanford")
        textFields["Enter your family name ..."].typeText("\n")
        
        collectionViews.buttons["Sign Up"].tap()
        
        XCTAssertTrue(navigationBars["Sign Up"].buttons["Back"].waitForExistence(timeout: 5))
        
        XCTAssertTrue(staticTexts["Leland Stanford"].waitForExistence(timeout: 5))
        XCTAssertTrue(staticTexts["leland@stanford.edu"].waitForExistence(timeout: 5))
        XCTAssertTrue(scrollViews.otherElements.buttons["Next"].waitForExistence(timeout: 5))
        scrollViews.otherElements.buttons["Next"].tap()
    }
    
    private func navigateOnboardingFlowHealthKitAccess(assertThatHealthKitConsentIsShown: Bool = true) throws {
        XCTAssertTrue(staticTexts["HealthKit Access"].waitForExistence(timeout: 5))
        XCTAssertTrue(
            staticTexts["CardinalKit can access data from HealthKit using the HealthKitDataSource module."].waitForExistence(timeout: 5)
        )
        XCTAssertTrue(images["heart.text.square.fill"].waitForExistence(timeout: 5))
        XCTAssertTrue(buttons["Grant Access"].waitForExistence(timeout: 5))
        
        buttons["Grant Access"].tap()
        
        try handleHealthKitAuthorization()
    }
}