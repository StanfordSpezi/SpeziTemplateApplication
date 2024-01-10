//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftPackageList


// This section of code is based on the SwiftPackageList package:
// - Original code: https://github.com/FelixHerrmann/swift-package-list/issues/43
enum LicenseType {
    case mit
    case apachev2
    case gplv2
    case gplv3
    case bsd2
    case bsd3
    case bsd4
    case zlib
    
    /// SPDX-License-Identifier for the UI
    var spdxIdentifier: String {
        switch self {
        case .mit: return "MIT"
        case .apachev2: return "Apache-2.0"
        case .gplv2: return "GPL-2.0"
        case .gplv3: return "GPL-3.0"
        case .bsd2: return "BSD-2-Clause"
        case .bsd3: return "BSD-3-Clause"
        case .bsd4: return "BSD-4-Clause"
        case .zlib: return "Zlib"
        }
    }
    
    /// Initializer that scans the license document for common licenses and versions
    init?(license: String) {
        let license = license
            .replacingOccurrences(of: "\\s+|\\n", with: " ", options: .regularExpression)
        
        if license.contains(mitText) {
            self = .mit
        } else if license.contains(apacheText) && license.contains("Version 2.0") {
            self = .apachev2
        } else if license.contains(gnuText) && license.contains("Version 2") {
            self = .gplv2
        } else if license.contains(gnuText) && license.contains("Version 3") {
            self = .gplv3
        } else if license.contains(bsdFourClauseText) {
            self = .bsd4
        } else if license.range(of: bsdThreeClausePattern, options: .regularExpression) != nil {
            self = .bsd3
        } else if license.contains(bsdTwoClauseText) {
            self = .bsd2
        } else if license.range(of: zlibPattern, options: .regularExpression) != nil {
            self = .zlib
        } else {
            return nil
        }
    }
}


// Constants representing typical text and regular expression patterns often found in license files.
// They are used for matching and identifying different types of licenses within text documents.
private let mitText = "MIT License"
private let apacheText = "Apache License"
private let gnuText = "GNU GENERAL PUBLIC LICENSE"
private let bsdTwoClauseText =
    """
    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met
    """
private let bsdThreeClausePattern =
    """
    Neither the name of (.+) nor the names of (.+) may be used to endorse or promote products derived from this software \
    without specific prior written permission
    """
private let bsdFourClauseText =
    """
    All advertising materials mentioning features or use of this software must display the following acknowledgement: \
    this product includes software developed by
    """
private let zlibPattern =
    """
    The origin of this software must not be misrepresented; you must not claim that you wrote the original software. \
    If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.(.*) \
    Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.(.*) \
    This notice may not be removed or altered from any source distribution.
    """


extension Package {
    /// Generates the `LicenseType` from a license document of `String`
    func getLicenseType(license: String?) -> LicenseType? {
        if let license = license {
            let licenseType = LicenseType(license: license)
            return licenseType
        }
        return nil
    }
}
