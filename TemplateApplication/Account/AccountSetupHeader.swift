//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SwiftUI


struct AccountSetupHeader: View {
    @EnvironmentObject private var account: Account
    @Environment(\._accountSetupState) private var setupState
    
    
    var body: some View {
        VStack {
            Text("ACCOUNT_TITLE")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
                .padding(.top, 30)
            Text("ACCOUNT_SUBTITLE")
                .padding(.bottom, 8)
            if account.signedIn, case .generic = setupState {
                Text("ACCOUNT_SIGNED_IN_DESCRIPTION")
            } else {
                Text("ACCOUNT_SETUP_DESCRIPTION")
            }
        }
            .multilineTextAlignment(.center)
    }
}


#if DEBUG
struct AccountSetupHeader_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetupHeader()
            .environmentObject(Account())
    }
}
#endif
