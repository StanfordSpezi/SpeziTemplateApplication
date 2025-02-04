//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct AccountButton: View {
    @Binding private var isPresented: Bool


    var body: some View {
        Button("Your Account", systemImage: "person.crop.circle") {
            isPresented = true
        }
    }


    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
}


#if DEBUG
#Preview(traits: .sizeThatFitsLayout) {
    AccountButton(isPresented: .constant(false))
}
#endif
