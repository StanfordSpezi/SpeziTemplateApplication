//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziOnboarding
import SwiftUI


struct AccountOnboarding: View {
    @Environment(Account.self) private var account
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    
    var body: some View {
        AccountSetup { _ in
            Task {
                // Placing the nextStep() call inside this task will ensure that the sheet dismiss animation is
                // played till the end before we navigate to the next step.
                onboardingNavigationPath.nextStep()
            }
        } header: {
            AccountSetupHeader()
        } continue: {
            OnboardingActionsView(
                "ACCOUNT_NEXT",
                action: {
                    onboardingNavigationPath.nextStep()
                }
            )
        }
    }
}


#if DEBUG
#Preview("Account Onboarding SignIn") {
    OnboardingStack(startAtStep: AccountOnboarding.self) {
        for onboardingView in OnboardingFlow.previewSimulatorViews {
            onboardingView
        }
    }
        .environment(Account(MockUserIdPasswordAccountService()))
}

#Preview("Account Onboarding") {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    return OnboardingStack(startAtStep: AccountOnboarding.self) {
        for onboardingView in OnboardingFlow.previewSimulatorViews {
            onboardingView
        }
    }
        .environment(Account(building: details, active: MockUserIdPasswordAccountService()))
}
#endif
