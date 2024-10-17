//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import OrderedCollections
@_spi(TestingSupport) import SpeziAccount
import SpeziQuestionnaire
import SpeziScheduler
import SpeziSchedulerUI
import SwiftUI


struct EventView: View {
    private let event: Event

    @Environment(TemplateApplicationStandard.self) private var standard
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        if let questionnaire = event.task.questionnaire {
            QuestionnaireView(questionnaire: questionnaire) { result in
                dismiss()

                guard case let .completed(response) = result else {
                    return // user cancelled the task
                }

                event.complete()
                await standard.add(response: response)
            }
        }
    }

    init(_ event: Event) {
        self.event = event
    }
}


struct ScheduleView: View {
    @Environment(Account.self) private var account: Account?

    @State private var presentedEvent: Event?
    @Binding private var presentingAccount: Bool

    
    var body: some View {
        NavigationStack {
            TodayList { event in
                InstructionsTile(event) { // TODO: use TASK_CONTEXT_ACTION_QUESTIONNAIRE for the footer Action button!
                    presentedEvent = event
                }
            }
                .sheet(item: $presentedEvent) { event in
                    EventView(event)
                }
                .toolbar {
                    if account != nil {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
                .navigationTitle("SCHEDULE_LIST_TITLE")
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}


#if DEBUG
#Preview("ScheduleView") {
    ScheduleView(presentingAccount: .constant(false))
        .previewWith(standard: TemplateApplicationStandard()) {
            Scheduler()
            TemplateApplicationScheduler()
            AccountConfiguration(service: InMemoryAccountService())
        }
}
#endif
