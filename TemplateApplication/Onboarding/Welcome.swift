//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI


struct Welcome: View {
    @EnvironmentObject private var onboardingNavigationPath: OnboardingNavigationPath
    
    
    var body: some View {
        OnboardingView(
            title: "WELCOME_TITLE".moduleLocalized,
            subtitle: "WELCOME_SUBTITLE".moduleLocalized,
            areas: [
                .init(
                    icon: Image(systemName: "apps.iphone"),
                    title: "WELCOME_AREA1_TITLE".moduleLocalized,
                    description: "WELCOME_AREA1_DESCRIPTION".moduleLocalized
                ),
                .init(
                    icon: Image(systemName: "shippingbox.fill"),
                    title: "WELCOME_AREA2_TITLE".moduleLocalized,
                    description: "WELCOME_AREA2_DESCRIPTION".moduleLocalized
                ),
                .init(
                    icon: Image(systemName: "list.bullet.clipboard.fill"),
                    title: "WELCOME_AREA3_TITLE".moduleLocalized,
                    description: "WELCOME_AREA3_DESCRIPTION".moduleLocalized
                )
            ],
            actionText: "WELCOME_BUTTON".moduleLocalized,
            action: {
                onboardingNavigationPath.nextStep()
            }
        )
    }
}


#if DEBUG
struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStack(startAtStep: Welcome.self) {
            for onboardingView in OnboardingFlow.previewSimulatorViews {
                onboardingView
            }
        }
    }
}
#endif
