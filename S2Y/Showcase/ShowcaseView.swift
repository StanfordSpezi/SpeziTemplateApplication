//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2025 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseFirestore
import FirebaseStorage
import Spezi
import SpeziAccount
import SpeziHealthKit
import SpeziNotifications
#if canImport(SpeziLLM)
import SpeziLLM
#endif
#if canImport(SpeziLLMOpenAI)
import SpeziLLMOpenAI
#endif
import SpeziBluetooth
import SpeziDevices
import SpeziOnboarding
import SpeziQuestionnaire
import SpeziScheduler
import SpeziSchedulerUI
import SpeziViews
import SwiftUI


struct ShowcaseView: View {
    @Environment(Account.self) private var account: Account?
    @Environment(S2YApplicationStandard.self) private var standard
    @Environment(HealthKit.self) private var healthKit
    @Environment(\.notificationSettings) private var notificationSettings

    @AppStorage(StorageKeys.onboardingFlowComplete) private var completedOnboardingFlow = false

    @State private var showingAccountSheet = false
    @State private var showingQuestionnaire = false
    @State private var showingOnboarding = false
    @State private var notificationAuthorized = false
    @State private var viewState: ViewState = .idle

    private var isHealthAuthorized: Bool {
        if ProcessInfo.processInfo.isPreviewSimulator {
            return false
        }
        return healthKit.isFullyAuthorized
    }

    var body: some View {
        NavigationStack {
            contentList
                .navigationTitle("Settings")
                .viewStateAlert(state: $viewState)
                .sheet(isPresented: $showingAccountSheet) { AccountSheet(dismissAfterSignIn: false) }
                .sheet(isPresented: $showingQuestionnaire) { questionnaireSheet }
                .fullScreenCover(isPresented: $showingOnboarding) { OnboardingFlow() }
                .task { await refreshNotificationAuthorization() }
        }
    }

    @ViewBuilder
    private var contentList: some View {
        List {
            accountSection
            if !FeatureFlags.disableFirebase { firebaseSection }
            healthKitSection
            notificationsSection
            questionnaireSection
            schedulerSection
            // Chat moved to dedicated tab
            bluetoothSection
            devicesSection
            onboardingSection
        }
    }

    #if canImport(SpeziLLM)
    @ViewBuilder
    private var llmSection: some View {
        Section("LLM") {
            #if canImport(SpeziLLMOpenAI)
            NavigationLink("OpenAI Chat Demo") { LLMChatDemoView() }
            #else
            Text("LLM modules present, demo view unavailable in this build.")
                .foregroundStyle(.secondary)
            #endif
        }
    }
    #endif

    @ViewBuilder
    private var bluetoothSection: some View {
        Section("Bluetooth") {
            Text("SpeziBluetooth added. Enable Bluetooth in Settings to use.")
                .foregroundStyle(.secondary)
            Button("Open System Settings") { openAppSettings() }
        }
    }

    @ViewBuilder
    private var devicesSection: some View {
        Section("Devices") {
            Text("SpeziDevices added. Integrate specific device plugins as needed.")
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var accountSection: some View {
        Section("Account") {
            if let account, let details = account.details {
                LabeledContent("User ID", value: details.userId)
                LabeledContent("Name", value: PersonNameComponentsFormatter().string(from: details.name ?? PersonNameComponents()))
                Button("Manage Account") { showingAccountSheet = true }
            } else if FeatureFlags.disableFirebase {
                Text("Account is disabled (Firebase is turned off). Enable Firebase to use account features.")
                    .foregroundStyle(.secondary)
            } else {
                Text("Not signed in")
                    .foregroundStyle(.secondary)
                // Only show the button if Account environment is available
                if account != nil {
                    Button("Manage Account") { showingAccountSheet = true }
                }
            }
        }
    }

    @ViewBuilder
    private var firebaseSection: some View {
        Section("Firebase") {
            Button("Write Sample Firestore Document") { writeSampleFirestore() }
            Button("Upload Sample to Storage") { uploadSampleStorage() }
        }
    }

    @ViewBuilder
    private var healthKitSection: some View {
        Section("HealthKit") {
            LabeledContent("Authorized", value: isHealthAuthorized ? "Yes" : "No")
            if HKHealthStore.isHealthDataAvailable() && !isHealthAuthorized {
                NavigationLink("Request Permissions") {
                    HealthKitPermissions()
                        .navigationTitle("Health Permissions")
                }
            }
        }
    }

    @ViewBuilder
    private var notificationsSection: some View {
        Section("Notifications") {
            LabeledContent("Authorized", value: notificationAuthorized ? "Yes" : "No")
            Button("Open Notification Settings") { openAppSettings() }
        }
    }

    @ViewBuilder
    private var questionnaireSection: some View {
        Section("Questionnaire") {
            Button("Present Social Support Questionnaire") { showingQuestionnaire = true }
        }
    }

    @ViewBuilder
    private var schedulerSection: some View {
        Section("Scheduler") {
            NavigationLink("Open Schedule") {
                ScheduleView(presentingAccount: .constant(false))
                    .navigationTitle("Schedule")
            }
        }
    }

    @ViewBuilder
    private var onboardingSection: some View {
        Section("Onboarding") {
            Button("Run Onboarding Again") {
                completedOnboardingFlow = false
                showingOnboarding = true
            }
        }
    }

    @ViewBuilder
    private var questionnaireSheet: some View {
        QuestionnaireView(questionnaire: Bundle.main.questionnaire(withName: "SocialSupportQuestionnaire")) { result in
            showingQuestionnaire = false
        }
    }

    private func refreshNotificationAuthorization() async {
        notificationAuthorized = await notificationSettings().authorizationStatus == .authorized
    }

    private func writeSampleFirestore() {
        guard let accountId = account?.details?.accountId else {
            viewState = .error(AnyLocalizedError(error: FirebaseConfiguration.ConfigurationError.userNotAuthenticatedYet))
            return
        }
        let doc = FirebaseConfiguration.userCollection.document(accountId)
        doc.setData(["updatedAt": Timestamp(date: Date()), "demo": true], merge: true) { error in
            if let error {
                viewState = .error(AnyLocalizedError(error: error))
            }
        }
    }

    private func uploadSampleStorage() {
        guard let accountId = account?.details?.accountId else {
            viewState = .error(AnyLocalizedError(error: FirebaseConfiguration.ConfigurationError.userNotAuthenticatedYet))
            return
        }
        let ref = Storage.storage().reference().child("users/\(accountId)/demo.txt")
        let data = Data("Hello Spezi".utf8)
        ref.putData(data) { _, error in
            if let error {
                viewState = .error(AnyLocalizedError(error: error))
            }
        }
    }

    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }
}


#if DEBUG
#Preview {
    ShowcaseView()
        .previewWith(standard: S2YApplicationStandard()) {
            AccountConfiguration(service: InMemoryAccountService(), configuration: AccountValueConfiguration())
            HealthKit()
        }
}
#endif
