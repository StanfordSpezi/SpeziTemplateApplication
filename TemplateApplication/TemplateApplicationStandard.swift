//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SpeziHealthKit
import SpeziQuestionnaire
import SwiftUI


actor TemplateApplicationStandard: Standard, HealthKitConstraint, QuestionnaireConstraint {
    func add(sample: HKSample) async {
        fatalError("Not implemented ...")
    }
    
    func remove(sample: HKDeletedObject) async {
        fatalError("Not implemented ...")
    }
    
    func add(response: ModelsR4.QuestionnaireResponse) async {
        fatalError("Not implemented ...")
    }
}
