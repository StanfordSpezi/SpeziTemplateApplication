//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziMockWebService
import SwiftUI


struct HomeView: View {
    enum Tabs: String {
        case schedule
        case contact
        case mockUpload
    }
    
    
    @AppStorage(StorageKeys.homeTabSelection) var selectedTab = Tabs.schedule
    @State private var showingSheet = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ScheduleView()
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
            VStack {
                HStack {
                    Spacer()
                    Button(action: { showingSheet.toggle() }) {
                        Image(systemName: "info.circle").imageScale(.large)
                    }
                    .sheet(isPresented: $showingSheet) {
                        ContributionsList()
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}


#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TemplateApplicationScheduler())
            .environmentObject(MockWebService())
    }
}
#endif
