//
//  AddDeviceView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 23.02.2023.
//

import SwiftUI
import Combine

struct AddDeviceView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let qrCodeButtonPadding: CGFloat = 8
    }
    
    @Binding var deviceId: String
    var onGoToScannerScreen: PassthroughSubject<Void, Never>
    var onSaveNewDeviceId: PassthroughSubject<String, Never>
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke()
                .foregroundColor(Color("LightGray 1"))
            
            VStack {
                ZStack(alignment: .trailing) {
                    TextField(NSLocalizedString("DEVICE_ID", comment: "Device View"), text: $deviceId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        onGoToScannerScreen.send()
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                            .padding(.trailing, Constants.qrCodeButtonPadding)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                Button {
                    onSaveNewDeviceId.send(deviceId)
                } label: {
                    Text(NSLocalizedString("ADD_DEVICE", comment: "Action"))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                .fill(Color("BlueShark"))
                        )
                        .padding(.top)
                }
            }
        }
    }
}
