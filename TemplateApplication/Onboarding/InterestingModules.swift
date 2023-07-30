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
    @EnvironmentObject private var onboardingNavigationPath: OnboardingNavigationPath

    
    var body: some View {
        SequentialOnboardingView(
            title: "INTERESTING_MODULES_TITLE".moduleLocalized,
            subtitle: "INTERESTING_MODULES_SUBTITLE".moduleLocalized,
            content: [
                .init(
                    title: "INTERESTING_MODULES_AREA1_TITLE".moduleLocalized,
                    description: "INTERESTING_MODULES_AREA1_DESCRIPTION".moduleLocalized
                ),
                .init(
                    title: "INTERESTING_MODULES_AREA2_TITLE".moduleLocalized,
                    description: "INTERESTING_MODULES_AREA2_DESCRIPTION".moduleLocalized
                ),
                .init(
                    title: "INTERESTING_MODULES_AREA3_TITLE".moduleLocalized,
                    description: "INTERESTING_MODULES_AREA3_DESCRIPTION".moduleLocalized
                ),
                .init(
                    title: "INTERESTING_MODULES_AREA4_TITLE".moduleLocalized,
                    description: "INTERESTING_MODULES_AREA4_DESCRIPTION".moduleLocalized
                )
            ],
            actionText: "INTERESTING_MODULES_BUTTON".moduleLocalized,
            action: {
                #if targetEnvironment(simulator) && (arch(i386) || arch(x86_64))
                    print("PKCanvas view-related views are currently skipped on Intel-based iOS simulators due to a metal bug on the simulator.")
                    onboardingNavigationPath.append(AccountSetup.self)
                #else
                    onboardingNavigationPath.nextStep()
                #endif
            }
        )
    }
}


#if DEBUG
struct ThingsToKnow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStack(startAtStep: InterestingModules.self) {
            for onboardingView in OnboardingFlow.previewSimulatorViews {
                onboardingView
            }
        }
    }
}
#endif
