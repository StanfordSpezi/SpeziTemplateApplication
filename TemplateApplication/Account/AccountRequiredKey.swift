//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct AccountRequiredKey: EnvironmentKey {
    static let defaultValue = false
}


extension EnvironmentValues {
    var accountRequired: Bool {
        get {
            self[AccountRequiredKey.self]
        }
        set {
            self[AccountRequiredKey.self] = newValue
        }
    }
}
