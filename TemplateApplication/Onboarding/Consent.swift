//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziConsent
import SpeziOnboarding
import SpeziViews
import SwiftUI


/// - Note: The `OnboardingConsentView` exports the signed consent form as PDF to the Spezi `Standard`, necessitating the conformance of the `Standard` to the `OnboardingConstraint`.
struct Consent: View {
    @Environment(ManagedNavigationStack.Path.self) private var managedNavigationPath
    @Environment(TemplateApplicationStandard.self) private var standard
    @State private var consentDocument: ConsentDocument?
    @State private var viewState: ViewState = .idle
    
    var body: some View {
        OnboardingConsentView(consentDocument: consentDocument, viewState: $viewState) {
            guard let consentDocument else {
                fatalError("Completing the consent document before loaded should not be possible.")
            }
            
            try await standard.store(consent: consentDocument)
            managedNavigationPath.nextStep()
        }
        .viewStateAlert(state: $viewState)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                // give your user the ability to obtain a PDF version of the consent document they just signed
                ConsentShareButton(
                    consentDocument: consentDocument,
                    viewState: $viewState
                )
            }
        }
        .task {
            guard let url = Bundle.main.url(forResource: "ConsentDocument", withExtension: "md") else {
                fatalError("Failed to load the consent document in the application bundle.")
            }
            
            do {
                consentDocument = try ConsentDocument(contentsOf: url)
            } catch {
                viewState = .error(AnyLocalizedError(error: error))
            }
        }
    }
}


#if DEBUG
#Preview {
    ManagedNavigationStack {
        Consent()
    }
    .previewWith(standard: TemplateApplicationStandard()) {}
}
#endif
