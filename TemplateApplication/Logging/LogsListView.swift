//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import OSLog
import SwiftUI


struct LogsListView: View {
    var logs: [OSLogEntryLog]
    
    var body: some View {
        if !logs.isEmpty {
            List(logs, id: \.self) { entry in
                VStack(alignment: .leading) {
                    Text(entry.date.formatted())
                        .font(.caption)
                    HStack {
                        Text(entry.category)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(2)
                            .background(Color(.systemGray5))
                            .cornerRadius(4)
                        Text(LogLevel(from: entry.level).rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(2)
                            .background(LogLevel(from: entry.level).color)
                            .cornerRadius(4)
                    }
                    Text(entry.composedMessage)
                }
            }
        } else {
            ContentUnavailableView("NO_LOGS_AVAILABLE", systemImage: "magnifyingglass")
        }
    }
}
