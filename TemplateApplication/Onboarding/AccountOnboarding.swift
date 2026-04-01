//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

@_spi(TestingSupport) import SpeziAccount
import SpeziOnboarding
import SpeziViews
import SwiftUI


struct AccountOnboarding: View {
    @Environment(ManagedNavigationStack.Path.self) private var managedNavigationPath
    
    
    var body: some View {
        AccountSetup { _ in
            Task {
                // Placing the nextStep() call inside this task will ensure that the sheet dismiss animation is
                // played till the end before we navigate to the next step.
                managedNavigationPath.nextStep()
            }
        } header: {
            AccountSetupHeader()
        } continue: {
            OnboardingActionsView(
                "Next",
                action: {
                    managedNavigationPath.nextStep()
                }
            )
        }
        .navigationTitle(Text(verbatim: ""))
        .toolbar(.visible)
    }
}


#Preview("Account Onboarding SignIn") {
    ManagedNavigationStack {
        AccountOnboarding()
    }
    .previewWith {
        AccountConfiguration(service: InMemoryAccountService())
    }
}

#Preview("Account Onboarding") {
    var details = AccountDetails()
    details.userId = "lelandstanford@stanford.edu"
    details.name = PersonNameComponents(givenName: "Leland", familyName: "Stanford")
    
    return ManagedNavigationStack {
        AccountOnboarding()
    }
    .previewWith {
        AccountConfiguration(service: InMemoryAccountService(), activeDetails: details)
    }
}
