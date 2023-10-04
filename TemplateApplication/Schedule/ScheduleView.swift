//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//


import SpeziAccount
import SpeziQuestionnaire
import SpeziScheduler
import SwiftUI


struct ScheduleView: View {
    @EnvironmentObject var scheduler: TemplateApplicationScheduler
    @State var eventContextsByDate: [Date: [EventContext]] = [:]
    @State var presentedContext: EventContext?


    @Binding var presentingAccount: Bool

    
    var startOfDays: [Date] {
        Array(eventContextsByDate.keys)
    }
    
    
    var body: some View {
        NavigationStack {
            List(startOfDays, id: \.timeIntervalSinceNow) { startOfDay in
                Section(format(startOfDay: startOfDay)) {
                    ForEach(eventContextsByDate[startOfDay] ?? [], id: \.event) { eventContext in
                        EventContextView(eventContext: eventContext)
                            .onTapGesture {
                                if !eventContext.event.complete {
                                    presentedContext = eventContext
                                }
                            }
                    }
                }
            }
                .onChange(of: scheduler) { _ in
                    calculateEventContextsByDate()
                }
                .task {
                    calculateEventContextsByDate()
                }
                .sheet(item: $presentedContext) { presentedContext in
                    destination(withContext: presentedContext)
                }
                .toolbar {
                    if AccountButton.shouldDisplay {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
                .navigationTitle("SCHEDULE_LIST_TITLE")
        }
    }


    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }

    
    private func destination(withContext eventContext: EventContext) -> some View {
        @ViewBuilder var destination: some View {
            switch eventContext.task.context {
            case let .questionnaire(questionnaire):
                QuestionnaireView(questionnaire: questionnaire) { _ in
                    await eventContext.event.complete(true)
                }
            case let .test(string):
                ModalView(text: string, buttonText: String(localized: "CLOSE")) {
                    await eventContext.event.complete(true)
                }
            }
        }
        return destination
    }
    
    
    private func format(startOfDay: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: startOfDay)
    }
    
    private func calculateEventContextsByDate() {
        let eventContexts = scheduler.tasks.flatMap { task in
            task
                .events(
                    from: Calendar.current.startOfDay(for: .now),
                    to: .numberOfEventsOrEndDate(100, .now)
                )
                .map { event in
                    EventContext(event: event, task: task)
                }
        }
            .sorted()
        
        let newEventContextsByDate = Dictionary(grouping: eventContexts) { eventContext in
            Calendar.current.startOfDay(for: eventContext.event.scheduledAt)
        }
        
        if newEventContextsByDate != eventContextsByDate {
            eventContextsByDate = newEventContextsByDate
        }
    }
}


#if DEBUG
struct SchedulerView_Previews: PreviewProvider {
    static let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))

    static var previews: some View {
        ScheduleView(presentingAccount: .constant(false))
            .environmentObject(TemplateApplicationScheduler())
            .environmentObject(Account())

        ScheduleView(presentingAccount: .constant(true))
            .environmentObject(TemplateApplicationScheduler())
            .environmentObject(Account(building: details, active: MockUserIdPasswordAccountService()))
    }
}
#endif
