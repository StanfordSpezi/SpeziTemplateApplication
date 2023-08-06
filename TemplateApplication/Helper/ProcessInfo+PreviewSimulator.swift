//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension ProcessInfo {
    var isPreviewSimulator: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
