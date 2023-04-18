//
//  TabButton.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.04.2023.
//

import SwiftUI

struct TabButton: View {
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
                        .shadow(radius: 1)
                        .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                        .animation(.spring(), value: selectedTab)
                }
                
                Image(systemName: tab.icon)
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? .init(white: 0.9) : .gray)
                    .scaleEffect(isSelected ? 1 : 0.8)
                    .animation(isSelected ? .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1) : .spring(), value: selectedTab)
            }
        }
    }
    private var isSelected: Bool {
        selectedTab == tab
    }
}
