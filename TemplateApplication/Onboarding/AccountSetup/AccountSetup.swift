//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import class SpeziFHIR.FHIR
import FirebaseAuth
import HealthKit
import SpeziFirebaseAccount
import SpeziHealthKit
import SpeziOnboarding
import SwiftUI


struct AccountSetup: View {
    @EnvironmentObject var account: Account
    @EnvironmentObject private var onboardingNavigationPath: OnboardingNavigationPath
    @State var signingOutPretrigger = false
    
    var body: some View {
        OnboardingView(
            contentView: {
                VStack {
                    OnboardingTitleView(
                        title: "ACCOUNT_TITLE".moduleLocalized,
                        subtitle: "ACCOUNT_SUBTITLE".moduleLocalized
                    )
                    Spacer(minLength: 0)
                    accountImage
                    accountDescription
                    Spacer(minLength: 0)
                }
            }, actionView: {
                actionView
            }
        )
        .onReceive(account.objectWillChange) {
            if !signingOutPretrigger {
                if account.signedIn {
                    onboardingNavigationPath.nextStep()
                }
            } else {
                signingOutPretrigger = false
            }
        }
    }
    
    @ViewBuilder
    private var accountImage: some View {
        Group {
            if account.signedIn {
                Image(systemName: "person.badge.shield.checkmark.fill")
            } else {
                Image(systemName: "person.fill.badge.plus")
            }
        }
            .font(.system(size: 150))
            .foregroundColor(.accentColor)
    }
    
    @ViewBuilder
    private var accountDescription: some View {
        VStack {
            Group {
                if account.signedIn {
                    Text("ACCOUNT_SIGNED_IN_DESCRIPTION")
                } else {
                    Text("ACCOUNT_SETUP_DESCRIPTION")
                }
            }
                .multilineTextAlignment(.center)
                .padding(.vertical, 16)
            if account.signedIn {
                UserView()
                    .padding()
                Button("Logout", role: .destructive) {
                    signingOutPretrigger = true
                    try? Auth.auth().signOut()
                }
            }
        }
    }
    
    @ViewBuilder
    private var actionView: some View {
        if account.signedIn {
            OnboardingActionsView(
                "ACCOUNT_NEXT".moduleLocalized,
                action: {
                    onboardingNavigationPath.nextStep()
                }
            )
        } else {
            OnboardingActionsView(
                primaryText: "ACCOUNT_SIGN_UP".moduleLocalized,
                primaryAction: {
                    onboardingNavigationPath.append(customView: TemplateSignUp())
                },
                secondaryText: "ACCOUNT_LOGIN".moduleLocalized,
                secondaryAction: {
                    onboardingNavigationPath.append(customView: TemplateLogin())
                }
            )
        }
    }
    
    // Might be useful regarding the notification disablement
    /*
    private func moveToNextOnboardingStep() async {
        // Unfortunately, SwiftUI currently animates changes in the navigation path that do not change
        // the current top view. Therefore we need to do the following async procedure to remove the
        // `.login` and `.signUp` steps while disabling the animations before and re-enabling them
        // after the elements have been changed.
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.0))
            UIView.setAnimationsEnabled(false)
            onboardingSteps.removeAll(where: { $0 == .login || $0 == .signUp })
            try? await Task.sleep(for: .seconds(1.0))
            UIView.setAnimationsEnabled(true)
        }
    }
     */
}


#if DEBUG
struct AccountSetup_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetup()
            .environmentObject(Account(accountServices: []))
            .environmentObject(FirebaseAccountConfiguration<FHIR>(emulatorSettings: (host: "localhost", port: 9099)))
    }
}
#endif
