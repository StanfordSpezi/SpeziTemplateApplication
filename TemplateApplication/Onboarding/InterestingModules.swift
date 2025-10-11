//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SpeziViews
import SwiftUI


struct InterestingModules: View {
    @Environment(ManagedNavigationStack.Path.self) private var managedNavigationPath
    
    
    var body: some View {
        SequentialOnboardingView(
            title: "Interesting Modules",
            subtitle: "INTERESTING_MODULES_SUBTITLE",
            steps: [
                SequentialOnboardingView.Step(
                    title: "Onboarding",
                    description: "INTERESTING_MODULES_AREA1_DESCRIPTION"
                ),
                SequentialOnboardingView.Step(
                    title: "HL7 FHIR",
                    description: "INTERESTING_MODULES_AREA2_DESCRIPTION"
                ),
                SequentialOnboardingView.Step(
                    title: "Contact",
                    description: "INTERESTING_MODULES_AREA3_DESCRIPTION"
                ),
                SequentialOnboardingView.Step(
                    title: "HealthKit Data Source",
                    description: "INTERESTING_MODULES_AREA4_DESCRIPTION"
                )
            ],
            actionText: "Next",
            action: {
                managedNavigationPath.nextStep()
            }
        )
    }
}


#if DEBUG
#Preview {
    ManagedNavigationStack {
        InterestingModules()
    }
}
#endif
