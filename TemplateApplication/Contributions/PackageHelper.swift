//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftPackageList


class PackageHelper {
    func getPackageList() -> [Package] {
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
