//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziScheduler


/// A `Scheduler` using the ``TemplateApplicationTaskContext`` to schedule and manage tasks and events in the
/// Spezi Template Applciation.
typealias TemplateApplicationScheduler = Scheduler<TemplateApplicationTaskContext>


extension TemplateApplicationScheduler {
    /// Creates a default instance of the ``TemplateApplicationScheduler`` by scheduling the tasks listed below.
    convenience init() {
        let dateComponents: DateComponents
        if FeatureFlags.testSchedule {
            // Adds a task at the current time for UI testing if the `--testSchedule` feature flag is set
            dateComponents = DateComponents(
                hour: Calendar.current.component(.hour, from: .now),
                minute: Calendar.current.component(.minute, from: .now)
            )
        } else {
            // For the normal app usage, we schedule the task for every day at 8:00 AM
            dateComponents = DateComponents(hour: 8, minute: 0)
        }
        
        self.init(
            tasks: [
                Task(
                    title: String(localized: "TASK_SOCIAL_SUPPORT_QUESTIONNAIRE_TITLE"),
                    description: String(localized: "TASK_SOCIAL_SUPPORT_QUESTIONNAIRE_DESCRIPTION"),
                    schedule: Schedule(
                        start: Calendar.current.startOfDay(for: Date()),
                        repetition: .matching(dateComponents),
                        end: .numberOfEvents(365)
                    ),
                    notifications: true,
                    context: TemplateApplicationTaskContext.questionnaire(Bundle.main.questionnaire(withName: "SocialSupportQuestionnaire"))
                )
            ]
        )
    }
}
