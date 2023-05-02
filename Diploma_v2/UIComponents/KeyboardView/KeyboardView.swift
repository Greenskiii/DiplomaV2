//
//  KeyboardView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 12.04.2023.
//

import SwiftUI

struct KeyboardView<Content, ToolBar> : View where Content : View, ToolBar: View {
    @StateObject private var keyboard: KeyboardResponder = KeyboardResponder()
    let toolbarFrame: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 40.0)
    var content: () -> Content
    var toolBar: () -> ToolBar
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("TropicalBlue")
                    .ignoresSafeArea()
                content()
                    .padding(
                        .bottom,
                        keyboard.currentHeight == 0 ? geometry.size.height * 0.12
                                                    : toolbarFrame.height
                    )
                VStack {
                    Spacer()
                    toolBar()
                        .frame(width: toolbarFrame.width, height: toolbarFrame.height)
                        .background(Color("LightGray"))
                }
                .opacity((keyboard.currentHeight == 0) ? 0 : 1)
                .animation(.easeOut)
            }
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut)
        }
    }
}
