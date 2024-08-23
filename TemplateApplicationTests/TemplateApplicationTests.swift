//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

@testable import TemplateApplication
import XCTest


class TemplateApplicationTests: XCTestCase {
    @MainActor
    func testContactsCount() throws {
        XCTAssertEqual(Contacts(presentingAccount: .constant(true)).contacts.count, 1)
    }
}
