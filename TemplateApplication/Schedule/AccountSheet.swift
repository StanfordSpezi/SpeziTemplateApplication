//
//  AccountSheet.swift
//  TemplateApplication
//
//  Created by Andreas Bauer on 02.09.23.
//

import SpeziAccount
import SwiftUI

struct AccountSheet: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var account: Account

    @State var overviewIsEditing = false

    var body: some View {
        NavigationStack {
            ZStack {
                if account.signedIn {
                    AccountOverview(isEditing: $overviewIsEditing)
                } else {
                    AccountSetup()
                }
            }
                .toolbar {
                    if !overviewIsEditing {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") { // TODO translation
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
