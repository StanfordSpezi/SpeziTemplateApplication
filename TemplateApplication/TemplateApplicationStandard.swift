//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import HealthKitOnFHIR
import OSLog
import Spezi
import SpeziFirestore
import SpeziHealthKit
import SpeziMockWebService
import SpeziQuestionnaire
import SwiftUI


actor TemplateApplicationStandard: Standard, ObservableObject, ObservableObjectProvider, HealthKitConstraint, QuestionnaireConstraint {
    enum TemplateApplicationStandardError: Error {
        case userNotAuthenticatedYet
    }
    
    
    @Dependency var mockWebService = MockWebService()
    private let logger = Logger(subsystem: "TemplateApplication", category: "Standard")
    
    
    private var userDocumentReference: DocumentReference {
        get throws {
            guard let user = Auth.auth().currentUser else {
                throw TemplateApplicationStandardError.userNotAuthenticatedYet
            }
            
            return Firestore.firestore().collection("users").document(user.uid)
        }
    }
    
    
    func signedIn() async {
        guard !FeatureFlags.disableFirebase else {
            try? await mockWebService.upload(path: "user", body: "Login")
            return
        }
        
        // TODO remove firebase dependence
        guard let user = Auth.auth().currentUser else {
            logger.error("Signed In called respite no authenticated user.")
            return
        }
        
        let name = user.displayName?.components(separatedBy: " ")
        let data: [String: Any] = [
            "id": user.uid,
            "firstName": name?.first ?? "",
            "lastName": name?.last ?? ""
        ]
        
        do {
            try await userDocumentReference.setData(data)
        } catch {
            logger.error("Could not store user information in Firebase: \(error)")
        }
    }
    
    func add(sample: HKSample) async {
        guard !FeatureFlags.disableFirebase else {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
            let jsonRepresentation = (try? String(data: encoder.encode(sample.resource), encoding: .utf8)) ?? ""
            try? await mockWebService.upload(path: "healthkit/\(sample.uuid.uuidString)", body: jsonRepresentation)
            return
        }
        
        do {
            try await healthKitDocument(id: sample.id).setData(from: sample.resource)
        } catch {
            logger.error("Could not store HealthKit sample: \(error)")
        }
    }
    
    func remove(sample: HKDeletedObject) async {
        guard !FeatureFlags.disableFirebase else {
            try? await mockWebService.remove(path: "healthkit/\(sample.uuid.uuidString)")
            return
        }
        
        do {
            try await healthKitDocument(id: sample.uuid).delete()
        } catch {
            logger.error("Could not remove HealthKit sample: \(error)")
        }
    }
    
    func add(response: ModelsR4.QuestionnaireResponse) async {
        let id = response.identifier?.value?.value?.string ?? UUID().uuidString
        
        guard !FeatureFlags.disableFirebase else {
            let jsonRepresentation = (try? String(data: JSONEncoder().encode(response), encoding: .utf8)) ?? ""
            try? await mockWebService.upload(path: "questionnaireResponse/\(id)", body: jsonRepresentation)
            return
        }
        
        do {
            try await userDocumentReference
                .collection("QuestionnaireResponse") // Add all HealthKit sources in a /QuestionnaireResponse collection.
                .document(id) // Set the document identifier to the id of the response.
                .setData(from: response)
        } catch {
            logger.error("Could not store questionnaire response: \(error)")
        }
    }
    
    
    private func healthKitDocument(id uuid: UUID) throws -> DocumentReference {
        try userDocumentReference
            .collection("HealthKit") // Add all HealthKit sources in a /HealthKit collection.
            .document(uuid.uuidString) // Set the document identifier to the UUID of the document.
    }
}
