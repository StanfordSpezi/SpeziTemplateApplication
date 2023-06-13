//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct ModalView: View {
    @Environment(\.dismiss) private var dismiss

    let text: String
    let buttonText: String
    let onClose: () -> Void

    var body: some View {
        VStack {
            Text(text)
                .font(.largeTitle)
                .padding()

            Button(action: {
                self.dismiss()
                self.onClose()
            }) {
                Text(buttonText)
                    .font(.title)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
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
