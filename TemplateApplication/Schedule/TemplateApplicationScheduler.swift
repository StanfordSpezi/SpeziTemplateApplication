//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import class ModelsR4.Questionnaire
import class ModelsR4.QuestionnaireResponse
import Spezi
import SpeziAccount
import SpeziScheduler
import SpeziViews


@MainActor
@Observable
final class TemplateApplicationScheduler: Module, DefaultInitializable, EnvironmentAccessible {
    @Dependency(Scheduler.self) @ObservationIgnored private var scheduler
    @Dependency(Account.self) @ObservationIgnored private var account: Account?

    var viewState: ViewState = .idle

    /// Whether the app gates its content behind a user account.
    ///
    /// When `false` (e.g. `--disableFirebase` or `--skipOnboarding`), there is no login step, so tasks are always scheduled.
    private var requiresAccount: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }


    nonisolated init() {}


    func configure() {
        // Only schedule tasks when there is an active user context: either the app doesn't require an account,
        // or a user is currently signed in. Login/logout transitions are forwarded from `TemplateApplicationStandard`
        // so that a logged-out user does not keep receiving notifications.
        // See https://github.com/StanfordSpezi/SpeziTemplateApplication/issues/57.
        if !requiresAccount || account?.signedIn == true {
            createOrUpdateTasks()
        }
    }

    /// Creates or updates the app's scheduled tasks.
    ///
    /// This is the single source of truth for the app's schedule: add new tasks here and they are automatically
    /// (re)scheduled when a user signs in and cleared when they sign out — no other changes required.
    func createOrUpdateTasks() {
        do {
            try scheduler.createOrUpdateTask(
                id: "social-support-questionnaire",
                title: "Social Support Questionnaire",
                instructions: "Please fill out the Social Support Questionnaire every day.",
                category: .questionnaire,
                schedule: .daily(hour: 8, minute: 0, startingAt: .today)
            ) { context in
                context.questionnaire = Bundle.main.questionnaire(withName: "SocialSupportQuestionnaire")
            }
        } catch {
            viewState = .error(AnyLocalizedError(error: error, defaultErrorDescription: "Failed to create or update scheduled tasks."))
        }
    }

    /// Removes all scheduled tasks and any queued notifications, e.g. when the user logs out.
    ///
    /// Clearing every scheduled task (instead of specific identifiers) means tasks added to
    /// ``createOrUpdateTasks()`` are cleaned up automatically, without any additional bookkeeping here.
    func cancelAllTasks() {
        do {
            let tasks = try scheduler.queryTasks(for: Date.distantPast..<Date.distantFuture)
            try scheduler.deleteTasks(tasks)
        } catch {
            viewState = .error(AnyLocalizedError(error: error, defaultErrorDescription: "Failed to clear scheduled tasks."))
        }
    }
}


extension Task.Context {
    @Property(coding: .json) var questionnaire: Questionnaire?
}


extension Outcome {
    // periphery:ignore - demonstration of how to store additional context within an outcome
    @Property(coding: .json) var questionnaireResponse: QuestionnaireResponse?
}
