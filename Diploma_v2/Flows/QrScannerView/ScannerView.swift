//
//  ScannerView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 24.02.2023.
//

import SwiftUI

struct ScannerView: View {
    @ObservedObject var viewModel: ScannerViewModel

    var body: some View {
        ZStack {
            QrCodeScannerView()
                .found(r: self.viewModel.onFoundQrCode)
                .torchLight(isOn: self.viewModel.torchIsOn)
                .interval(delay: self.viewModel.scanInterval)

            VStack {
                HStack {
                    Button {
                        viewModel.onGoBack.send()
                    } label: {
                        Text("Back")
                            .padding()
                    }
                    Spacer()
                }

                Spacer()

                Button {
                    viewModel.torchIsOn.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.gray)
                        Image(systemName: viewModel.torchIsOn ? "flashlight.on.fill" :"flashlight.off.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 28))
                    }
                    .frame(width: 50, height: 50)
                    .padding()
                }
            }
        }
    }
}
