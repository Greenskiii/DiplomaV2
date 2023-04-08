//
//  UITextField + extension.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 07.04.2023.
//

import SwiftUI
import Combine

public extension View {
    func textFieldAlert(
        title: String?,
        message: String? = nil,
        textFields: [TextFieldAlert.TextField],
        actions: [TextFieldAlert.Action],
        isPresented: Binding<Bool>
    ) -> some View {
        TextFieldWrapper(
            isPresented: isPresented,
            presentingView: self,
            content: {
                TextFieldAlert(
                    title: title,
                    message: message,
                    textFields: textFields,
                    actions: actions
                )
            }
        )
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
