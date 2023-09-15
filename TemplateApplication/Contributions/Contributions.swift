//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct Contributions: View {
    let dependencies: [String: DependencyHelper.DependencyInformation] = DependencyHelper().getAllDependencies()
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: Text("This project is licensed under the MIT License.")) {
                    Text("The following list contains all package dependencies SpeziTemplateApplication relies on.")
                }
                Section(header: Text("Packages"), footer: Text("For the package licenses refer to the individual links.")) {
                    ForEach(dependencies.sorted(by: { $0.key < $1.key }), id: \.key) { dependency in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(dependency.key)
                                    .font(.headline)
                                switch dependency.value.dependencyVersion {
                                case let .branch(name):
                                    Text("Branch: \(name)")
                                case let .revision(code):
                                    Text("Revision: \(code)")
                                case let .versionNumber(version):
                                    Text("Version: \(version)")
                                }
                            }
                            Spacer()
                            Button(action: {
                                UIApplication.shared.open(dependency.value.dependencyWebsite)
                            }) {
                                Image(systemName: "safari.fill")
                            }.foregroundColor(.blue)
                        }
                    }
                }
            }.navigationTitle("SpeziTemplateApplication")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct Contributions_Previews: PreviewProvider {
    static var previews: some View {
        Contributions()
    }
}
