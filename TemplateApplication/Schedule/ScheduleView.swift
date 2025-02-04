//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

@_spi(TestingSupport) import SpeziAccount
import SpeziScheduler
import SpeziSchedulerUI
import SpeziViews
import SwiftUI


/// Schedule questionnaires in your app.
///
/// Modify your schedule and path to your JSON questionnaire in the ``TemplateApplicationScheduler``. These changes will be reflected in the ScheduleView.
///
/// [Spezi Scheduler GitHub](https://github.com/StanfordSpezi/SpeziScheduler)
///
/// ![A screenshot of the Schedule screen](Schedule)
struct ScheduleView: View {
    @Environment(Account.self) private var account: Account?
    @Environment(TemplateApplicationScheduler.self) private var scheduler: TemplateApplicationScheduler

    @State private var presentedEvent: Event?
    @Binding private var presentingAccount: Bool

    
    var body: some View {
        @Bindable var scheduler = scheduler

        NavigationStack {
            TodayList { event in
                InstructionsTile(event) {
                    EventActionButton(event: event, "Start Questionnaire") {
                        presentedEvent = event
                    }
                }
            }
                .navigationTitle("Schedule")
                .viewStateAlert(state: $scheduler.viewState)
                .sheet(item: $presentedEvent) { event in
                    EventView(event)
                }
                .toolbar {
                    if account != nil {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}


#if DEBUG
#Preview {
    @Previewable @State var presentingAccount = false

    ScheduleView(presentingAccount: $presentingAccount)
        .previewWith(standard: TemplateApplicationStandard()) {
            TemplateApplicationScheduler()
            AccountConfiguration(service: InMemoryAccountService())
        }
}
#endif
