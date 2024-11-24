//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

enum LogManagerError: Error {
    /// Throw when the log store is invalid
    case invalidLogStore
    /// Throw when the bundle identifier is invalid
    case invalidBundleIdentifier
}

extension LogManagerError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidLogStore:
            return "The OSLogStore is invalid."
        case .invalidBundleIdentifier:
            return "The bundle identifier is invalid."
        }
    }
}
