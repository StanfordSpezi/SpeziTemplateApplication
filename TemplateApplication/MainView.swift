//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziMockWebService
import SwiftUI


struct MainView: View {
    @AppStorage(StorageKeys.onboardingFlowComplete) var completedOnboardingFlow = false

    @EnvironmentObject private var standard: TemplateApplicationStandard
    @EnvironmentObject private var account: Account

    var body: some View {
        let group = ZStack {
            if completedOnboardingFlow {
                HomeView()
            } else {
                EmptyView()
            }
        }
            .sheet(isPresented: !$completedOnboardingFlow) {
                OnboardingFlow()
            }

        if FeatureFlags.disableFirebase {
            group
        } else {
            group
                .onReceive(account.$details) { newValue in
                    if let newValue {
                        Task {
                            // we catch any changes to the account globally
                            await standard.updateAccount(details: newValue)
                        }
                    }
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Account(MockUserIdPasswordAccountService()))
            .environmentObject(TemplateApplicationScheduler())
            .environmentObject(MockWebService())
    }
}
