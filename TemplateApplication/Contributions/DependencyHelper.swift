//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation

class DependencyHelper {
    enum DependencyVersion {
        case branch(String)
        case versionNumber(String)
        case revision(String)
    }
    
    struct DependencyInformation {
        var dependencyVersion: DependencyVersion
        var dependencyWebsite: URL
    }
    
    private func getDependencyVersion(from state: [String: Any]) -> DependencyVersion? {
        if let branchName = state["branch"] as? String {
            return .branch(branchName)
        } else if let versionNumber = state["version"] as? String {
            return .versionNumber(versionNumber)
        } else if let revisionID = state["revision"] as? String {
            return .revision(revisionID)
        }
        return nil
    }
    
    private func getDependencyWebsite(from location: String) -> URL? {
        print(location)
        let locationURL = URL(string: location)
        return locationURL
    }
    
    func getAllDependencies() -> [String: DependencyInformation] {
        guard let packageFileURL = Bundle.main.url(forResource: "Package", withExtension: "json"),
              let packageFileData = try? Data(contentsOf: packageFileURL),
              let json = try? JSONSerialization.jsonObject(with: packageFileData) as? [String: Any],
              let pins = json["pins"] as? [[String: Any]] else {
            return [:]
        }
        
        var dependencies: [String: DependencyInformation] = [:]
        for pin in pins {
            if let name = pin["identity"] as? String,
               let location = pin["location"] as? String,
               let state = pin["state"] as? [String: Any],
               let dependencyVersion = getDependencyVersion(from: state),
               let dependencyWebsite = getDependencyWebsite(from: location) {
                let dependencyInfo = DependencyInformation(dependencyVersion: dependencyVersion, dependencyWebsite: dependencyWebsite)
                dependencies[name] = dependencyInfo
            }
            
        }
        return dependencies
    }
}
