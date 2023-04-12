//
//  DeviceCard.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.02.2023.
//

import SwiftUI

struct DeviceCard: View {
    let device: Device
    let isFavoriteRoom: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color("BlueShark"))
                .opacity(0.5)
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
            
            HStack(alignment: .top) {
                VStack {
                    HStack(alignment: .bottom) {
                        UrlImageView(urlString: device.image)
                            .frame(width: 50, height: 50)
                        
                        VStack {
                            Text(device.name)
                                .font(.system(size: 16))
                            if isFavoriteRoom {
                                Text(device.room)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                    
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
