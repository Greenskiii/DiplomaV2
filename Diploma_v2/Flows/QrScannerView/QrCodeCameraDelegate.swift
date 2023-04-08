//
//  QrCodeCameraDelegate.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 24.02.2023.
//

import Foundation
import AVFoundation


class QrCodeCameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var scanInterval: Double = 1.0
    var lastTime = Date(timeIntervalSince1970: 0)
    
    var onResult: (String) -> Void = { _  in }
    var mockData: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue
        else {
            return
        }
        foundBarcode(stringValue)
    }
    
    @objc func onSimulateScanning(){
        foundBarcode(mockData ?? "rAXm4M5Xs7mF7d8znA75atmospheric")
    }
    
    func foundBarcode(_ stringValue: String) {
        let now = Date()
        if now.timeIntervalSince(lastTime) >= scanInterval {
            lastTime = now
            self.onResult(stringValue)
        }
    }
}
