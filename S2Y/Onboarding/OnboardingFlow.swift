//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

@_spi(TestingSupport) import SpeziAccount
import SpeziFirebaseAccount
import SpeziHealthKit
import SpeziNotifications
import SpeziOnboarding
import SwiftUI


/// Displays an multi-step onboarding flow for the Spezi Template Application.
struct OnboardingFlow: View {
    @Environment(HealthKit.self) private var healthKit
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.notificationSettings) private var notificationSettings
    
    @AppStorage(StorageKeys.onboardingFlowComplete) private var completedOnboardingFlow = false
    
    @State private var localNotificationAuthorization = false
    
    
    @MainActor private var healthKitAuthorization: Bool {
        // As HealthKit not available in preview simulator
        if ProcessInfo.processInfo.isPreviewSimulator {
            return false
        }
        return healthKit.isFullyAuthorized
    }
    
    var body: some View {
        OnboardingView(
            header: {
                OnboardingTitleView(
                    title: "Spezi Template Application",
                    subtitle: "WELCOME_SUBTITLE"
                )
            },
            content: {
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 80))
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    Text("WELCOME_AREA1_DESCRIPTION")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            },
            footer: {
                OnboardingActionsView(
                    "Continue",
                    action: { completedOnboardingFlow = true }
                )
            }
        )
        .interactiveDismissDisabled(!completedOnboardingFlow)
        .onChange(of: scenePhase, initial: true) {
            guard case .active = scenePhase else { return }
            Task {
                localNotificationAuthorization = await notificationSettings().authorizationStatus == .authorized
            }
        }
    }
}


#if DEBUG
#Preview {
    OnboardingFlow()
        .previewWith(standard: S2YApplicationStandard()) {
            HealthKit()
        }
}
#endif
