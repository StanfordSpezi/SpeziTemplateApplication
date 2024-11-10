//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2024 Stanford University
//
// SPDX-License-Identifier: MIT
//

import OSLog
import Spezi
import SwiftUI


struct LogViewer: View {
    @Environment(LogManager.self) var manager
    
    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    @State private var endDate = Date()
    @State private var selectedLogLevel: LogLevel = .all
    @State private var logs: [OSLogEntryLog] = []
    @State private var isLoading = false
    @State private var queryTask: Task<Void, Never>?
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            VStack {
                DatePicker("LOGS_FROM_DATE_LABEL", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                DatePicker("LOGS_TO_DATE_LABEL", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                HStack {
                    Text("LOGS_LEVEL_LABEL")
                    Spacer()
                    Picker("LOGS_LEVEL_LABEL", selection: $selectedLogLevel) {
                        ForEach(LogLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }
            }
            .padding()
            
            if isLoading {
                Spacer()
                ProgressView("LOGS_LOADING_LABEL").padding()
                Spacer()
            } else {
                LogsListView(logs: logs)
            }
            
            Spacer()
        }
        .navigationTitle("LOGS_VIEWER_TITLE")
        .onAppear {
            queryLogs()
        }
        .onChange(of: startDate) {
            queryLogs()
        }
        .onChange(of: endDate) {
            queryLogs()
        }
        .onChange(of: selectedLogLevel) {
            queryLogs()
        }
        .toolbar {
            if !logs.isEmpty {
                ShareLink(
                    item: logs.formattedLogOutput(),
                    preview: SharePreview(
                        "LOGS_SHARE_PREVIEW_TITLE",
                        image: Image(systemName: "doc.text") // swiftlint:disable:this accessibility_label_for_image
                    )
                ) {
                    Image(systemName: "square.and.arrow.up") // swiftlint:disable:this accessibility_label_for_image
                }
            }
        }
        .alert(errorMessage, isPresented: $showingAlert) {
                   Button("OK", role: .cancel) { }
        }
    }
    
    private func queryLogs() {
        /// Cancel any existing query task
        queryTask?.cancel()
        
        /// Set loading state
        isLoading = true
        
        /// Create a new query task and store it
        queryTask = Task(priority: .userInitiated) { [manager, startDate, endDate, selectedLogLevel] in
            do {
                /// Run the query
                let result = try await manager.query(
                    startDate: startDate,
                    endDate: endDate,
                    logLevel: selectedLogLevel.osLogLevel
                )
                
                /// Check to make sure the task isn't cancelled before updating UI
                guard !Task.isCancelled else {
                    return
                }
                
                /// Update the UI
                await MainActor.run {
                    logs = result
                    isLoading = false
                }
            } catch {
                errorMessage = error.localizedDescription
                self.showingAlert = true
            }
        }
    }
}
