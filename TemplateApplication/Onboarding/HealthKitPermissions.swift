//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziHealthKit
import SpeziOnboarding
import SpeziViews
import SwiftUI


struct HealthKitPermissions: View {
    @Environment(HealthKit.self) private var healthKit
    @Environment(ManagedNavigationStack.Path.self) private var managedNavigationPath
    
    @State private var healthKitProcessing = false
    
    
    var body: some View {
        OnboardingView(
            content: {
                VStack {
                    OnboardingTitleView(
                        title: "HealthKit Access",
                        subtitle: "HEALTHKIT_PERMISSIONS_SUBTITLE"
                    )
                    Spacer()
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    Text("HEALTHKIT_PERMISSIONS_DESCRIPTION")
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                    Spacer()
                }
            },
            footer: {
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
                        
                        managedNavigationPath.nextStep()
                    }
                )
            }
        )
        .navigationBarBackButtonHidden(healthKitProcessing)
        .navigationTitle(Text(verbatim: ""))
        .toolbar(.visible)
    }
}


#Preview {
    ManagedNavigationStack {
        HealthKitPermissions()
    }
    .previewWith(standard: TemplateApplicationStandard()) {
        HealthKit()
    }
}
