//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SwiftUI


struct AccountSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var account: Account
    @Environment(\.accountRequired) var accountRequired
    
    @State var isInSetup = false
    @State var overviewIsEditing = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                if account.signedIn && !isInSetup {
                    AccountOverview(isEditing: $overviewIsEditing) {
                        NavigationLink {
                            ContributionsList()
                        } label: {
                            Text("LICENSE_INFO_TITLE")
                        }
                    }
                        .onDisappear {
                            overviewIsEditing = false
                        }
                        .toolbar {
                            if !overviewIsEditing {
                                closeButton
                            }
                        }
                } else {
                    AccountSetup { _ in
                        dismiss() // we just signed in, dismiss the account setup sheet
                    } header: {
                        AccountSetupHeader()
                    }
                        .onAppear {
                            isInSetup = true
                        }
                        .toolbar {
                            if !accountRequired {
                                closeButton
                            }
                        }
                }
            }
        }
    }

    var closeButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("CLOSE") {
                dismiss()
            }
        }
    }
}


struct AccountSheet_Previews: PreviewProvider {
    static let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    static var previews: some View {
        AccountSheet()
            .environmentObject(Account(building: details, active: MockUserIdPasswordAccountService()))
        
        AccountSheet()
            .environmentObject(Account(MockUserIdPasswordAccountService()))
    }
}
