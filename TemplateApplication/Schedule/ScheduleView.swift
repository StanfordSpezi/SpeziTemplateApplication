//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//


import SpeziQuestionnaire
import SpeziScheduler
import SwiftUI


struct ScheduleView: View {
    @EnvironmentObject var scheduler: TemplateApplicationScheduler
    @State var eventContextsByDate: [Date: [EventContext]] = [:]
    @State var presentedContext: EventContext?
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())

    var startOfDays: [Date] {
        var dates = [Date]()
        for day in 0..<7 {
            if let date = Calendar.current.date(byAdding: .day, value: day, to: Date()) {
                dates.append(date)
            }
        }
        return dates
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(startOfDays, id: \.self) { date in
                            Button(action: {
                                withAnimation {
                                    selectedDate = Calendar.current.startOfDay(for: date)
                                }
                            }) {
                                Text(format(startOfDay: date))
                                    .padding()
                                    .background(selectedDate == date ? Color.blue : Color.clear)
                                    .foregroundColor(selectedDate == date ? Color.white : Color.black)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }

                List {
                    Section(format(startOfDay: selectedDate)) {
                        ForEach(eventContextsByDate[selectedDate] ?? [], id: \.event) { eventContext in
                            EventContextView(eventContext: eventContext, buttonEnabled: selectedDate == Calendar.current.startOfDay(for: Date()))
                                .onTapGesture {
                                    if !eventContext.event.complete {
                                        presentedContext = eventContext
                                    }
                                }
                        }
                    }
                    .id(selectedDate)
                }
                .onChange(of: scheduler) { _ in
                    calculateEventContextsByDate()
                }
                .onChange(of: selectedDate) { newDate in
                    calculateEventContextsByDate(for: newDate)
                }
                .task {
                    calculateEventContextsByDate()
                }
            }
            .sheet(item: $presentedContext) { presentedContext in
                destination(withContext: presentedContext)
            }
            .navigationTitle("SCHEDULE_LIST_TITLE")
        }
    }
    
    
    private func destination(withContext eventContext: EventContext) -> some View {
        @ViewBuilder
        var destination: some View {
            switch eventContext.task.context {
            case let .questionnaire(questionnaire):
                QuestionnaireView(questionnaire: questionnaire) { _ in
                    _Concurrency.Task {
                        await eventContext.event.complete(true)
                    }
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
    
    private func calculateEventContextsByDate(for date: Date = Calendar.current.startOfDay(for: Date())) {
        let eventContexts = scheduler.tasks.flatMap { task in
            task
                .events(
                    from: Calendar.current.startOfDay(for: date),
                    to: .endDate(Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? date)
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
    static var previews: some View {
        ScheduleView()
            .environmentObject(TemplateApplicationScheduler())
    }
}
#endif
