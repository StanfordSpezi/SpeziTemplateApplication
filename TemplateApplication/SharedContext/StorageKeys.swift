//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

/// Constants shared across the Spezi Teamplate Application to access storage information including the `AppStorage` and `SceneStorage`
enum StorageKeys {
    // MARK: - Onboarding
    /// A `Bool` flag indicating of the onboarding was completed.
    static let onboardingFlowComplete = "onboardingFlow.complete"
    
    // MARK: - Home
    /// The currently selected home tab.
    static let homeTabSelection = "home.tabselection"
    /// The TabView customization on iPadOS
    static let tabViewCustomization = "home.tab-view-customization"
}
