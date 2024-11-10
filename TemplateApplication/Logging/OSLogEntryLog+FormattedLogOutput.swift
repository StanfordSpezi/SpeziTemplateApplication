//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import OSLog


extension Array where Element == OSLogEntryLog {
    func formattedLogOutput() -> String {
        self.map { entry in
            "[\(entry.date.formatted())] [\(entry.category)] [\(entry.level.rawValue)]: \(entry.composedMessage)"
        }
        .joined(separator: "\n")
    }
}
