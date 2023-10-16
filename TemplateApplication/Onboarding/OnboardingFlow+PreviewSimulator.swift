//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// Defines onboarding views that are shown in the Xcode preview simulator
extension OnboardingFlow {
    static let previewSimulatorViews: [any View] = {
        [Welcome(), InterestingModules(), AccountOnboarding(), Consent(), HealthKitPermissions(), NotificationPermissions()]
    }()
}
