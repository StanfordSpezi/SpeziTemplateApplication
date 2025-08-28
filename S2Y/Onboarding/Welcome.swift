//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI


struct Welcome: View {
    var body: some View {
        OnboardingView(
            header: {
                OnboardingTitleView(
                    title: "Spezi Template Application",
                    subtitle: "WELCOME_SUBTITLE"
                )
            },
            content: {
                OnboardingInformationView(
                    areas: [
                        .init(
                            icon: {
                                Image(systemName: "apps.iphone").accessibilityHidden(true)
                            },
                            title: "The Spezi Framework",
                            description: "WELCOME_AREA1_DESCRIPTION"
                        ),
                        .init(
                            icon: {
                                Image(systemName: "shippingbox.fill").accessibilityHidden(true)
                            },
                            title: "Swift Package Manager",
                            description: "WELCOME_AREA2_DESCRIPTION"
                        ),
                        .init(
                            icon: {
                                Image(systemName: "list.bullet.clipboard.fill").accessibilityHidden(true)
                            },
                            title: "Spezi Modules",
                            description: "WELCOME_AREA3_DESCRIPTION"
                        )
                    ]
                )
            },
            footer: {
                OnboardingActionsView("Continue", action: {})
            }
        )
        .padding(.top, 24)
    }
}


#if DEBUG
#Preview {
    Welcome()
}
#endif
