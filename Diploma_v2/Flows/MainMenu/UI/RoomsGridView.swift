//
//  MainMenuGridView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 23.01.2023.
//

import SwiftUI

struct RoomsGridView: View {
    let items: [House.Room]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(items, id: \.self) { item in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray)
                            .opacity(0.5)
                        
                        VStack {
                            Image(item.type.image)
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text(item.name)
                        }
                        .padding()
                    }
                }
                
            }
            .padding()
        }
    }
}

//struct MainMenuGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainMenuGridView(items: Room()
//    }
//}
