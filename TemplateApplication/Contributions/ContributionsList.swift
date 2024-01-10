//
// This source file is part of the Stanford Spezi Template Application open-source project
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
            List {
                Section(footer: Text("PROJECT_LICENSE_DESCRIPTION")) {
                    Text("CONTRIBUTIONS_LIST_DESCRIPTION")
                }
                Section(
                    header: Text("CONTRIBUTIONS_LIST_HEADER"),
                    footer: Text("CONTRIBUTIONS_LIST_FOOTER")
                ) {
                    ForEach(packages.sorted(by: { $0.name < $1.name }), id: \.name) { package in
                        PackageCell(package: package)
                    }
                }
            }
                .navigationTitle("LICENSE_INFO_TITLE")
                .navigationBarTitleDisplayMode(.inline)
    }
}


#if DEBUG
#Preview {
    let mockPackages = [
        Package(
            name: "MockPackage",
            version: "1.0",
            branch: nil,
            revision: "0",
            // We use a force unwrap in the preview as we can not recover from an error here
            // and the code will never end up in a production environment.
            // swiftlint:disable:next force_unwrapping
            repositoryURL: URL(string: "github.com")!,
            license: "MIT License"
        )
    ]
    return ContributionsList(packages: mockPackages)
}
#endif
