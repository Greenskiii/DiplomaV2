//
//  SizeAwareViewModifier.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 17.01.2023.
//

import SwiftUI

struct SizeAwareViewModifier: ViewModifier {
    @Binding private var viewSize: CGSize
    
    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }
    
    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(
                SizePreferenceKey.self,
                perform: {
                    if self.viewSize != $0 {
                        self.viewSize = $0
                    }
                }
            )
    }
}
