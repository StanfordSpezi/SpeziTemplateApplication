//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziOnboarding
import SwiftUI


/// - Note: The `OnboardingConsentView` exports the signed consent form as PDF to the Spezi `Standard`, necessitating the conformance of the `Standard` to the `OnboardingConstraint`.
struct Consent: View {
    // OnboardingNavigationPath removed in SpeziOnboarding 2.x
    
    
    private var consentDocument: Data {
        guard let path = Bundle.main.url(forResource: "ConsentDocument", withExtension: "md"),
              let data = try? Data(contentsOf: path) else {
            return Data(String(localized: "CONSENT_LOADING_ERROR").utf8)
        }
        return data
    }
    
    var body: some View {
        OnboardingView(
            header: {
                OnboardingTitleView(title: "Consent", subtitle: "")
            },
            content: {
                ScrollView {
                    Text(String(decoding: consentDocument, as: UTF8.self))
                        .padding()
                }
            },
            footer: {
                OnboardingActionsView("Continue", action: {})
            }
        )
    }
}


#if DEBUG
#Preview {
    Consent()
        .previewWith(standard: S2YApplicationStandard()) {
        }
}
#endif
