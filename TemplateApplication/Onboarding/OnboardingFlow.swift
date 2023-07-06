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
import SpeziHealthKit
import SpeziOnboarding
import SwiftUI

/// Displays an multi-step onboarding flow for the Spezi Template Application.
struct Onboarding: View {
    @EnvironmentObject var healthKitDataSource: HealthKit<FHIR>
    @EnvironmentObject var scheduler: TemplateApplicationScheduler
    @EnvironmentObject var account: SpeziAccount.Account
    
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false
    
    @State private var localNotificationAuthorization = false
    
    var body: some View {
        OnboardingFlow(onboardingFlowComplete: $completedOnboardingFlow) {
            Welcome()
            InterestingModules()
            
            #if !(targetEnvironment(simulator) && (arch(i386) || arch(x86_64)))
                Consent()
            #endif
            
            if !FeatureFlags.disableFirebase {
                AccountSetup()
                
                if !account.signedIn {
                    TemplateLogin()
                    TemplateSignUp()
                }
            }
            
            if HKHealthStore.isHealthDataAvailable() && !healthKitDataSource.authorized {
                HealthKitPermissions()
            }
            
            // TODO: This doesn't work, the task closure doesnt change the result of the result builder
            if !localNotificationAuthorization {
                NotificationPermissions()
            }
        }
        .interactiveDismissDisabled(!completedOnboardingFlow)
    }
}


#if DEBUG
struct OnboardingFlow_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
#endif
