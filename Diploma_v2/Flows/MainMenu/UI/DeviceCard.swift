//
//  DeviceCard.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.02.2023.
//

import SwiftUI

struct DeviceCard: View {
    
    let device: House.Device
    let isFavorite: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("BlueShark"))
                .opacity(0.5)
                .shadow(color: .gray, radius: 3, x: 2, y: 2)

            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    ImageView(withURL: device.image)
                        .frame(width: 50, height: 50)
                        
                    if isFavorite {
                        Text(device.room)
                            .font(.system(size: 12))
                    }
                    Text(device.name)
                        .font(.system(size: 16))
                    HStack {
                        ForEach(device.values, id: \.self) { value in
                            Text(value.value)
                        }
                    }
                }
                Spacer()
                
                Image(systemName: "star")
                    .font(.system(size: 16))
                    .foregroundColor(Color("Navy"))
            }

            .padding()

        }
    }
}


struct DeviceCard_Previews: PreviewProvider {
    static var previews: some View {
        DeviceCard(device: House.Device(name: "", image: "", room: "", values: []), isFavorite: true)
    }
}
