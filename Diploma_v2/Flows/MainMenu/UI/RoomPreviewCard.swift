//
//  RoomPreviewCard.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.02.2023.
//

import SwiftUI

struct RoomPreviewCard: View {
    let room: Room
    let isSelected: Bool
    
    var previewValue: [Value] {
        return room.previewValues
            .filter({ $0.name == "Temperature" || $0.name == "Humidity" })
            .sorted(by: { $0.name > $1.name })
    }
    
    init(
        room: Room,
        isSelected: Bool
    ) {
        self.room = room
        self.isSelected = isSelected
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(isSelected ? Color("Navy") : Color("BlueShark"))
                .opacity(0.6)
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
                .frame(height: 55)
            
            VStack(alignment: .leading) {
                Text(room.name)
                    .offset(y: previewValue.isEmpty ? 0 : 5)
                    .padding(.horizontal)
                
                if !previewValue.isEmpty && room.name != "Favorite" {
                    HStack {
                        Spacer()
                        ForEach(previewValue, id: \.self) { value in
                            Image(systemName: value.imageSystemName)
                                .resizable()
                                .frame(width: 10, height: 15)
                            Text(value.value)
                            Spacer()
                        }
                    }
                    .offset(y: -5)
                }
            }
            .foregroundColor(.white)
        }
    }
}
