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
    
    @State var overviewIsEditing = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                if account.signedIn {
                    AccountOverview(isEditing: $overviewIsEditing) {
                        NavigationLink {
                            ContributionsList()
                        } label: {
                            Text("License Information")
                        }
                    }
                        .onDisappear {
                            overviewIsEditing = false
                        }
                } else {
                    AccountSetup(header: {
                        AccountSetupHeader()
                    })
                }
            }
                .onChange(of: account.signedIn) { newValue in
                    if newValue {
                        dismiss() // we just signed in, dismiss the account setup sheet
                    }
                }
                .toolbar {
                    if !overviewIsEditing && (account.signedIn || !accountRequired) {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("CLOSE") {
                                dismiss()
                            }
                        }
                    }
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
