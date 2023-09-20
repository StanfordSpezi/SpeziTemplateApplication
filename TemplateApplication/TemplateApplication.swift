//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Spezi
import SwiftUI


@main
struct TemplateApplication: App {
    @UIApplicationDelegateAdaptor(TemplateAppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .testingSetup()
                .spezi(appDelegate)
        }
    }
}
