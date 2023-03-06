//
//  ScannerViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 24.02.2023.
//

import Foundation
import Combine

class ScannerViewModel: ObservableObject {
    @Published var torchIsOn: Bool = false
    @Published var lastQrCode: String = "Qr-code goes here"

    let scanInterval: Double = 1.0
    var onGoBack: PassthroughSubject<Void, Never>
    var onChangeNewDeviceId: PassthroughSubject<String, Never>

    init(
        onGoBack: PassthroughSubject<Void, Never>,
        onChangeNewDeviceId: PassthroughSubject<String, Never>
    ) {
        self.onGoBack = onGoBack
        self.onChangeNewDeviceId = onChangeNewDeviceId
    }

    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
        self.onChangeNewDeviceId.send(code)
        self.onGoBack.send()
    }
}
