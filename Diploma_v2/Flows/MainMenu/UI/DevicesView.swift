//
//  DevicesView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 14.04.2023.
//

import SwiftUI
import Combine

struct DevicesView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let buttonsSpacer: CGFloat = 16
        static let imageFont: Font = .system(size: 20)
        static let buttonHeight: CGFloat = 50
        static let buttonPadding: CGFloat = 3
        static let buttonAspectRatio: CGFloat = 1
        static let scrollViewPadding: CGFloat = 6
    }
    
    let devices: [Device]
    var onPressAddDevice: PassthroughSubject<Void, Never>
    var onTapDevice: PassthroughSubject<Device?, Never>
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
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
                    HStack(spacing: Constants.buttonsSpacer) {
                        ForEach(devices, id: \.self) { device in
                            makeDeviceCard(device: device)
                                .onTapGesture {
                                    onTapDevice.send(device)
                                }
                        }
                        
                        Button {
                            onPressAddDevice.send()
                        } label: {
                            Image(systemName: "plus")
                                .font(Constants.imageFont)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                        .foregroundColor(.white)
                                        .shadow(color: .gray, radius: 3, x: 2, y: 2)
                                )
                                .aspectRatio(Constants.buttonAspectRatio, contentMode: .fit)
                                .frame(height: Constants.buttonHeight)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, Constants.buttonPadding)
                }
            }
            .padding(.vertical, Constants.scrollViewPadding)
        }
    }
    
    func makeDeviceCard(device: Device) -> some View {
        UrlImageView(urlString: device.image)
            .padding(Constants.buttonPadding)
            .background(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 3, x: 2, y: 2)
            )
            .aspectRatio(Constants.buttonAspectRatio, contentMode: .fit)
            .frame(height: Constants.buttonHeight)
    }
}
