//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SwiftUI


struct TemplateSignUp: View {
    var body: some View {
        EmptyView()
        /*
        SignUp {
            IconView()
                .padding(.top, 32)
            Text("SIGN_UP_SUBTITLE")
                .multilineTextAlignment(.center)
                .padding()
            Spacer(minLength: 0)
        }
            .navigationBarTitleDisplayMode(.large)
         */
    }
}


#if DEBUG
struct TemplateSignUp_Previews: PreviewProvider {
    static var previews: some View {
        TemplateSignUp()
            .environmentObject(Account())
    }
}
#endif
