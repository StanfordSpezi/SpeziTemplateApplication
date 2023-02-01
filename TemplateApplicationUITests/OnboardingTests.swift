//
// This source file is part of the Stanford CardinalKit Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTHealthKit


class OnboardingTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }
    
    
    func testOnboardingFlow() throws {
        let app = XCUIApplication()
        app.launchArguments = ["--showOnboarding"]
        app.deleteAndLaunch(withSpringboardAppName: "TemplateApplication")
        
        try OnboardingTests.navigateOnboardingFlow()
        
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.buttons["Schedule"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(tabBar.buttons["Contacts"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(tabBar.buttons["Mock Upload"].waitForExistence(timeout: 0.5))
    }
}


extension OnboardingTests {
    static func conductOnboardingIfNeeded() throws {
        let app = XCUIApplication()
        
        if app.staticTexts["CardinalKit\nTemplate Application"].waitForExistence(timeout: 0.5) {
            try OnboardingTests.navigateOnboardingFlow()
        }
    }
    
    private static func navigateOnboardingFlow() throws {
        try navigateOnboardingFlowWelcome()
        try navigateOnboardingFlowInterestingModules()
        try navigateOnboardingFlowConsent()
        try navigateOnboardingFlowHealthKitAccess()
    }
    
    private static func navigateOnboardingFlowWelcome() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.staticTexts["CardinalKit\nTemplate Application"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["This application demonstrates several CardinalKit features & modules."]
                .waitForExistence(timeout: 0.5)
        )
        
        XCTAssertTrue(app.staticTexts["The CardinalKit Framework"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["The CardinalKit Framework builds the foundation of this template application."]
                .waitForExistence(timeout: 0.5)
        )
        
        XCTAssertTrue(app.staticTexts["Swift Package Manager"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["CardinalKit uses the Swift Package Manager to import it as a dependency."]
                .waitForExistence(timeout: 0.5)
        )
        
        XCTAssertTrue(app.staticTexts["CardinalKit Modules"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["CardinalKit offers several modules including HealthKit integration, questionnaires, and more ..."]
                .waitForExistence(timeout: 0.5)
        )
        
        XCTAssertTrue(app.buttons["Learn More"].waitForExistence(timeout: 0.5))
        app.buttons["Learn More"].tap()
    }
    
    private static func navigateOnboardingFlowInterestingModules() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.staticTexts["Interesting Modules"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["Here are a few CardinalKit modules that are interesting to know about ..."]
                .waitForExistence(timeout: 0.5)
        )
        
        XCTAssertTrue(app.staticTexts["Onboarding"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["The onboarding module allows you to build an onboarding flow like this one."]
                .waitForExistence(timeout: 0.5)
        )
        XCTAssertTrue(app.buttons["Next"].waitForExistence(timeout: 0.5))
        app.buttons["Next"].tap()
        
        XCTAssertTrue(app.staticTexts["FHIR"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["The FHIR module provides a CardinalKit standard that can be used as a communication standard between modules."]
                .waitForExistence(timeout: 0.5)
        )
        XCTAssertTrue(app.buttons["Next"].waitForExistence(timeout: 0.5))
        app.buttons["Next"].tap()
        
        XCTAssertTrue(app.staticTexts["Contact"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["The contact module allows you to display contact information in your application."]
                .waitForExistence(timeout: 0.5)
        )
        XCTAssertTrue(app.buttons["Next"].waitForExistence(timeout: 0.5))
        app.buttons["Next"].tap()
        
        XCTAssertTrue(app.staticTexts["HealthKit Data Source"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["The HealthKit data source module allows you to fetch data from HealthKit and e.g. transform it to FHIR resources."]
                .waitForExistence(timeout: 0.5)
        )
        
        XCTAssertTrue(app.buttons["Next"].waitForExistence(timeout: 0.5))
        app.buttons["Next"].tap()
    }
    
    private static func navigateOnboardingFlowConsent() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.staticTexts["Consent Example"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["CardinalKit can collect consent from a user. You can provide the consent document using a markdown file."]
                .waitForExistence(timeout: 0.5)
        )
        XCTAssertTrue(
            app.staticTexts["CardinalKit can render consent documents in the markdown format: This is a markdown example.\n"]
                .waitForExistence(timeout: 0.5)
        )
        
        XCTAssertTrue(app.staticTexts["Given Name"].waitForExistence(timeout: 0.5))
        app.staticTexts["Given Name"].tap()
        app.textFields["Enter your given name ..."].typeText("Leland")
        
        XCTAssertTrue(app.staticTexts["Family Name"].waitForExistence(timeout: 0.5))
        app.staticTexts["Family Name"].tap()
        app.textFields["Enter your family name ..."].typeText("Stanford")
        
        app.staticTexts["Given Name"].swipeUp()
        
        XCTAssertTrue(app.staticTexts["Leland Stanford"].waitForExistence(timeout: 0.5))
        app.staticTexts["Leland Stanford"].swipeUp()
        
        XCTAssertTrue(app.buttons["I Consent"].waitForExistence(timeout: 0.5))
        app.buttons["I Consent"].tap()
    }
    
    private static func navigateOnboardingFlowHealthKitAccess() throws {
        let app = XCUIApplication()
        
        XCTAssertTrue(app.staticTexts["HealthKit Access"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(
            app.staticTexts["CardinalKit can access data from HealthKit using the HealthKitDataSource module."].waitForExistence(timeout: 0.5)
        )
        XCTAssertTrue(app.images["heart.text.square.fill"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.buttons["Grant Access"].waitForExistence(timeout: 0.5))
        
        app.buttons["Grant Access"].tap()
        
        try app.handleHealthKitAuthorization()
    }
}
