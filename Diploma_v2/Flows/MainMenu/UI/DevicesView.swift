//
//  DevicesView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 14.04.2023.
//

import SwiftUI
import Combine

struct DevicesView: View {
    let devices: [Device]
    var onPressAddDevice: PassthroughSubject<Void, Never>
    var onTapDevice: PassthroughSubject<Device?, Never>
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color("LightBlueShark"))
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Connect device")
                        .font(.title2)
                    Text("Connect new device with this app")
                }
                .foregroundColor(.white)
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(devices, id: \.self) { device in
                            makeDeviceCard(device: device)
                                .onTapGesture {
                                    onTapDevice.send(device)
                                }
                        }
                        
                        Button {
                            onPressAddDevice.send()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundColor(.white)
                                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
                                
                                Image(systemName: "plus")
                            }
                            .aspectRatio(1, contentMode: .fit)
                            .frame(height: 50)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 3)
                }
            }
            .padding(.vertical, 6)
        }
    }
    
    func makeDeviceCard(device: Device) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color("TropicalBlue"))
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
            
            UrlImageView(urlString: device.image)
                .padding(3)
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(height: 50)
    }
}
