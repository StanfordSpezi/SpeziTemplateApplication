//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftPackageList
import SwiftUI


struct Contributions: View {
    var packages: [Package] = PackageHelper.getPackageList()
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: Text("This project is licensed under the MIT License.")) {
                    Text("The following list contains all package dependencies SpeziTemplateApplication relies on.")
                }
                Section(header: Text("Packages"), footer: Text("For packages without license labels refer to the individual repository links.")) {
                    ForEach(packages.sorted(by: { $0.name < $1.name }), id: \.name) { package in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(package.name).font(.headline)
                                HStack {
                                    Text(getPackageDetails(package: package))
                                        .font(.caption)
                                        .padding(2)
                                    if let licenseType = package.getLicenseType(license: package.license) {
                                        Text(licenseType.spdxIdentifier)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .padding(2)
                                            .background(Color(.systemGray5))
                                            .cornerRadius(4)
                                    }
                                }
                            }
                            Spacer()
                            Button(action: {
                                UIApplication.shared.open(package.repositoryURL)
                            }) {
                                Image(systemName: "safari.fill").imageScale(.large)
                            }.foregroundColor(.blue)
                        }
                    }
                }
            }.navigationTitle("SpeziTemplateApplication")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func getPackageDetails(package: Package) -> String {
        if let branch = package.branch {
            return "Branch: \(branch)"
        } else if let version = package.version {
            return "Version: \(version)"
        } else {
            return "Revision: \(package.revision)"
        }
    }
}


#if DEBUG
struct Contributions_Previews: PreviewProvider {
    static var previews: some View {
        guard let url = URL(string: "github.com") else {
            return Contributions()
        }
        let mockPackages = [
            Package(
                name: "mockPackage",
                version: "1.0",
                branch: nil,
                revision: "0",
                repositoryURL: url,
                license: "MIT License"
            )
        ]
        return Contributions(packages: mockPackages)
    }
}
#endif
