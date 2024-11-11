//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import OSLog
import Spezi
import SwiftUI

/// Manages log entries within the application using `OSLogStore`, allowing querying
/// based on date ranges and log levels.
class LogManager {
    /// Reference to the `OSLogStore`, which provides access to system logs.
    private let store: OSLogStore?

    /// Initializes the `LogManager` and attempts to set up the `OSLogStore` with
    /// a scope limited to the current process identifier.
    ///
    /// - Throws: An error if the `OSLogStore` cannot be initialized.
    init() throws {
        do {
            self.store = try OSLogStore(scope: .currentProcessIdentifier)
        } catch {
            throw error
        }
    }

    /// Queries logs within a specified date range and optional log level.
    ///
    /// - Parameters:
    ///   - startDate: The start date from which logs should be queried.
    ///   - endDate: An optional end date up to which logs should be queried.
    ///   - logLevel: An optional log level filter, returning only entries of this level if specified.
    /// - Returns: An array of `OSLogEntryLog` entries that match the specified criteria.
    /// - Throws: `LogManagerError.invalidLogStore` if `OSLogStore` is unavailable, or
    ///           `LogManagerError.invalidBundleIdentifier` if the bundle identifier cannot be retrieved.
    func query(
        startDate: Date,
        endDate: Date? = nil,
        logLevel: OSLogEntryLog.Level? = nil
    ) throws -> [OSLogEntryLog] {
        guard let store else {
            throw LogManagerError.invalidLogStore
        }
        
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            throw LogManagerError.invalidBundleIdentifier
        }

        let position = store.position(date: startDate)
        let predicate = NSPredicate(format: "subsystem == %@", bundleIdentifier)
        let logs = try store.getEntries(at: position, matching: predicate)
            .reversed()
            .compactMap { $0 as? OSLogEntryLog }

        return logs
            .filter { logEntry in
                /// Filter by log type if specified
                if let logLevel, logEntry.level != logLevel {
                    return false
                }

                /// Filter by end date if specified
                if let endDate, logEntry.date > endDate {
                    return false
                }

                return true
            }
    }
}
