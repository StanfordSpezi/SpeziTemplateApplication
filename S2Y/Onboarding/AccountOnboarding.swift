//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

@_spi(TestingSupport) import SpeziAccount
import SpeziOnboarding
import SwiftUI


struct AccountOnboarding: View {
    var body: some View {
        OnboardingView(
            header: {
                AccountSetupHeader()
            },
            content: {
                AccountSetup { _ in }
            },
            footer: {
                OnboardingActionsView("Done", action: {})
            }
        )
    }
}


#if DEBUG
#Preview("Account Onboarding SignIn") {
    AccountOnboarding()
        .previewWith {
            AccountConfiguration(service: InMemoryAccountService())
        }
}

#Preview("Account Onboarding") {
    var details = AccountDetails()
    details.userId = "lelandstanford@stanford.edu"
    details.name = PersonNameComponents(givenName: "Leland", familyName: "Stanford")
    
    return AccountOnboarding()
        .previewWith {
            AccountConfiguration(service: InMemoryAccountService(), activeDetails: details)
        }
}
#endif
