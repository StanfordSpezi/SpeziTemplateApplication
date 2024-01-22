//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI

/// Enable consent for your app.
///
/// The Consent view allows users to sign a custom markdown ConsentDocument for your app.
///
/// - Note: The `OnboardingConsentView` exports the signed consent form as PDF to the Spezi `Standard`, necessitating the conformance of the `Standard` to the `OnboardingConstraint`.
///
/// ![A screenshot of the Consent screen](Consent)

struct Consent: View {
    @Environment(OnboardingNavigationPath.self) private var onboardingNavigationPath
    
    
    private var consentDocument: Data {
        guard let path = Bundle.main.url(forResource: "ConsentDocument", withExtension: "md"),
              let data = try? Data(contentsOf: path) else {
            return Data(String(localized: "CONSENT_LOADING_ERROR").utf8)
        }
        return data
    }
    
    
    var body: some View {
        OnboardingConsentView(
            markdown: {
                consentDocument
            },
            action: {
                onboardingNavigationPath.nextStep()
            }
        )
    }
}


#if DEBUG
#Preview {
    OnboardingStack {
        Consent()
    }
        .previewWith(standard: TemplateApplicationStandard()) {
            OnboardingDataSource()
        }
}
#endif
