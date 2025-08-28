//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import FirebaseFirestore
@preconcurrency import FirebaseStorage
import HealthKitOnFHIR
import OSLog
@preconcurrency import PDFKit.PDFDocument
import Spezi
import SpeziAccount
import SpeziFirebaseAccount
import SpeziFirestore
import SpeziHealthKit
import SpeziOnboarding
import SpeziQuestionnaire
import SwiftUI


actor S2YApplicationStandard: Standard,
                                   EnvironmentAccessible,
                                   HealthKitConstraint,
                                   AccountNotifyConstraint {
    @Application(\.logger) private var logger
    
    @Dependency(FirebaseConfiguration.self) private var configuration
    
    
    init() {}
    
    
    func handleNewSamples<Sample>(_ addedSamples: some Collection<Sample>, ofType sampleType: SampleType<Sample>) async {
        for sample in addedSamples {
            if FeatureFlags.disableFirebase {
                logger.debug("Received new HealthKit sample: \(sample)")
                return
            }
            
            do {
                try await healthKitDocument(for: sampleType, sampleId: sample.id)
                    .setData(from: sample.resource())
            } catch {
                logger.error("Could not store HealthKit sample: \(error)")
            }
        }
    }
    
    func handleDeletedObjects<Sample>(_ deletedObjects: some Collection<HKDeletedObject>, ofType sampleType: SampleType<Sample>) async {
        for object in deletedObjects {
            if FeatureFlags.disableFirebase {
                logger.debug("Received new removed healthkit sample with id \(object.uuid)")
                return
            }
            
            do {
                try await healthKitDocument(for: sampleType, sampleId: object.uuid).delete()
            } catch {
                logger.error("Could not remove HealthKit sample: \(error)")
            }
        }
    }
    
    // periphery:ignore:parameters isolation
    func add(
        response: ModelsR4.QuestionnaireResponse,
        for questionnaire: ModelsR4.Questionnaire,
        isolation: isolated (any Actor)? = #isolation
    ) async {
        let responseId = response.identifier?.value?.value?.string ?? UUID().uuidString
        let questionnaireId = questionnaire.id?.value?.string
        
        if FeatureFlags.disableFirebase {
            let jsonRepresentation = (try? String(data: JSONEncoder().encode(response), encoding: .utf8)) ?? ""
            await logger.debug("Received questionnaire response \(jsonRepresentation) for questionnaire: \(questionnaireId ?? "unkown")")
            return
        }
        
        do {
            let collection = if let questionnaireId = questionnaireId {
                "QuestionnaireResponses_\(questionnaireId)"
            } else {
                "QuestionnaireResponses"
            }
            try await configuration.userDocumentReference
                .collection(collection)
                .document(responseId)
                .setData(from: response)
        } catch {
            await logger.error("Could not store questionnaire response: \(error)")
        }
    }
    
    private func healthKitDocument(for sampleType: SampleType<some Any>, sampleId uuid: UUID) async throws -> FirebaseFirestore.DocumentReference {
        try await configuration.userDocumentReference
            .collection("Observations_\(sampleType.displayTitle.replacingOccurrences(of: "\\s", with: "", options: .regularExpression))")
            .document(uuid.uuidString)
    }
    
    func respondToEvent(_ event: AccountNotifications.Event) async {
        if case let .deletingAccount(accountId) = event {
            do {
                try await configuration.userDocumentReference(for: accountId).delete()
            } catch {
                logger.error("Could not delete user document: \(error)")
            }
        }
    }
    
    // Consent export handling removed for SpeziOnboarding 2.x migration.
}
