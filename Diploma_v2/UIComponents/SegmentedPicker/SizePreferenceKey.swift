//
//  SizePreferenceKey.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 17.01.2023.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
