//
//  ScannerView.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 24.02.2023.
//

import SwiftUI

struct ScannerView: View {
    private enum Constants {
        enum TorchButton {
            static let font: Font = .system(size: 28)
            static let cornerRadius: CGFloat = 16
            static let width: CGFloat = 50
            static let height: CGFloat = 50
        }
    }
    
    @ObservedObject var viewModel: ScannerViewModel
    
    var body: some View {
        ZStack {
            QrCodeScannerView()
                .found(r: self.viewModel.onFoundQrCode)
                .torchLight(isOn: self.viewModel.torchIsOn)
                .interval(delay: self.viewModel.scanInterval)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        viewModel.onGoBack.send()
                    } label: {
                        Image(systemName: "chevron.backward.circle")
                            .foregroundColor(Color("Navy"))
                            .font(.title2)
                    }
                    Spacer()
                }
                
                Spacer()
                
                Button {
                    viewModel.torchIsOn.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: Constants.TorchButton.cornerRadius)
                            .foregroundColor(.gray)
                        Image(systemName: viewModel.torchIsOn ? "flashlight.on.fill" :"flashlight.off.fill")
                            .foregroundColor(.white)
                            .font(Constants.TorchButton.font)
                    }
                    .frame(width: Constants.TorchButton.width,
                           height: Constants.TorchButton.height)
                    .padding()
                }
            }
        }
    }
}
