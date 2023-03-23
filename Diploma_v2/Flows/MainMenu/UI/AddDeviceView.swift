//
//  AddDeviceView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 23.02.2023.
//

import SwiftUI
import Combine

struct AddDeviceView: View {
    @Binding var deviceId: String
    var onGoToScannerScreen: PassthroughSubject<Void, Never>
    var onSaveNewDeviceId: PassthroughSubject<Void, Never>

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 16)
                .stroke()
                .foregroundColor(.gray)

            VStack {
                ZStack(alignment: .trailing) {
                    TextField(NSLocalizedString("DEVICE_ID", comment: "Device View"), text: $deviceId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        onGoToScannerScreen.send()
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                            .padding(.trailing, 8)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                Button {
                    onSaveNewDeviceId.send()
                } label: {
                    Text(NSLocalizedString("ADD_DEVICE", comment: "Action"))
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("BlueShark")))
                }
            }
        }
    }
}
