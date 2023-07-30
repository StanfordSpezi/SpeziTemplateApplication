//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import SpeziAccount
import SpeziFHIR
import SpeziFirebaseAccount
import SpeziHealthKit
import SpeziOnboarding
import SwiftUI

/// Displays an multi-step onboarding flow for the Spezi Template Application.
struct OnboardingFlow: View {
    @EnvironmentObject private var healthKitDataSource: HealthKit<FHIR>
    @EnvironmentObject private var scheduler: TemplateApplicationScheduler
    
    @AppStorage(StorageKeys.onboardingFlowComplete) private var completedOnboardingFlow = false
    
    @State private var localNotificationAuthorization = false
    
    private var healthKitAuthorization: Bool {
        // As HealthKit not available in preview simulator
        if ProcessInfo.processInfo.isPreviewSimulator {
            return false
        }
        
        return healthKitDataSource.authorized
    }
    
    var body: some View {
        OnboardingStack(onboardingFlowComplete: $completedOnboardingFlow) {
            Welcome()
            InterestingModules()
            
            #if !(targetEnvironment(simulator) && (arch(i386) || arch(x86_64)))
                Consent()
            #endif
            
            if !FeatureFlags.disableFirebase {
                AccountSetup()
            }
            
            if HKHealthStore.isHealthDataAvailable() && !healthKitAuthorization {
                HealthKitPermissions()
            }
            
            if !localNotificationAuthorization {
                NotificationPermissions()
            }
        }
        .task {
            localNotificationAuthorization = await scheduler.localNotificationAuthorization
        }
        .interactiveDismissDisabled(!completedOnboardingFlow)
    }
}


#if DEBUG
struct OnboardingFlow_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFlow()
            .environmentObject(Account(accountServices: []))
            .environmentObject(FirebaseAccountConfiguration<FHIR>(emulatorSettings: (host: "localhost", port: 9099)))
            .environmentObject(TemplateApplicationScheduler())
    }
}
#endif
