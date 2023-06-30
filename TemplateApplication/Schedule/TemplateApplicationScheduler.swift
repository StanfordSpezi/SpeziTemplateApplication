//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziFHIR
import SpeziScheduler


/// A `Scheduler` using the `FHIR` standard as well as the ``TemplateApplicationTaskContext`` to schedule and manage tasks and events in the
/// Spezi Template Applciation.
typealias TemplateApplicationScheduler = Scheduler<FHIR, TemplateApplicationTaskContext>


extension TemplateApplicationScheduler {
    /// Creates a default instance of the ``TemplateApplicationScheduler`` by scheduling the tasks listed below.
    convenience init() {
        var tasks: [SpeziScheduler.Task<TemplateApplicationTaskContext>] = [
            Task(
                title: String(localized: "TASK_SOCIAL_SUPPORT_QUESTIONNAIRE_TITLE"),
                description: String(localized: "TASK_SOCIAL_SUPPORT_QUESTIONNAIRE_DESCRIPTION"),
                schedule: Schedule(
                    start: Calendar.current.startOfDay(for: Date()),
                    repetition: .matching(.init(hour: 8, minute: 0)), // Every Day at 8:00 AM
                    end: .numberOfEvents(365)
                ),
                notifications: true,
                context: TemplateApplicationTaskContext.questionnaire(Bundle.main.questionnaire(withName: "SocialSupportQuestionnaire"))
            )
        ]

        /// Adds a task at the current time for UI testing if the `--testSchedule` feature flag is set
        if FeatureFlags.testSchedule || FeatureFlags.testScheduleNotification {
            let currentDate = Date.now
            let currentHour = Calendar.current.component(.hour, from: currentDate)
            let currentMinute: Int
            if FeatureFlags.testScheduleNotification {
                // We expect the UI test to take at least 20 seconds to mavigate out of the app and to the home screen.
                // We then trigger the task in the minute after that, the UI test needs to wait at least one minute.
                currentMinute = Calendar.current.component(.minute, from: currentDate.addingTimeInterval(20)) + 1
            } else {
                currentMinute = Calendar.current.component(.minute, from: currentDate)
            }
            
            let testTask = Task(
                title: String(localized: "TASK_TEST_TITLE"),
                description: String(localized: "TASK_TEST_DESCRIPTION"),
                schedule: Schedule(
                    start: Calendar.current.startOfDay(for: currentDate),
                    repetition: .matching(.init(hour: currentHour, minute: currentMinute)), // repeat at current time
                    end: .numberOfEvents(1)
                ),
                notifications: FeatureFlags.testScheduleNotification,
                context: TemplateApplicationTaskContext.test(String(localized: "TASK_TEST_CONTENT"))
            )
            tasks.append(testTask)
        }

        self.init(tasks: tasks)
    }
}
