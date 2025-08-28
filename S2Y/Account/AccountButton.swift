//
// This source file is part of the S2Y application project
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
