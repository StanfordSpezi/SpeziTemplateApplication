//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
@testable import TemplateApplication
import XCTest


class TemplateApplicationTests: XCTestCase {
    func testNegateBinding() throws {
        let trueBinding = Binding(
            get: { true },
            set: { newValue in
                XCTAssertTrue(newValue)
            }
        )
        let falseBinding = Binding(
            get: { false },
            set: { newValue in
                XCTAssertFalse(newValue)
            }
        )
        
        let negatedTrueBinding = !trueBinding
        let negatedFalseBinding = !falseBinding
        
        XCTAssertFalse(negatedTrueBinding.wrappedValue)
        XCTAssertTrue(negatedFalseBinding.wrappedValue)
        
        negatedTrueBinding.wrappedValue = false
        negatedFalseBinding.wrappedValue = true
    }
}
