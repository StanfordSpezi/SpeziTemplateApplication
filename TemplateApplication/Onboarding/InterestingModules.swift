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


/// Feature the core components of your app.
///
/// Use the InterestingModules view to highlight the Spezi modules used to achieve your app's core functionality.
///
/// You can learn more about [Spezi Onboarding in the GitHub repository](https://github.com/StanfordSpezi/SpeziOnboarding)
///
/// ![A screenshot of the InterestingModules screen](InterestingModules)
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


#Preview {
    ManagedNavigationStack {
        InterestingModules()
    }
}
