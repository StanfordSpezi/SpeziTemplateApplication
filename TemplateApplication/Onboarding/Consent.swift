//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import class SpeziFHIR.FHIR
import SpeziHealthKit
import SpeziOnboarding
import SwiftUI


struct Consent: View {
    @EnvironmentObject private var onboardingNavigationPath: OnboardingNavigationPath
    
    private var consentDocument: Data {
        guard let path = Bundle.main.url(forResource: "ConsentDocument", withExtension: "md"),
              let data = try? Data(contentsOf: path) else {
            return Data("CONSENT_LOADING_ERROR".moduleLocalized.utf8)
        }
        return data
    }
    
    var body: some View {
        ConsentView(
            header: {
                OnboardingTitleView(
                    title: "CONSENT_TITLE".moduleLocalized,
                    subtitle: "CONSENT_SUBTITLE".moduleLocalized
                )
            },
            asyncMarkdown: {
                consentDocument
            },
            action: {
                onboardingNavigationPath.nextStep()
            }
        )
    }
}


#if DEBUG
struct Consent_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStack(startAtStep: Consent.self) {
            for onboardingView in OnboardingFlow.previewSimulatorViews {
                onboardingView
            }
        }
    }
}
#endif
