//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftPackageList


enum LicenseType {
    case mit
    case apachev2
    case gplv2
    case gplv3
    
    var spdxIdentifier: String {
        switch self {
        case .mit: return "MIT"
        case .apachev2: return "Apache-2.0"
        case .gplv2: return "GPL-2.0"
        case .gplv3: return "GPL-3.0"
        }
    }
    
    var localizedName: String {
        let format = NSLocalizedString(
            "LICENSE_NAME",
            value: "%@ license",
            comment: "The license name displayed to the user (%@ is the license type, e.g. Apache-2.0)"
        )
        return .localizedStringWithFormat(format, spdxIdentifier)
    }
    
    init?(license: String) {
        if license.contains("MIT License") {
            self = .mit
        } else if license.contains("Apache License") && license.contains("Version 2.0") {
            self = .apachev2
        } else if license.contains("GNU GENERAL PUBLIC LICENSE") && license.contains("Version 2") {
            self = .gplv2
        } else if license.contains("GNU GENERAL PUBLIC LICENSE") && license.contains("Version 3") {
            self = .gplv3
        } else {
            return nil
        }
    }
}

extension Package {
    func getLicenseType(license: String?) -> LicenseType? {
        if let license = license {
            let licenseType = LicenseType(license: license)
            return licenseType
        }
        return nil
    }
}
