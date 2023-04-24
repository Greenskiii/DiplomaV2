//
//  TabButton.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.04.2023.
//

import SwiftUI

struct TabButton: View {
    private enum Constants {
        static let imageFont: Font = .system(size: 25, weight: .semibold, design: .rounded)
        static let imageScale: CGFloat = 0.8
        static let shadowRadius: CGFloat = 1
    }
    
    let tab: TabType
    @Binding var selectedTab: TabType
    var namespace: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation {
                selectedTab = tab
            }
        } label: {
            ZStack {
                if isSelected {
                    Circle()
                        .shadow(radius: Constants.shadowRadius)
                        .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                        .animation(.spring(), value: selectedTab)
                        .foregroundColor(Color("Royalblue"))
                }
                
                Image(systemName: tab.icon)
                    .font(Constants.imageFont)
                    .foregroundColor(isSelected ? .init(white: 0.9) : .gray)
                    .scaleEffect(isSelected ? 1 : Constants.imageScale)
                    .animation(
                        isSelected ? .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1)
                                   : .spring(),
                        value: selectedTab
                    )
            }
        }
    }
    private var isSelected: Bool {
        selectedTab == tab
    }
}
