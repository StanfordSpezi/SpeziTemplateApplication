//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziFHIR


extension Foundation.Bundle {
    func questionnaire(withName name: String) -> Questionnaire {
        guard let resourceURL = self.url(forResource: name, withExtension: "json") else {
            fatalError("Could not find the questionnaire \"\(name).json\" in the bundle.")
        }
        
        do {
            let resourceData = try Data(contentsOf: resourceURL)
            return try JSONDecoder().decode(Questionnaire.self, from: resourceData)
        } catch {
            fatalError("Could not decode the FHIR questionnaire named \"\(name).json\": \(error)")
        }
    }
}
