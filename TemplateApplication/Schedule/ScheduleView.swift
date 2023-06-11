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
                            let startOfDay = Calendar.current.startOfDay(for: date)
                            Button(action: {
                                withAnimation {
                                    selectedDate = startOfDay
                                }
                            }) {
                                Text(format(startOfDay: startOfDay))
                                    .padding()
                                    .background(selectedDate == startOfDay ? Color.blue : Color.clear)
                                    .foregroundColor(selectedDate == startOfDay ? Color.white : Color.black)
                                    .cornerRadius(10)
                                    .padding(5)
                            }
                        }
                    }
                }

                List {
                    Section {
                        ForEach(eventContextsByDate[selectedDate] ?? [], id: \.event) { eventContext in
                            let isToday = selectedDate == Calendar.current.startOfDay(for: Date())
                            EventContextView(eventContext: eventContext, buttonEnabled: isToday)
                                .onTapGesture {
                                    if !eventContext.event.complete && isToday {
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
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: startOfDay)

        guard let rangeOfMonth = calendar.range(of: .day, in: .month, for: startOfDay) else {
            return ""
        }

        let firstDayOfMonth = rangeOfMonth.lowerBound
        let lastDayOfMonth = rangeOfMonth.upperBound - 1

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none

        if dayOfMonth == firstDayOfMonth || dayOfMonth == lastDayOfMonth {
            // If the date is on the border of two months, display the month and year
            dateFormatter.dateFormat = "MMMM, yyyy"
        } else {
            // Otherwise, display only the month and day
            dateFormatter.dateFormat = "MMMM dd"
        }

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
