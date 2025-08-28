//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziQuestionnaire
import SpeziScheduler
import SpeziViews
import SwiftUI


struct EventView: View {
    private let event: Event
    
    @Environment(S2YApplicationStandard.self) private var standard
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewState: ViewState = .idle
    
    
    var body: some View {
        if let questionnaire = event.task.questionnaire {
            QuestionnaireView(questionnaire: questionnaire) { result in
                guard case let .completed(response) = result else { // user cancelled the task
                    dismiss()
                    return
                }
                
                do {
                    _ = try event.complete()
                    await standard.add(response: response, for: questionnaire)
                    dismiss()
                } catch {
                    viewState = .error(AnyLocalizedError(error: error))
                }
            }
                .viewStateAlert(state: $viewState)
                .onChange(of: viewState) { oldViewState, newViewState in
                    guard case .error = oldViewState, newViewState == .idle else {
                        return
                    }
                    dismiss()
                }
        } else {
            NavigationStack {
                ContentUnavailableView(
                    "Unsupported Event",
                    systemImage: "list.bullet.clipboard",
                    description: Text("This type of event is currently unsupported. Please contact the developer of this app.")
                )
                    .toolbar {
                        Button("Close") {
                            dismiss()
                        }
                    }
            }
        }
    }
    
    
    init(_ event: Event) {
        self.event = event
    }
}
