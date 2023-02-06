//
//  RoomPreviewCard.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.02.2023.
//

import SwiftUI

struct RoomPreviewCard: View {
    let room: House.Room
    let isSelected: Bool

    var previewValue: [House.Value] {
            return room.previewValues
                .filter({ $0.name == "Temperature" || $0.name == "Humidity" })
                .sorted(by: { $0.name > $1.name })
    }

    init(
        room: House.Room,
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
                .frame(height: 50)

            VStack(alignment: .leading) {
                
                Text(room.name)
                    .offset(y: room.name == "Favorite" ? 0 : 5)

                if !previewValue.isEmpty && room.name != "Favorite" {
                    HStack {
                        ForEach(previewValue, id: \.self) { value in
                            Image( value.name == "Temperature" ? "thermometer.low" : "drop.degreesign")
                                .resizable()
                                .frame(width: 10, height: 15)
                            Text(value.value)
                        }
                    }
                    .offset(y: -5)
                }
            }
            .foregroundColor(.white)
            .padding(.vertical)
        }
    }
    
}
