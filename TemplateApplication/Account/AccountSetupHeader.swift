//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

@_spi(TestingSupport) import SpeziAccount
import SwiftUI


struct AccountSetupHeader: View {
    @Environment(Account.self) private var account
    @Environment(\.accountSetupState) private var setupState
    
    
    var body: some View {
        VStack {
            Text("Your Account")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
                .padding(.top, 30)
            Text("ACCOUNT_SUBTITLE")
                .padding(.bottom, 8)
            if account.signedIn, case .presentingExistingAccount = setupState {
                Text("ACCOUNT_SIGNED_IN_DESCRIPTION")
            } else {
                Text("ACCOUNT_SETUP_DESCRIPTION")
            }
        }
            .multilineTextAlignment(.center)
    }
}


#if DEBUG
#Preview {
    AccountSetupHeader()
        .previewWith {
            AccountConfiguration(service: InMemoryAccountService())
        }
}
#endif
