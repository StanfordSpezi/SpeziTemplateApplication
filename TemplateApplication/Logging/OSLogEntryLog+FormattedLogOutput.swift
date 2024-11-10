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
            let timestamp = entry.date.formatted()
            let level = entry.level.rawValue
            let category = entry.category
            let message = entry.composedMessage
            
            return "[\(timestamp)] [\(category)] [\(level)]: \(message)"
        }
        .joined(separator: "\n")
    }
}
