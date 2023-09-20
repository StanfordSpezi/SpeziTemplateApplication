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


struct HomeView: View {
    enum Tabs: String {
        case schedule
        case contact
        case mockUpload
    }
    
    
    @AppStorage(StorageKeys.homeTabSelection) var selectedTab = Tabs.schedule

    @EnvironmentObject private var account: Account

    @State private var presentingAccount = false

    
    var body: some View {
        let tab = TabView(selection: $selectedTab) {
            ScheduleView(presentingAccount: $presentingAccount)
                .tag(Tabs.schedule)
                .tabItem {
                    Label("SCHEDULE_TAB_TITLE", systemImage: "list.clipboard")
                }
            Contacts()
                .tag(Tabs.contact)
                .tabItem {
                    Label("CONTACTS_TAB_TITLE", systemImage: "person.fill")
                }
            if FeatureFlags.disableFirebase {
                MockUpload()
                    .tag(Tabs.mockUpload)
                    .tabItem {
                        Label("MOCK_WEB_SERVICE_TAB_TITLE", systemImage: "server.rack")
                    }
            }
        }
            .sheet(isPresented: $presentingAccount) {
                AccountSheet()
                    .interactiveDismissDisabled(!account.signedIn)
            }

        if !(FeatureFlags.disableFirebase && FeatureFlags.skipOnboarding) {
            tab
                .onChange(of: account.signedIn) { newValue in
                    if !newValue {
                        presentingAccount = true
                    }
                }
                .task {
                    try? await Task.sleep(for: .milliseconds(500))
                    if !account.signedIn {
                        presentingAccount = true
                    }
                }
        } else {
            tab
        }
    }
}


#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Account(MockUserIdPasswordAccountService()))
            .environmentObject(TemplateApplicationScheduler())
            .environmentObject(MockWebService())
    }
}
#endif
