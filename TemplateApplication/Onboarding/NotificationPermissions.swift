//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziNotifications
import SpeziOnboarding
import SpeziViews
import SwiftUI


struct NotificationPermissions: View {
    @Environment(ManagedNavigationStack.Path.self) private var managedNavigationPath
    
    @Environment(\.requestNotificationAuthorization) private var requestNotificationAuthorization
    
    @State private var notificationProcessing = false
    
    
    var body: some View {
        OnboardingView(
            content: {
                VStack {
                    OnboardingTitleView(
                        title: "Notifications",
                        subtitle: "Spezi Scheduler Notifications."
                    )
                    Spacer()
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
                                _ = try await requestNotificationAuthorization(options: [.alert, .sound, .badge])
                            }
                        } catch {
                            print("Could not request notification permissions.")
                        }
                        notificationProcessing = false
                        
                        managedNavigationPath.nextStep()
                    }
                )
            }
        )
        .navigationBarBackButtonHidden(notificationProcessing)
        .navigationTitle(Text(verbatim: ""))
        .toolbar(.visible)
    }
}


#if DEBUG
#Preview {
    ManagedNavigationStack {
        NotificationPermissions()
    }
    .previewWith {
        TemplateApplicationScheduler()
    }
}
#endif
