//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziNotifications
import SpeziOnboarding
import SwiftUI


struct NotificationPermissions: View {
    // OnboardingNavigationPath removed in 2.x
    
    @Environment(\.requestNotificationAuthorization) private var requestNotificationAuthorization
    
    @State private var notificationProcessing = false
    
    
    var body: some View {
        OnboardingView(
            header: {
                OnboardingTitleView(
                    title: "Notifications",
                    subtitle: "Spezi Scheduler Notifications."
                )
            },
            content: {
                VStack {
                    Image(systemName: "bell.square.fill")
                        .font(.system(size: 150))
                        .foregroundColor(.accentColor)
                        .accessibilityHidden(true)
                    Text("NOTIFICATION_PERMISSIONS_DESCRIPTION")
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 16)
                    Spacer()
                }
            },
            footer: {
                OnboardingActionsView(
                    "Allow Notifications",
                    action: {
                        do {
                            notificationProcessing = true
                            // Notification Authorization is not available in the preview simulator.
                            if ProcessInfo.processInfo.isPreviewSimulator {
                                try await _Concurrency.Task.sleep(for: .seconds(5))
                            } else {
                                try await requestNotificationAuthorization(options: [.alert, .sound, .badge])
                            }
                        } catch {
                            print("Could not request notification permissions.")
                        }
                        notificationProcessing = false
                    }
                )
            }
        )
            .navigationBarBackButtonHidden(notificationProcessing)
            // Small fix as otherwise "Login" or "Sign up" is still shown in the nav bar
            .navigationTitle(Text(verbatim: ""))
    }
}


#if DEBUG
#Preview {
    NotificationPermissions()
        .previewWith {
            S2YApplicationScheduler()
        }
}
#endif
