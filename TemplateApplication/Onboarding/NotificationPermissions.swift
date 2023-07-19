//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziFHIR
import SpeziOnboarding
import SpeziScheduler
import SwiftUI


struct NotificationPermissions: View {
    @EnvironmentObject var scheduler: TemplateApplicationScheduler
    @EnvironmentObject private var onboardingNavigationPath: OnboardingNavigationPath
    @State var notificationProcessing = false
    
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "NOTIFICATION_PERMISSIONS_TITLE".moduleLocalized,
                        subtitle: "NOTIFICATION_PERMISSIONS_SUBTITLE".moduleLocalized
                    )
                    Spacer()
                    Image(systemName: "bell.square.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                    Text("NOTIFICATION_PERMISSIONS_DESCRIPTION")
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                    Spacer()
                }
            }, actionView: {
                OnboardingActionsView(
                    "NOTIFICATION_PERMISSIONS_BUTTON".moduleLocalized,
                    action: {
                        do {
                            notificationProcessing = true
                            // Notification Authorization is not available in the preview simulator.
                            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                                try await _Concurrency.Task.sleep(for: .seconds(5))
                            } else {
                                try await scheduler.requestLocalNotificationAuthorization()
                            }
                        } catch {
                            print("Could not request notification permissions.")
                        }
                        notificationProcessing = false
                        
                        onboardingNavigationPath.nextStep()
                    }
                )
            }
        )
        .navigationBarBackButtonHidden(notificationProcessing)
        // Small fix as otherwise "Login" or "Sign up" is still shown in the nav bar
        .navigationTitle("")
    }
}


#if DEBUG
struct NotificationPermissions_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPermissions()
    }
}
#endif
