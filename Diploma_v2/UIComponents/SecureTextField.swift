//
//  SecureTextField.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.01.2023.
//

import SwiftUI

struct SecureTextField: View {
    @Binding private var text: String
    @State private var isSecured: Bool = true

    private var title: String

    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text)
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                } else {
                    TextField(title, text: $text)
                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                }
            }

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
                    .padding(10)
            }
        }
    }
}
