//
//  DevicesGridView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 27.01.2023.
//

import SwiftUI
import Combine

struct DevicesGridView: View {
    let devices: [Device]
    let onTapDevice: PassthroughSubject<Device?, Never>
    let onTapFavorite: PassthroughSubject<Device, Never>
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 10) {
                ForEach(devices, id: \.self) { device in
                    ZStack(alignment: .topTrailing) {
                        DeviceCard(device: device, isFavorite: true)
                            .onTapGesture {
                                withAnimation {
                                    onTapDevice.send(device)
                                }
                            }
                        Button {
                            onTapFavorite.send(device)
                        } label: {
                            Image(systemName: device.isFavorite ? "star.fill" : "star")
                                .font(.system(size: 16))
                                .foregroundColor(Color("Navy"))
                                .padding()
                        }
                    }
                }
            }
            .padding(.top)
            .padding(.bottom, 70)
        }
        .padding(.horizontal)
    }
}
