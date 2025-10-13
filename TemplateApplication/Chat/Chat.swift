//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziLLM
import SpeziLLMOpenAI
import SwiftUI


struct Chat: View {
    static let schema = LLMOpenAISchema(
        parameters: .init(
            modelType: .gpt4o,
            systemPrompt: "You're a helpful assistant that answers questions from users."
        )
    )
    
    @Environment(Account.self) private var account: Account?
    @LLMSessionProvider(schema: Self.schema) var llm: LLMOpenAISession
    
    @Binding var presentingAccount: Bool
    
    @State var muted = true
    
    
    var body: some View {
        NavigationStack {
            LLMChatView(session: $llm)
                .speak(llm.context.chat, muted: muted)
                .speechToolbarButton(muted: $muted)
                .navigationTitle("Chat")
                .toolbar {
                    if account != nil {
                        AccountButton(isPresented: $presentingAccount)
                    }
                }
        }
    }
    
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}
