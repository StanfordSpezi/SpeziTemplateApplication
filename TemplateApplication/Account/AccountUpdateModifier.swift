//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SwiftUI


struct AccountUpdateModifier: ViewModifier {
    @EnvironmentObject private var standard: TemplateApplicationStandard
    @EnvironmentObject private var account: Account


    func body(content: Content) -> some View {
        if !FeatureFlags.disableFirebase {
            content
                .onReceive(account.$details) { newValue in
                    if let newValue {
                        Task {
                            // we catch any changes to the account globally
                            await standard.updateAccount(details: newValue)
                        }
                    }
                }
        } else {
            content
        }
    }
}


extension View {
    func standardAccountUpdate() -> some View {
        modifier(AccountUpdateModifier())
    }
}
