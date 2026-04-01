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


/// Introduction to your app's features during onboarding.
///
/// The Welcome view can provide first time users with important information about your app.
///
/// You can learn more about [Spezi Onboarding in the GitHub repository](https://github.com/StanfordSpezi/SpeziOnboarding)
///
/// ![A screenshot of the Welcome screen](Welcome)
struct Welcome: View {
    @Environment(ManagedNavigationStack.Path.self) private var managedNavigationPath
    
    var body: some View {
        OnboardingView(
            title: "Spezi Template Application",
            subtitle: "WELCOME_SUBTITLE",
            areas: [
                OnboardingInformationView.Area(
                    icon: {
                        Image(systemName: "apps.iphone")
                            .accessibilityHidden(true)
                    },
                    title: "The Spezi Framework",
                    description: "WELCOME_AREA1_DESCRIPTION"
                ),
                OnboardingInformationView.Area(
                    icon: {
                        Image(systemName: "shippingbox.fill")
                            .accessibilityHidden(true)
                    },
                    title: "Swift Package Manager",
                    description: "WELCOME_AREA2_DESCRIPTION"
                ),
                OnboardingInformationView.Area(
                    icon: {
                        Image(systemName: "list.bullet.clipboard.fill")
                            .accessibilityHidden(true)
                    },
                    title: "Spezi Modules",
                    description: "WELCOME_AREA3_DESCRIPTION"
                )
            ],
            actionText: "Learn More",
            action: {
                managedNavigationPath.nextStep()
            }
        )
        .padding(.top, 24)
    }
}


#Preview {
    ManagedNavigationStack {
        Welcome()
    }
}
