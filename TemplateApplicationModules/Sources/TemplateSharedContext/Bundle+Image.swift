//
// This source file is part of the Stanford CardinalKit Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


extension Foundation.Bundle {
    public func image(withName name: String, fileExtension: String) -> UIImage {
        guard let resourceURL = self.url(forResource: name, withExtension: fileExtension) else {
            fatalError("Could not find the file \"\(name).\(fileExtension)\" in the bundle.")
        }
        
        guard let resourceData = try? Data(contentsOf: resourceURL),
              let image = UIImage(data: resourceData) else {
            fatalError("Decode the image named \"\(name).\(fileExtension)\"")
        }
        
        return image
    }
}
