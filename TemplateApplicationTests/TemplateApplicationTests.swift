//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

@testable import TemplateApplication
import Testing


@Suite("Template Application Tests")
struct TemplateApplicationTests {
    @Test("Contacts count")
    @MainActor
    func contactsCount() {
        #expect(Contacts(presentingAccount: .constant(true)).contacts.count == 1)
    }
}
