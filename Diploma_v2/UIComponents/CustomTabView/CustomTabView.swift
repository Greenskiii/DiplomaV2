//
//  CustomTabView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.04.2023.
//

import SwiftUI

struct CustomTabView: View {
    private enum Constants {
        static let spacerLength: CGFloat = 0
        
        enum TabButton {
            static let width: CGFloat = 45
            static let height: CGFloat = 45
        }
    }
    
    @Binding var selectedTab: TabType
    @Namespace var namespace
    
    var body: some View {
        HStack {
            Spacer(minLength: Constants.spacerLength)
            
            ForEach(TabType.allCases, id: \.self) { tab in
                TabButton(
                    tab: tab,
                    selectedTab: $selectedTab,
                    namespace: namespace
                )
                .frame(width: Constants.TabButton.width,
                       height: Constants.TabButton.height,
                       alignment: .center)
                
                Spacer(minLength: Constants.spacerLength)
            }
        }
    }
}
