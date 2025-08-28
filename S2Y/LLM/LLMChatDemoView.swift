//
// This source file is part of the S2Y application project
//
// SPDX-FileCopyrightText: 2025 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI


private enum LLMKeychain {
    static let service = "ai.cloudflare"
    static let account = "gateway.token"
}


private struct ChatMessage: Identifiable, Hashable {
    enum Role: String { case user, assistant }
    let id = UUID()
    let role: Role
    let content: String
}


struct LLMChatDemoView: View {
    @AppStorage("cf.gatewayURL") private var gatewayURL: String = Bundle.main.object(forInfoDictionaryKey: "CFWorkersAI.GatewayURL") as? String ?? ""
    @State private var modelPath: String = Bundle.main.object(forInfoDictionaryKey: "CFWorkersAI.ModelPath") as? String ?? ""
    @State private var cfToken: String = (Bundle.main.object(forInfoDictionaryKey: "CFWorkersAI.BearerToken") as? String) ?? ""
    @State private var inputText: String = ""
    @State private var isSending = false
    @State private var messages: [ChatMessage] = [
        .init(role: .assistant, content: "你好，我是 OpenAI 模型示例。请输入你的问题。")
    ]
    @State private var errorText: String?

    var body: some View {
        VStack(spacing: 0) {
            messagesView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            if let errorText { errorBanner(errorText) }
            inputBar
        }
        .navigationTitle("Chat")
        .onAppear(perform: loadKey)
    }

    // Removed settings form per request; values now come from Info.plist and Keychain.

    @ViewBuilder
    private var messagesView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(messages) { message in
                    messageRow(message)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }

    @ViewBuilder
    private func messageRow(_ message: ChatMessage) -> some View {
        HStack(alignment: .top) {
            if message.role == .assistant {
                Text("🤖").accessibilityHidden(true)
            } else {
                Text("🧑").accessibilityHidden(true)
            }
            Text(message.content)
                .padding(10)
                .background(message.role == .assistant ? Color.gray.opacity(0.15) : Color.blue.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    private func errorBanner(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(.red)
            .font(.footnote)
            .padding(.horizontal)
    }

    @ViewBuilder
    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: 8) {
            TextField("Type a message...", text: $inputText, axis: .vertical)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .lineLimit(1...4)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Button(action: send) {
                if isSending {
                    ProgressView()
                } else {
                    Image(systemName: "paperplane.fill").accessibilityLabel("Send message")
                }
            }
            .disabled(isSending || inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }

    private func loadKey() {
        if let data = readKeychain(service: LLMKeychain.service, account: LLMKeychain.account),
           let key = String(data: data, encoding: .utf8), !key.isEmpty {
            cfToken = key
        }
    }

    private func saveToken() {
        guard let data = cfToken.data(using: .utf8) else { return }
        _ = writeKeychain(service: LLMKeychain.service, account: LLMKeychain.account, data: data)
    }

    private func send() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        guard !cfToken.isEmpty else {
            errorText = "缺少访问令牌。请在系统设置或 Keychain 中配置。"
            return
        }
        guard !gatewayURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorText = "缺少服务地址。请在 Info.plist 配置 CFWorkersAI.GatewayURL。"
            return
        }
        // modelPath 允许为空（当 gatewayURL 已为完整终端点时）

        errorText = nil
        isSending = true
        let userMsg = ChatMessage(role: .user, content: text)
        messages.append(userMsg)
        inputText = ""

        Task {
            defer { isSending = false }
            do {
                let reply = try await completeChatCloudflare(messages: messages, gatewayURL: gatewayURL, modelPath: modelPath, token: cfToken)
                messages.append(.init(role: .assistant, content: reply))
            } catch {
                errorText = error.localizedDescription
            }
        }
    }

    private func completeChatCloudflare(messages: [ChatMessage], gatewayURL: String, modelPath: String, token: String) async throws -> String {
        let (url, useQueryField) = try buildCloudflareURL(gatewayURL: gatewayURL, modelPath: modelPath)
        let (prompt, lastUser) = composePrompts(messages)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try encodeCloudflareBody(useQueryField: useQueryField, prompt: prompt, lastUserMessage: lastUser)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard (200..<300).contains(http.statusCode) else {
            let text = String(data: data, encoding: .utf8) ?? ""
            throw NSError(domain: "CloudflareAIError", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: text])
        }
        return try parseCloudflareReply(data)
    }

    private func buildCloudflareURL(gatewayURL: String, modelPath: String) throws -> (URL, Bool) {
        var base = gatewayURL.trimmingCharacters(in: .whitespacesAndNewlines)
        if base.hasSuffix("/") { base.removeLast() }
        var path = modelPath.trimmingCharacters(in: .whitespacesAndNewlines)
        if path.hasPrefix("/") { path.removeFirst() }
        let full = path.isEmpty ? base : (base + "/" + path)
        guard let url = URL(string: full) else { throw URLError(.badURL) }
        return (url, full.contains("ai-search"))
    }

    private func composePrompts(_ messages: [ChatMessage]) -> (prompt: String, lastUser: String) {
        let lastUser = messages.last(where: { $0.role == .user })?.content ?? messages.last?.content ?? ""
        let prompt = messages.map { msg in
            switch msg.role {
            case .user: return "User: \(msg.content)"
            case .assistant: return "Assistant: \(msg.content)"
            }
        }.joined(separator: "\n")
        return (prompt, lastUser)
    }

    private func encodeCloudflareBody(useQueryField: Bool, prompt: String, lastUserMessage: String) throws -> Data {
        struct CFPayloadPrompt: Codable { let prompt: String }
        struct CFPayloadQuery: Codable { let query: String }
        if useQueryField {
            return try JSONEncoder().encode(CFPayloadQuery(query: lastUserMessage))
        } else {
            return try JSONEncoder().encode(CFPayloadPrompt(prompt: prompt))
        }
    }

    private func parseCloudflareReply(_ data: Data) throws -> String {
        struct CFResult: Codable {
            let response: String?
            let text: String?
            let outputText: String?
            let answer: String?
            enum CodingKeys: String, CodingKey {
                case response
                case text
                case outputText = "output_text"
                case answer
            }
        }
        struct CFResponse: Codable { let result: CFResult?; let success: Bool? }

        let decoded = try JSONDecoder().decode(CFResponse.self, from: data)
        let reply = decoded.result?.response
            ?? decoded.result?.text
            ?? decoded.result?.outputText
            ?? decoded.result?.answer
            ?? ""
        return reply.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


// MARK: - Minimal Keychain helpers

import Security

private func writeKeychain(service: String, account: String, data: Data) -> Bool {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecAttrAccount as String: account
    ]
    SecItemDelete(query as CFDictionary)
    let addQuery: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecAttrAccount as String: account,
        kSecValueData as String: data
    ]
    let status = SecItemAdd(addQuery as CFDictionary, nil)
    return status == errSecSuccess
}

private func readKeychain(service: String, account: String) -> Data? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecAttrAccount as String: account,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess, let data = item as? Data else { return nil }
    return data
}


