//
//  CustomTabView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.04.2023.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var selectedTab: TabType
    @Namespace var namespace
    
    var body: some View {
        HStack {
            Spacer(minLength: 0)
            
            ForEach(TabType.allCases, id: \.self) { tab in
                TabButton(tab: tab, selectedTab: $selectedTab, namespace: namespace)
                    .frame(width: 45, height: 45, alignment: .center)
                
                Spacer(minLength: 0)
            }
        }
    }
}
