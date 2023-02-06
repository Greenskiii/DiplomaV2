//
//  DevicesGridView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 27.01.2023.
//

import SwiftUI

struct DevicesGridView: View {

    let devices: [House.Device]
    
    var body: some View {
            ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 10) {
                        ForEach(devices, id: \.self) { device in
                            DeviceCard(device: device, isFavorite: true)
                            DeviceCard(device: device, isFavorite: true)
                            DeviceCard(device: device, isFavorite: true)
                            DeviceCard(device: device, isFavorite: true)
                            DeviceCard(device: device, isFavorite: true)
                            DeviceCard(device: device, isFavorite: true)
                            DeviceCard(device: device, isFavorite: true)
                            DeviceCard(device: device, isFavorite: true)
                            DeviceCard(device: device, isFavorite: true)
                            DeviceCard(device: device, isFavorite: true)
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 70)
                }
            .padding(.horizontal)
            }
}


