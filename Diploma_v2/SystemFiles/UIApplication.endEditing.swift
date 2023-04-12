//
//  UIApplication.endEditing.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 12.04.2023.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
