//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftPackageList


enum PackageHelper {
    /// Helper function that calls the corrensponding API of `SwiftPackageList`to fetch the list of packages
    static func getPackageList() -> [Package] {
        do {
            let packages = try packageList()
            return packages
        } catch PackageListError.noPackageList {
            print("There is no package-list file")
        } catch {
            print(error)
        }
        return []
    }
}
