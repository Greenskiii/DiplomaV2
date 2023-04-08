//
//  RealtimeDatabseManager.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 28.03.2023.
//

import Foundation
import FirebaseDatabase

final class RealtimeDatabseManager {
    private var firebaseDeviceObservers: [DatabaseReference] = []
    
    private lazy var databasePath: DatabaseReference? = {
        let ref = Database.database().reference().child("devices")
        return ref
    }()
    
    func getDevice(path: String,
                   completion:  @escaping (Device) -> Void) {
        guard let database = databasePath?.child(path) else {
            return
        }
        firebaseDeviceObservers.append(database)
        
        database
            .observe(.value) { snapshot, arg in
                if let device = Device(snapshot: snapshot) {
                    completion(device)
                }
            }
    }
    
    public func changeIsFavoriteValue(deviceId: String,
                                      isFavorite: Bool) {
        databasePath?.child(deviceId).updateChildValues(["isFavorite": isFavorite])
    }
    
    public func setRoomToDevice(roomName: String,
                                deviceId: String,
                                completion: @escaping () -> Void) {
        databasePath?.child(deviceId).updateChildValues(["room": roomName]) { error,_ in
            if error == nil {
                completion()
            }
        }
    }
    
    public func setDefaultValues(for device: String) {
        setRoomToDevice(roomName: "", deviceId: device) {
            self.changeIsFavoriteValue(deviceId: device, isFavorite: false)
        }
    }
    
    // MARK: - Realtime Databse Observers
    public func removeDeviceObservers() {
        self.firebaseDeviceObservers.forEach { databaseReference in
            databaseReference.removeAllObservers()
        }
        self.firebaseDeviceObservers = []
    }
    
    public func removeDeviceObserver(
        with id: String
    ) {
        let index = self.firebaseDeviceObservers.firstIndex { observer in
            if observer.url.contains(id) {
                observer.removeAllObservers()
            }
            return observer.url.contains(id)
        }
        if let index = index {
            self.firebaseDeviceObservers.remove(at: index)
        }
    }
}
