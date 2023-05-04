//
//  RoomPreviewCard.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.02.2023.
//

import SwiftUI

struct RoomPreviewCard: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let height: CGFloat = 55
        static let imageHeight: CGFloat = 20
        static let imageWidth: CGFloat = 20
        static let previewValueOffset: CGFloat = -5
        static let textOffset: CGFloat = 5
    }
    
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
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .foregroundColor(isSelected ? Color("LightBlueShark") : Color("TropicalBlue"))
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
                .frame(height: Constants.height)
            
            VStack(alignment: .leading) {
                Text(room.name)
                    .offset(y: previewValue.isEmpty ? 0 : Constants.textOffset)
                    .padding(.horizontal)
                
                if !previewValue.isEmpty {
                    HStack {
                        Spacer()
                        ForEach(previewValue, id: \.self) { value in
                            Image(value.imageSystemName)
                                .resizable()
                                .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                            Text(value.value)
                            Spacer()
                        }
                    }
                    .offset(y: Constants.previewValueOffset)
                }
            }
            .foregroundColor(.white)
        }
    }
}
