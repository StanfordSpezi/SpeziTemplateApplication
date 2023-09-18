//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import SwiftPackageList

struct PackageCell: View {
    let package: Package
    
    var body: some View {
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
            }.buttonStyle(PlainButtonStyle())
                .foregroundColor(.blue)
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
struct PackageCell_Previews: PreviewProvider {
    static var previews: some View {
        let mockPackage = Package(
            name: "mockPackage",
            version: "1.0",
            branch: nil,
            revision: "0",
            repositoryURL: URL(string: "github.com")!,
            license: "MIT License"
        )
        return PackageCell(package: mockPackage).previewLayout(.sizeThatFits)
    }
}
#endif
