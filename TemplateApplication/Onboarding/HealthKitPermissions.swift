//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziFHIR
import SpeziHealthKit
import SpeziOnboarding
import SwiftUI


struct HealthKitPermissions: View {
    @EnvironmentObject var healthKitDataSource: HealthKit<FHIR>
    @EnvironmentObject var scheduler: TemplateApplicationScheduler
    @Binding private var onboardingSteps: [OnboardingFlow.Step]
    @State var healthKitProcessing = false
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "HEALTHKIT_PERMISSIONS_TITLE".moduleLocalized,
                        subtitle: "HEALTHKIT_PERMISSIONS_SUBTITLE".moduleLocalized
                    )
                    Spacer()
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                    Text("HEALTHKIT_PERMISSIONS_DESCRIPTION")
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                    Spacer()
                }
            }, actionView: {
                OnboardingActionsView(
                    "HEALTHKIT_PERMISSIONS_BUTTON".moduleLocalized,
                    action: {
                        do {
                            healthKitProcessing = true
                            // HealthKit is not available in the preview simulator.
                            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                                try await _Concurrency.Task.sleep(for: .seconds(5))
                            } else {
                                try await healthKitDataSource.askForAuthorization()
                            }
                        } catch {
                            print("Could not request HealthKit permissions.")
                        }
                        healthKitProcessing = false
                        if await !scheduler.localNotificationAuthorization {
                            onboardingSteps.append(.notificationPermissions)
                        } else {
                            completedOnboardingFlow = true
                        }
                    }
                )
            }
        )
            .navigationBarBackButtonHidden(healthKitProcessing)
    }
    
    
    init(onboardingSteps: Binding<[OnboardingFlow.Step]>) {
        self._onboardingSteps = onboardingSteps
    }
}


#if DEBUG
struct HealthKitPermissions_Previews: PreviewProvider {
    @State private static var path: [OnboardingFlow.Step] = []
    
    
    static var previews: some View {
        HealthKitPermissions(onboardingSteps: $path)
    }
}
#endif
