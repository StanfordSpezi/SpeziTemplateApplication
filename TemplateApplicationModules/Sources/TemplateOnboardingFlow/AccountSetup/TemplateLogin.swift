//
// This source file is part of the Stanford CardinalKit Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Account
import Onboarding
import SwiftUI


struct TemplateLogin: View {
    var body: some View {
        Login {
            OnboardingTitleView(
                title: "LOGIN_UP_TITLE",
                subtitle: "LOGIN_UP_SUBTITLE"
            )
            Spacer()
        }
    }
}


#if DEBUG
struct TemplateLogin_Previews: PreviewProvider {
    static var previews: some View {
        TemplateLogin()
    }
}
#endif
