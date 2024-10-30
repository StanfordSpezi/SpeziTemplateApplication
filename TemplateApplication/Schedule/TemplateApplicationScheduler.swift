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
import SpeziViews
import class ModelsR4.Questionnaire
import class ModelsR4.QuestionnaireResponse


@Observable
final class TemplateApplicationScheduler: Module, DefaultInitializable, EnvironmentAccessible {
    @Dependency(Scheduler.self) @ObservationIgnored private var scheduler

    @MainActor var viewState: ViewState = .idle

    init() {}
    
    /// Add or update the current list of task upon app startup.
    func configure() {
        do { // TODO: update visuals and update docs!
            let task = try scheduler.createOrUpdateTask(
                id: "social-support-questionnaire",
                title: "Social Support Questionnaire",
                instructions: "Please fill out the Social Support Questionnaire every day.",
                category: .questionnaire,
                schedule: .daily(hour: 8, minute: 0, startingAt: .today)
            ) { context in
                context.questionnaire = Bundle.main.questionnaire(withName: "SocialSupportQuestionnaire")
            }

            print(task) // TODO: remove
            print(task.task.questionnaire!)
        } catch {
            viewState = .error(AnyLocalizedError(error: error, defaultErrorDescription: "Failed to create or update scheduled tasks."))
        }
    }
}


extension Task.Context {
    @Property var questionnaire: Questionnaire?
}


extension Outcome {
    @Property var questionnaireResponse: QuestionnaireResponse?
}
