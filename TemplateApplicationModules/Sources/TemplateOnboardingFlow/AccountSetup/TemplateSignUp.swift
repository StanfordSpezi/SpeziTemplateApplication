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


struct TemplateSignUp: View {
    var body: some View {
        SignUp {
            OnboardingTitleView(
                title: "SIGN_UP_TITLE",
                subtitle: "SIGN_UP_SUBTITLE"
            )
            Spacer()
        }
    }
}


#if DEBUG
struct TemplateSignUp_Previews: PreviewProvider {
    static var previews: some View {
        TemplateSignUp()
    }
}
#endif
