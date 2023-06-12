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
        let today = Date()
        let calendar = Calendar.current

        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return dates
        }

        for day in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: day, to: sunday) {
                dates.append(date)
            }
        }
        return dates
    }

    var dateSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(startOfDays, id: \.self) { date in
                    let startOfDay = Calendar.current.startOfDay(for: date)
                    Button(action: {
                        withAnimation {
                            selectedDate = startOfDay
                        }
                    }) {
                        Text(extractDayNumber(from: startOfDay))
                            .padding()
                            .background(selectedDate == startOfDay ? Color.blue : Color.clear)
                            .foregroundColor(selectedDate == startOfDay ? Color.white : Color.black)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                dateSelector
                List {
                    Section(format(startOfDay: selectedDate)) {
                        if let events = eventContextsByDate[selectedDate] {
                            ForEach(events, id: \.event) { eventContext in
                                let isToday = selectedDate == Calendar.current.startOfDay(for: Date())
                                EventContextView(eventContext: eventContext, buttonEnabled: isToday)
                                    .onTapGesture {
                                        if !eventContext.event.complete && isToday {
                                            presentedContext = eventContext
                                        }
                                    }
                            }
                        } else {
                            Text("SCHEDULE_NO_TASKS")
                        }
                    }
                    .id(selectedDate)
                }
                .onChange(of: scheduler) { _ in
                    calculateEventContextsByDate(for: selectedDate)
                }
                .onChange(of: selectedDate) { newDate in
                    calculateEventContextsByDate(for: newDate)
                }
                .task {
                    calculateEventContextsByDate(for: selectedDate)
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

    func extractDayNumber(from date: Date) -> String {
        let calendar = Calendar.current
        let dayNumber = calendar.component(.day, from: date)
        return String(dayNumber)
    }
    
    private func calculateEventContextsByDate(for date: Date = Calendar.current.startOfDay(for: Date())) {
        let eventContexts = scheduler.tasks.flatMap { task in
            task
                .events(
                    from: Calendar.current.startOfDay(for: date),
                    to: .numberOfEventsOrEndDate(
                        100,
                        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date) ?? date
                    )
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
