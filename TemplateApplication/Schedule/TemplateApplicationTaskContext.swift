//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziFHIR


/// The context attached to each task in the Spezi Template Application.
///
/// We currently only support `Questionnaire`s, more cases can be added in the future.
enum TemplateApplicationTaskContext: Codable, Identifiable {
    /// The task should display a `Questionnaire`.
    case questionnaire(Questionnaire)
    /// The task is used for UI testing.
    case test(String)
    
    
    var id: Questionnaire.ID {
        switch self {
        case let .questionnaire(questionnaire):
            return questionnaire.id
        case .test:
            return FHIRPrimitive(FHIRString(UUID().uuidString))
        }
    }
    
    var actionType: LocalizedStringResource {
        switch self {
        case .questionnaire:
            return LocalizedStringResource("TASK_CONTEXT_ACTION_QUESTIONNAIRE")
        case .test:
            return LocalizedStringResource("TASK_CONTEXT_ACTION_TEST")
        }
    }
}
