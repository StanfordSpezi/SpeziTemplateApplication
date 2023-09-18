//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftPackageList
import SwiftUI


struct ContributionsList: View {
    var packages: [Package] = PackageHelper.getPackageList()
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: Text("This project is licensed under the MIT License.")) {
                    Text("The following list contains all package dependencies SpeziTemplateApplication relies on.")
                }
                Section(header: Text("Packages"), footer: Text("For packages without license labels refer to the individual repository links.")) {
                    ForEach(packages.sorted(by: { $0.name < $1.name }), id: \.name) { package in
                        PackageCell(package: package)
                    }
                }
            }.navigationTitle("SpeziTemplateApplication")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#if DEBUG
struct ContributionsList_Previews: PreviewProvider {
    static var previews: some View {
        let mockPackages = [
            Package(
                name: "mockPackage",
                version: "1.0",
                branch: nil,
                revision: "0",
                repositoryURL: URL(string: "github.com")!,
                license: "MIT License"
            )
        ]
        return ContributionsList(packages: mockPackages)
    }
}
#endif
