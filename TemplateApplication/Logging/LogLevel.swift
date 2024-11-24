//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import OSLog
import SwiftUI


enum LogLevel: String, CaseIterable, Identifiable {
    case all = "All"
    case info = "Info"
    case debug = "Debug"
    case error = "Error"
    case fault = "Fault"
    case notice = "Notice"
    case undefined = "Undefined"
    
    var id: String { self.rawValue }
    
    var osLogLevel: OSLogEntryLog.Level? {
        switch self {
        case .all:
            return nil
        case .info:
            return .info
        case .debug:
            return .debug
        case .error:
            return .error
        case .fault:
            return .fault
        case .notice:
            return .notice
        case .undefined:
            return .undefined
        }
    }
    
    var color: Color {
        switch self {
        case .info:
            return .blue
        case .debug:
            return .green
        case .error:
            return .red
        case .fault:
            return .purple
        case .notice:
            return .orange
        case .all, .undefined:
            return .gray
        }
    }
    
    init(from osLogLevel: OSLogEntryLog.Level) {
        switch osLogLevel {
        case .info:
            self = .info
        case .debug:
            self = .debug
        case .error:
            self = .error
        case .fault:
            self = .fault
        case .notice:
            self = .notice
        @unknown default:
            self = .undefined
        }
    }
}
