//
//  FCMTokenManager.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 02.05.2023.
//

import Foundation

final class FCMTokenManager {
    private let firestoreManager = FirestoreManager()
    
    public func checkFCMToken(userUid: String) {
        firestoreManager.get(docId: userUid, collection: .user) { (result: Result<Devices, FirestoreManagerError>) in
            switch result {
            case .success(let devices):
                guard let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") else { return }
                if !devices.ids.contains(fcmToken) {
                    var ids = devices.ids
                    ids.append(fcmToken)
                    self.firestoreManager.update(data: ["ids": ids], documentId: userUid, collection: .user) { result in
                        switch result {
                        case .success(let success):
                            print(success)
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    public func removeFCMToken(userUid: String) {
        firestoreManager.get(docId: userUid, collection: .user) { (result: Result<Devices, FirestoreManagerError>) in
            switch result {
            case .success(let devices):
                guard let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"),
                      let idIndex = devices.ids.firstIndex(where: { $0 == fcmToken }) else { return }
                    var ids = devices.ids
                    ids.remove(at: idIndex)
                self.firestoreManager.update(data: ["ids": ids], documentId: userUid, collection: .user) { _ in }
            case .failure(let error):
                print(error)
            }
        }
    }
}
