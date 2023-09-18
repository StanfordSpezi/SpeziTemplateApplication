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
    let packages: [Package] = PackageHelper().getPackageList()
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: Text("This project is licensed under the MIT License.")) {
                    Text("The following list contains all package dependencies SpeziTemplateApplication relies on.")
                }
                Section(header: Text("Packages"), footer: Text("For packages without license labels refer to the individual repository links.")) {
                    ForEach(packages.sorted(by: { $0.name < $1.name }), id: \.name) { dependency in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(dependency.name).font(.headline)
                                HStack {
                                    if let branch = dependency.branch { Text("Branch: \(branch)").font(.caption).padding(2)
                                    } else if let version = dependency.version { Text("Version: \(version)").font(.caption).padding(2)
                                    } else { Text("Revision: \(dependency.revision)").font(.caption).padding(2) }
                                    
                                    if let licenseType = dependency.getLicenseType(license: dependency.license) {
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
                                UIApplication.shared.open(dependency.repositoryURL)
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
}


#if DEBUG
struct Contributions_Previews: PreviewProvider {
    static var previews: some View {
        Contributions()
    }
}
#endif
