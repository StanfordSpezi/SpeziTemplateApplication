//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import SwiftUI
import SpeziFHIR
import SpeziOnboarding
import SpeziHealthKit

/// Displays an multi-step onboarding flow for the Spezi Template Application.
struct OnboardingFlow: View {
    enum Step: String, Codable {
        case interestingModules
        case consent
        case accountSetup
        case login
        case signUp
        case healthKitPermissions
        case notificationPermissions
    }
    
    @EnvironmentObject var healthKitDataSource: HealthKit<FHIR>
    @EnvironmentObject var scheduler: TemplateApplicationScheduler
    
    @SceneStorage(StorageKeys.onboardingFlowStep) private var onboardingSteps: [Step] = []
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    @State private var localNotificationAuthorization = false
    
    var body: some View {
        SpeziOnboarding.OnboardingFlow(onboardingFlowComplete: $completedOnboardingFlow) {
            Welcome(onboardingSteps: .constant([]))
            InterestingModules(onboardingSteps: .constant([]))
            
            #if !(targetEnvironment(simulator) && (arch(i386) || arch(x86_64)))
                Consent(onboardingSteps: .constant([]))
            #endif
            
            if !FeatureFlags.disableFirebase {
                AccountSetup(onboardingSteps: .constant([]))
                TemplateLogin()
                TemplateSignUp()
            }
            
            if HKHealthStore.isHealthDataAvailable() && !healthKitDataSource.authorized {
                HealthKitPermissions(onboardingSteps: .constant([]))
            }
            
            if !localNotificationAuthorization {
                NotificationPermissions()
            }
        }
        .interactiveDismissDisabled(!completedOnboardingFlow)
        .task {
            localNotificationAuthorization = await !scheduler.localNotificationAuthorization
        }
        
        /*
        NavigationStack(path: $onboardingSteps) {
            Welcome(onboardingSteps: $onboardingSteps)
                .navigationDestination(for: Step.self) { onboardingStep in
                    switch onboardingStep {
                    case .interestingModules:
                        InterestingModules(onboardingSteps: $onboardingSteps)
                    case .consent:
                        Consent(onboardingSteps: $onboardingSteps)
                    case .accountSetup:
                        AccountSetup(onboardingSteps: $onboardingSteps)
                    case .login:
                        TemplateLogin()
                    case .signUp:
                        TemplateSignUp()
                    case .healthKitPermissions:
                        HealthKitPermissions(onboardingSteps: $onboardingSteps)
                    case .notificationPermissions:
                        NotificationPermissions()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled(!completedOnboardingFlow)
         */
    }
}


#if DEBUG
struct OnboardingFlow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFlow()
    }
}
#endif
