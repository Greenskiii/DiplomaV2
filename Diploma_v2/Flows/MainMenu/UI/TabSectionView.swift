//
//  RoomView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 23.01.2023.
//

import SwiftUI

struct TabSectionView<Content: View>: View {
    let isAllRoomsView: Bool
    let room: String
    let house: String
    
    let content: Content

    init(
        isAllRoomsView: Bool = true,
        room: String = "",
        house: String,
         @ViewBuilder content: () -> Content
    ) {
        self.isAllRoomsView = isAllRoomsView
        self.room = room
        self.house = house
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
                VStack {
                    Spacer()
                    ZStack{
                        VStack {
                            if !isAllRoomsView,
                               let room = room {
                                Text(room)
                                    .font(.title2)
                            }
                            Text(house)
                                .font(isAllRoomsView ? .title2 : .caption2)
                        }
                        Circle()
                            .stroke(lineWidth: 3)
                            .foregroundColor(.white)
                            .frame(height: 120)

                    }
                    .offset(y: 15)

                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.white)

                        
                        ScrollView {
                            content
                        }
                    }
                    .frame(height: geometry.size.height * 0.7)
                    .padding()
                    .padding(.bottom, 10)
                }
            }
    }
}

//struct RoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoomView(isAllRoomsView: true, room: "Firs Room", house: "First House")
//    }
//}
