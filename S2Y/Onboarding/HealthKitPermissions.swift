//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziHealthKit
import SpeziOnboarding
import SwiftUI


struct HealthKitPermissions: View {
    @Environment(HealthKit.self) private var healthKit
    // OnboardingNavigationPath removed in SpeziOnboarding 2.x
    
    @State private var healthKitProcessing = false
    
    
    var body: some View {
        OnboardingView(
            header: {
                OnboardingTitleView(
                    title: "HealthKit Access",
                    subtitle: "HEALTHKIT_PERMISSIONS_SUBTITLE"
                )
            },
            content: {
                VStack {
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    Text("HEALTHKIT_PERMISSIONS_DESCRIPTION")
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                    Spacer()
                }
            }, footer: {
                OnboardingActionsView(
                    "Grant Access",
                    action: {
                        do {
                            healthKitProcessing = true
                            // HealthKit is not available in the preview simulator.
                            if ProcessInfo.processInfo.isPreviewSimulator {
                                try await _Concurrency.Task.sleep(for: .seconds(5))
                            } else {
                                try await healthKit.askForAuthorization()
                            }
                        } catch {
                            print("Could not request HealthKit permissions.")
                        }
                        healthKitProcessing = false
                    }
                )
            }
        )
            .navigationBarBackButtonHidden(healthKitProcessing)
            // Small fix as otherwise "Login" or "Sign up" is still shown in the nav bar
            .navigationTitle(Text(verbatim: ""))
    }
}


#if DEBUG
#Preview {
    HealthKitPermissions()
        .previewWith(standard: S2YApplicationStandard()) {
            HealthKit()
        }
}
#endif
