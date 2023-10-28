//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziViews
import SwiftUI


struct ModalView: View {
    @Environment(\.dismiss) private var dismiss

    let text: String
    let buttonText: String
    let onClose: () async -> Void
    
    
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .padding()
            Spacer()
            AsyncButton {
                self.dismiss()
                await self.onClose()
            } label: {
                Text(buttonText)
                    .frame(maxWidth: .infinity, minHeight: 38)
            }
                .padding()
                .buttonStyle(.borderedProminent)
        }
    }
}


struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(text: "Preview Modal", buttonText: "Close") {
            print("Preview Modal closed.")
        }
    }
}
