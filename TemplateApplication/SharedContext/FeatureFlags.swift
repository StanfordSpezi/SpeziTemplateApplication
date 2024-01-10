//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

/// A collection of feature flags for the Template Application.
enum FeatureFlags {
    /// Skips the onboarding flow to enable easier development of features in the application and to allow UI tests to skip the onboarding flow.
    static let skipOnboarding = CommandLine.arguments.contains("--skipOnboarding")
    /// Always show the onboarding when the application is launched. Makes it easy to modify and test the onboarding flow without the need to manually remove the application or reset the simulator.
    static let showOnboarding = CommandLine.arguments.contains("--showOnboarding")
    /// Disables the Firebase interactions, including the login/sign-up step and the Firebase Firestore upload.
    static let disableFirebase = CommandLine.arguments.contains("--disableFirebase")
    #if targetEnvironment(simulator)
    /// Defines if the application should connect to the local firebase emulator. Always set to true when using the iOS simulator.
    static let useFirebaseEmulator = true
    #else
    /// Defines if the application should connect to the local firebase emulator. Always set to true when using the iOS simulator.
    static let useFirebaseEmulator = CommandLine.arguments.contains("--useFirebaseEmulator")
    #endif
    /// Adds a test task to the schedule at the current time
    static let testSchedule = CommandLine.arguments.contains("--testSchedule")
}
