//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SwiftUI


struct AccountRequiredModifier: ViewModifier {
    private let required: Bool

    @EnvironmentObject private var account: Account
    @Binding private var presentingAccount: Bool

    func body(content: Content) -> some View {
        if required {
            content
                .onChange(of: [account.signedIn, presentingAccount]) { _ in
                    if !account.signedIn && !presentingAccount {
                        presentingAccount = true
                    }
                }
                .task {
                    try? await Task.sleep(for: .milliseconds(500))
                    if !account.signedIn {
                        presentingAccount = true
                    }
                }
                .environment(\.accountRequired, true)
        } else {
            content
        }
    }

    
    init(required: Bool, presentingAccount: Binding<Bool>) {
        self.required = required
        self._presentingAccount = presentingAccount
    }
}


extension View {
    func accountRequired(_ required: Bool = true, sheetPresented presentingAccount: Binding<Bool>) -> some View {
        modifier(AccountRequiredModifier(required: required, presentingAccount: presentingAccount))
    }
}
