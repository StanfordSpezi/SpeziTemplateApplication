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
    
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }


    @AppStorage(StorageKeys.homeTabSelection) private var selectedTab = Tabs.schedule
    @State private var presentingAccount = false

    
    var body: some View {
        TabView(selection: $selectedTab) {
            ScheduleView(presentingAccount: $presentingAccount)
                .tag(Tabs.schedule)
                .tabItem {
                    Label("SCHEDULE_TAB_TITLE", systemImage: "list.clipboard")
                }
            Contacts(presentingAccount: $presentingAccount)
                .tag(Tabs.contact)
                .tabItem {
                    Label("CONTACTS_TAB_TITLE", systemImage: "person.fill")
                }
            if FeatureFlags.disableFirebase {
                MockUpload(presentingAccount: $presentingAccount)
                    .tag(Tabs.mockUpload)
                    .tabItem {
                        Label("MOCK_WEB_SERVICE_TAB_TITLE", systemImage: "server.rack")
                    }
            }
        }
            .sheet(isPresented: $presentingAccount) {
                AccountSheet()
            }
            .accountRequired(Self.accountEnabled) {
                AccountSheet()
            }
            .verifyRequiredAccountDetails(Self.accountEnabled)
    }
}


#if DEBUG
#Preview {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    return HomeView()
        .environment(Account(building: details, active: MockUserIdPasswordAccountService()))
        .environment(TemplateApplicationScheduler())
        .environment(MockWebService())
}
#endif
