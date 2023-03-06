//
//  BackgroundGeometryReader.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 17.01.2023.
//

import SwiftUI

struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                .clear
                .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

