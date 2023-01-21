//
//  BottomSheetView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 19.01.2023.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool
    let maxHeight: CGFloat
    let minHeight: CGFloat = 0
    var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    let content: Content

    @GestureState private var translation: CGFloat = 0

    init(
        maxHeight: CGFloat,
        isOpen: Binding<Bool>,
         @ViewBuilder content: () -> Content
    ) {
        self.maxHeight = maxHeight
        self._isOpen = isOpen
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.content
            }
            .frame(width: geometry.size.width, alignment: .top)
            .background(
                VisualEffectView(effect: UIBlurEffect(style: .dark))
            )
            .cornerRadius(16)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance: CGFloat = 100
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}
