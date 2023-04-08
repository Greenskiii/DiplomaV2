//
//  DeviceCard.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.02.2023.
//

import SwiftUI

struct DeviceCard: View {
    let device: Device
    let isFavorite: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("BlueShark"))
                .opacity(0.5)
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    UrlImageView(urlString: device.image)
                        .frame(width: 50, height: 50)
                    
                    if isFavorite {
                        Text(device.room)
                            .font(.system(size: 12))
                    }
                    Text(device.name)
                        .font(.system(size: 16))
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(device.values, id: \.self) { value in
                            VStack {
                                Image(systemName: value.imageSystemName)
                                Text(value.value)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
        .animation(.easeInOut(duration: 2))
    }
}
