//
//  MainMenuCatView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 20.01.2023.
//

import SwiftUI

struct MainMenuCatView: View {
    var body: some View {
        ZStack {
            Image("MainMenuCat")
                .resizable()
                .frame(width: 100, height: 100)
            
//            Image("ThinkingCloud")
//                .resizable()
//                .frame(width: 100, height: 100)
        }
    }
}

struct MainMenuCatView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuCatView()
    }
}
