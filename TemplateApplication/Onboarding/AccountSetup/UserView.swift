//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziFirebaseAccount
import SpeziViews
import SwiftUI


struct UserView: View {
    @EnvironmentObject private var account: Account
    // TODO @EnvironmentObject private var firebaseAccountConfiguration: FirebaseAccountConfiguration
    
    
    var body: some View {
        userInformation
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .shadow(color: .gray, radius: 2)
            )
    }
    
    
    @ViewBuilder private var userInformation: some View {
        HStack(spacing: 16) {
            if let details = account.details,
               let name = details.name {
                UserProfileView(name: name)
                    .frame(height: 30)
                VStack(alignment: .leading, spacing: 4) {
                    Text(name.formatted(.name(style: .medium)))
                    Text(details.userId)
                }
                Spacer()
            } else {
                Spacer()
                VStack(spacing: 16) {
                    ProgressView()
                    Text("USER_VIEW_LOADING")
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
        }
    }
}


#if DEBUG
struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .padding()
            .environmentObject(Account())
            // TODO .environmentObject(FirebaseAccountConfiguration(emulatorSettings: (host: "localhost", port: 9099)))
    }
}
#endif
