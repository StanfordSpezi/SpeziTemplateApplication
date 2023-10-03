//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation


/// Represents errors that may occur during handling the storage of exported consent forms.
enum ConsentExportError: Error {
    case documentDirectoryNotFound
    case noConsentFormsFound
    case readError
}
