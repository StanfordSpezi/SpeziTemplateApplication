//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import Spezi
import SpeziScheduler
import class ModelsR4.Questionnaire
import class ModelsR4.QuestionnaireResponse


final class TemplateApplicationScheduler: Module, DefaultInitializable {
    @Dependency(Scheduler.self) private var scheduler

    init() {}
    
    /// Add or update the current list of task upon app startup.
    func configure() {
        do {
            // TODO: support test schedule flag: FeatureFlags.testSchedule for UI testing!
            try scheduler.createOrUpdateTask(
                id: "social-support-questionnaire",
                title: "TASK_SOCIAL_SUPPORT_QUESTIONNAIRE_TITLE",
                instructions: "TASK_SOCIAL_SUPPORT_QUESTIONNAIRE_DESCRIPTION",
                schedule: .daily(hour: 8, minute: 0, startingAt: .today)
            ) { context in
                context.questionnaire = Bundle.main.questionnaire(withName: "SocialSupportQuestionnaire")
            }
        } catch {
            // TODO: we should visualize this? or at least allow to visualize it!
        }
    }
}


extension Task.Context {
    @Property var questionnaire: Questionnaire?
}


extension Outcome {
    @Property var questionnaireResponse: QuestionnaireResponse?
}
