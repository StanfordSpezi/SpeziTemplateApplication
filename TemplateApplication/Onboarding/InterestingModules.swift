//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI


struct InterestingModules: View {
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    
    var body: some View {
        SequentialOnboardingView(
            title: "INTERESTING_MODULES_TITLE",
            subtitle: "INTERESTING_MODULES_SUBTITLE",
            content: [
                SequentialOnboardingView.Content(
                    title: "INTERESTING_MODULES_AREA1_TITLE",
                    description: "INTERESTING_MODULES_AREA1_DESCRIPTION"
                ),
                SequentialOnboardingView.Content(
                    title: "INTERESTING_MODULES_AREA2_TITLE",
                    description: "INTERESTING_MODULES_AREA2_DESCRIPTION"
                ),
                SequentialOnboardingView.Content(
                    title: "INTERESTING_MODULES_AREA3_TITLE",
                    description: "INTERESTING_MODULES_AREA3_DESCRIPTION"
                ),
                SequentialOnboardingView.Content(
                    title: "INTERESTING_MODULES_AREA4_TITLE",
                    description: "INTERESTING_MODULES_AREA4_DESCRIPTION"
                )
            ],
            actionText: "INTERESTING_MODULES_BUTTON",
            action: {
                onboardingNavigationPath.nextStep()
            }
        )
    }
}


#if DEBUG
#Preview {
    OnboardingStack(startAtStep: InterestingModules.self) {
        for onboardingView in OnboardingFlow.previewSimulatorViews {
            onboardingView
        }
    }
}
#endif
