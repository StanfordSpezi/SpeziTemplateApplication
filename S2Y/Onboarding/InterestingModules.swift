//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI


struct InterestingModules: View {
    var body: some View {
        OnboardingView(
            header: {
                OnboardingTitleView(
                    title: "Interesting Modules",
                    subtitle: "INTERESTING_MODULES_SUBTITLE"
                )
            },
            content: {
                SequentialOnboardingView(
                    title: "Interesting Modules",
                    subtitle: "INTERESTING_MODULES_SUBTITLE",
                    steps: [
                        .init(title: "Onboarding", description: "INTERESTING_MODULES_AREA1_DESCRIPTION"),
                        .init(title: "HL7 FHIR", description: "INTERESTING_MODULES_AREA2_DESCRIPTION"),
                        .init(title: "Contact", description: "INTERESTING_MODULES_AREA3_DESCRIPTION"),
                        .init(title: "HealthKit Data Source", description: "INTERESTING_MODULES_AREA4_DESCRIPTION")
                    ],
                    actionText: "Next",
                    action: {}
                )
            },
            footer: {
                OnboardingActionsView("Next", action: {})
            }
        )
    }
}


#if DEBUG
#Preview {
    InterestingModules()
}
#endif
