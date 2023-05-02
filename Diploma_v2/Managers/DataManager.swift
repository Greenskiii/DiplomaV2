//
//  DataManager.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 24.01.2023.
//

import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import Combine

enum DataManagerResult {
    case notFoundId
    case error
    case success
}

final class DataManager {
    private var subscriptions = Set<AnyCancellable>()
    private let firestoreManager = FirestoreManager()
    private let realtimeDatabseManager = RealtimeDatabseManager()
    private let authManager = AuthManager()
    
    @Published public var house: House? = nil
    @Published public var housePreview: [HousePreview] = []
    @Published public var newDeviceId: String = ""
    @Published var choosenRoomId = ""
    
    var onChangeHouse = PassthroughSubject<String, Never>()
    var onChangeNewDeviceId = PassthroughSubject<String, Never>()
    
    init() {
        if let user = authManager.getUserInfo() {
            getHousesPaths(for: user.uid)
        }
        
        onChangeHouse
            .sink { [weak self] id in
                if self?.house?.id != id {
                    self?.setHouse(with: id){}
                    self?.realtimeDatabseManager.removeDeviceObservers()
                }
            }
            .store(in: &self.subscriptions)
        
        onChangeNewDeviceId
            .sink { [weak self] deviceId in
                self?.newDeviceId = deviceId
            }
            .store(in: &self.subscriptions)
    }
}

// MARK: - Database
extension DataManager {
    public func getHousesPaths(for userId: String) {
        firestoreManager.get(docId: userId, collection: .user) { (completion: Result<UserHouses, FirestoreManagerError>) in
            switch completion {
            case .success(let data):
                self.setHousePreviewValue(ids: data.housesLinkPath)
                if let id = data.housesLinkPath.first {
                    self.setHouse(with: id){}
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setHousePreviewValue(ids: [String]) {
        ids.forEach { id in
            firestoreManager.get(docId: id, collection: .house) { (completion: Result<House, FirestoreManagerError>) in
                switch completion {
                case .success(let house):
                    if !self.housePreview.contains(where: { $0.id == house.id }) {
                        self.housePreview.append(HousePreview(id: house.id, name: house.name))
                        house.roomsLinkPath.forEach { id in
                            self.setRoomPreviewValue(to: house.id, roomId: id)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setRoomPreviewValue(to houseId: String,
                                     roomId: String) {
        firestoreManager.get(docId: roomId, collection: .room) { (completion: Result<Room, FirestoreManagerError>) in
            switch completion {
            case .success(let room):
                if let houseIndex = self.housePreview.firstIndex(where: { $0.id == houseId }) {
                    self.housePreview[houseIndex].rooms.append(RoomPreview(id: room.id, name: room.name))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func setHouse(with id: String,
                         completion: @escaping () -> Void) {
        firestoreManager.get(docId: id, collection: .house) { (result: Result<House, FirestoreManagerError>) in
            switch result {
            case .success(let house):
                self.house = house
                if house.roomsLinkPath.isEmpty {
                    completion()
                }
                house.roomsLinkPath.forEach { id in
                    self.setRoom(to: house.id, roomId: id) {
                        if house.roomsLinkPath.last == id {
                            completion()
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setRoom(to houseId: String,
                         roomId: String,
                         completion: @escaping () -> Void) {
        firestoreManager.get(docId: roomId, collection: .room) { (result: Result<Room, FirestoreManagerError>) in
            switch result {
            case .success(let room):
                if self.choosenRoomId.isEmpty {
                    self.choosenRoomId = room.id
                }
                
                self.house?.rooms.append(room)
                self.setDevices(for: room.id) {
                    completion()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func addRoom(name: String) {
        
        guard let house = self.house else {
            return
        }
        if house.rooms.contains(where: { $0.name == name }) {
            print("room с таким названием уже сществует")
        } else {
            let roomId = String.randomString(length: 20)
            
            var roomsId = house.rooms.compactMap { room in
                return room.id
            }
            roomsId.append(roomId)
            
            firestoreManager.add(data: ["rooms": roomsId, "name": house.name], documentId: house.id, collection: .house) { completion in
                switch completion {
                case .success(_):
                    print("success")
                    //                    self.housePreview.append(HousePreview(id: houseId, name: name))
                case .failure(let error):
                    print(error)
                }
            }
            
            firestoreManager.add(data: ["name": name, "devices": []],documentId: roomId, collection: .room) { completion in
                switch completion {
                case .success(_):
                    self.house?.rooms.append(Room(id: roomId, name: name))
                    if let housePreviewIndex = self.housePreview.firstIndex(where: { $0.id == house.id }) {
                        self.housePreview[housePreviewIndex].rooms.append(RoomPreview(id: roomId, name: name))
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    public func addHouse(_ name: String) {
        if housePreview.contains(where: { $0.name == name }) {
            print("дом с таким названием уже сществует")
        } else if let user = authManager.getUserInfo() {
            let houseId = String.randomString(length: 20)
            
            var housesId = self.housePreview.map { house in
                return house.id
            }
            housesId.append(houseId)
            // add to user
            firestoreManager.add(data: ["houses": housesId], documentId: user.uid, collection: .user) { completion in
                switch completion {
                case .success(_):
                    print("success")
                    //                    self.housePreview.append(HousePreview(id: houseId, name: name))
                case .failure(let error):
                    print(error)
                }
            }
            
            firestoreManager.add(data: ["name": name, "rooms": []], documentId: houseId, collection: .house) { completion in
                switch completion {
                case .success(_):
                    self.housePreview.append(HousePreview(id: houseId, name: name))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Post Request
    public func addDevice(roomId: String,
                          deviceId: String,
                          completion: @escaping (_ success: DataManagerResult) -> Void) {
        guard !deviceId.isEmpty,
              let house = self.house else {
            completion(.error)
            return
        }
        
        firestoreManager.get(docId: roomId, collection: .room) { (result: Result<Room, FirestoreManagerError>) in
            switch result {
            case .success(let room):
                var devices = room.devicesId
                if let index = devices.firstIndex(where: { $0 == deviceId }) {
                    devices.remove(at: index)
                } else {
                    devices.append(deviceId)
                }
                self.firestoreManager.update(data: ["devices": devices], documentId: roomId, collection: .room) { result in
                    switch result {
                    case .success(_):
                        if let roomIndex = self.house?.rooms.firstIndex(where: { $0.id == roomId }) {
                            self.house?.rooms[roomIndex].devicesId = devices
                            if !house.rooms[roomIndex].devices.contains(where: { $0.id == deviceId }) {
                                
                                self.setDevice(deviceId: deviceId, roomId: roomId) {
                                    completion(DataManagerResult.success)
                                }
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func deleteDevice(with id: String,
                             houseId: String,
                             roomId: String,
                             completion: @escaping () -> Void) {
        self.firestoreManager.get(docId: roomId, collection: .room) { (result: Result<Room, FirestoreManagerError>) in
            switch result {
            case .success(let room):
                var devicesId = room.devicesId
                
                if let deviceIdIndex = devicesId.firstIndex(where: { $0 == id }) {
                    devicesId.remove(at: deviceIdIndex)
                }
                self.firestoreManager.update(data: ["devices": devicesId], documentId: roomId, collection: .room) { result in
                    switch result {
                    case .success:
                        if let id = self.house?.id {
                            self.setHouse(with: id) {
                                completion()
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func deleteRoom(id: String) {
        guard let house = self.house,
              let roomIndex = self.house?.rooms.firstIndex(where: { $0.id == id }),
              let housePreviewIndex = self.housePreview.firstIndex(where: { $0.id == house.id }),
              let roomPreviewIndex = self.housePreview[housePreviewIndex].rooms.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        let roomsId = house.rooms.compactMap { room in
            return room.id
        }
        
        self.firestoreManager.add(data: ["name": house.name,"rooms": roomsId], documentId: house.id, collection: .house) { _ in
        }
        
        self.firestoreManager.delete(documentId: id, collection: .room) { result in
            self.house?.rooms.remove(at: roomIndex)
            self.housePreview[housePreviewIndex].rooms.remove(at: roomPreviewIndex)
        }
    }
    
    public func deleteHouse(id: String) {
        guard let houseIndex = housePreview.firstIndex(where: { $0.id == id }),
              let user = authManager.getUserInfo() else {
            return
        }
        
        let housesId = housePreview.compactMap { house in
            if house.id != id {
                return house.id
            }
            return nil
        }
        
        self.firestoreManager.add(data: ["houses": housesId], documentId: user.uid, collection: .user) { _ in
        }
        
        if self.housePreview[houseIndex].rooms.isEmpty {
            self.firestoreManager.delete(documentId: self.housePreview[houseIndex].id, collection: .house) { result in
                self.housePreview.remove(at: houseIndex)
            }
        } else {
            self.housePreview[houseIndex].rooms.forEach { room in
                self.firestoreManager.delete(documentId: room.id, collection: .room) { result in
                    if room == self.housePreview[houseIndex].rooms.last {
                        self.firestoreManager.delete(documentId: self.housePreview[houseIndex].id, collection: .house) { result in
                            self.housePreview.remove(at: houseIndex)
                            if self.house?.id == id,
                               let houseId = self.housePreview.first?.id {
                                self.setHouse(with: houseId) {}
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Realtime Database
extension DataManager {
    private func setDevices(for roomId: String,
                            completion: @escaping () -> Void) {
        guard let roomIndex = self.house?.rooms.firstIndex(where: { $0.id == roomId }),
              let room = self.house?.rooms[roomIndex] else {
            return
        }
        self.house?.rooms[roomIndex].devices = []
        
        if room.devicesId.isEmpty {
            completion()
        }
        
        room.devicesId.forEach { id in
            self.setDevice(deviceId: id, roomId: roomId) {
                completion()
            }
        }
    }
    
    func setDevice(deviceId: String,
                   roomId: String,
                   completion: @escaping () -> Void) {
        guard let house = self.house,
              let roomIndex = self.house?.rooms.firstIndex(where: { $0.id == roomId }) else {
            completion()
            return
        }
        
        self.realtimeDatabseManager.observeDevice(path: deviceId) { [weak self] device in
            
            if self?.house?.rooms[roomIndex].devices.first(where: { $0.id == device.id }) == nil {
                self?.house?.rooms[roomIndex].devices.append(device)
            }
            
            if house.rooms[roomIndex].previewValues.isEmpty {
                self?.house?.rooms[roomIndex].previewDeviceId = device.id
                self?.house?.rooms[roomIndex].previewValues = device.previewValues
            } else if house.rooms[roomIndex].previewDeviceId == device.id {
                self?.house?.rooms[roomIndex].previewValues = device.previewValues
            }
            
            device.values.forEach { value in
                if self?.house?.rooms[roomIndex].values.first(where: { $0.name == value.name }) == nil {
                    self?.house?.rooms[roomIndex].values.append(value)
                } else if let valueIndex = self?.house?.rooms[roomIndex].values.firstIndex(where: { $0.deviceId == value.deviceId && $0.name == value.name }) {
                    self?.house?.rooms[roomIndex].values[valueIndex] = value
                }
            }
            completion()
        }
    }
}

extension String {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return  String((0..<length).map{ _ in letters.randomElement()! })
    }
}
