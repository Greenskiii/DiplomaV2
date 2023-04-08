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

final class DataManager {
    private var subscriptions = Set<AnyCancellable>()
    private let firestoreManager = FirestoreManager()
    private let realtimeDatabseManager = RealtimeDatabseManager()
    private let authManager = AuthManager()
    
    @Published public var house: House? = nil
    @Published public var housePreview: [HousePreview] = []
    @Published public var newDeviceId: String = ""
    @Published var choosenRoomId = "Favorite"
    
    private(set) lazy var onChangeHouse = PassthroughSubject<String, Never>()
    private(set) lazy var onChangeNewDeviceId = PassthroughSubject<String, Never>()
    
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
                self.house?.rooms.append(Room(id: "Favorite", name: "Favorite"))
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
                if room.name == "Favorite" {
                    self.choosenRoomId = room.id
                    self.house?.rooms.insert(room, at: 0)
                } else {
                    self.house?.rooms.append(room)
                }
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
                if room.id != "Favorite" {
                    return room.id
                }
                return nil
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
    // MARK: - FCMToken
    //    public func removeFCMToken() {
    //        collection?.document("devicesId").getDocument { (document, error) in
    //            if var devicesId = document?.data()?["ids"] as? [String],
    //               let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"),
    //               let index = devicesId.firstIndex(where: { $0 == fcmToken }) {
    //
    //                devicesId.remove(at: index)
    //                self.collection?.document("devicesId").updateData(["ids": devicesId]) { error in
    //                    if let error = error {
    //                        print(error.localizedDescription)
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    //    public func checkFCMToken() {
    //        collection?.document("devicesId").getDocument { (document, error) in
    //            if var devicesId = document?.data()?["ids"] as? [String],
    //               let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"),
    //               !devicesId.contains(fcmToken) {
    //
    //                devicesId.append(fcmToken)
    //                self.collection?.document("devicesId").updateData(["ids": devicesId]) { error in
    //                    if let error = error {
    //                        print(error.localizedDescription)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
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
    
    public func addToFavorite(deviceId: String) {
        guard let house = self.house,
              let favoriteRoomIndex = house.rooms.firstIndex(where: { $0.id == "Favorite" }) else {
            return
        }
        
        if let roomIndex = house.rooms.firstIndex(where: { $0.devicesId.contains(deviceId) }),
           let deviceIndex = house.rooms[roomIndex].devices.firstIndex(where: { $0.id == deviceId }) {
            self.house?.rooms[roomIndex].devices[deviceIndex].isFavorite.toggle()
            
            if let device = self.house?.rooms[roomIndex].devices[deviceIndex] {
                if device.isFavorite {
                    self.house?.rooms[favoriteRoomIndex].devices.append(device)
                } else if let favoriteDeviceIndex = self.house?.rooms[favoriteRoomIndex].devices.firstIndex(where: { $0.id == deviceId }) {
                    self.house?.rooms[favoriteRoomIndex].devices.remove(at: favoriteDeviceIndex)
                }
            }
            self.realtimeDatabseManager.changeIsFavoriteValue(deviceId: deviceId,
                                                              isFavorite: self.house?.rooms[roomIndex].devices[deviceIndex].isFavorite ?? false)
        }
    }
    
    public func deleteDevice(with id: String,
                             houseId: String,
                             roomId: String,
                             completion: @escaping () -> Void) {
        guard let house = self.house else {
            return
        }
        
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
                        guard house.id == houseId,
                              let roomIndex = house.rooms.firstIndex(where: { $0.id == roomId }),
                              let deviceIndex = house.rooms[roomIndex].devices.firstIndex(where: { $0.id == id }),
                              let deviceIdIndex = house.rooms[roomIndex].devicesId.firstIndex(where: { $0 == id }) else {
                            return
                        }
                        if self.house?.rooms[roomIndex].previewDeviceId == id {
                            self.house?.rooms[roomIndex].previewDeviceId = nil
                            self.house?.rooms[roomIndex].previewValues = []
                        }
                        self.realtimeDatabseManager.setDefaultValues(for: id)
                        self.house?.rooms[roomIndex].devices.remove(at: deviceIndex)
                        self.house?.rooms[roomIndex].devicesId.remove(at: deviceIdIndex)
                        completion()
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
            if room.id != id && room.id != "Favorite" {
                return room.id
            }
            return nil
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
            return
        }
        
        self.realtimeDatabseManager.getDevice(path: deviceId) { [weak self] device in
            
            if self?.house?.rooms[roomIndex].devices.first(where: { $0.id == device.id }) == nil {
                self?.house?.rooms[roomIndex].devices.append(device)
            } else if let deviceIndex = self?.house?.rooms[roomIndex].devices.firstIndex(where: { $0.id == device.id }) {
                self?.house?.rooms[roomIndex].devices[deviceIndex].values = device.values
            }
            
            if house.rooms[roomIndex].previewValues.isEmpty {
                self?.house?.rooms[roomIndex].previewDeviceId = device.id
                self?.house?.rooms[roomIndex].previewValues = device.previewValues
            } else if house.rooms[roomIndex].previewDeviceId == device.id {
                self?.house?.rooms[roomIndex].previewValues = device.previewValues
            }
            
            if device.isFavorite,
               let favoriteRoomIndex = house.rooms.firstIndex(where: { $0.id == "Favorite" }) {
                if self?.house?.rooms[favoriteRoomIndex].devices.first(where: { $0.id == device.id }) == nil {
                    self?.house?.rooms[favoriteRoomIndex].devices.append(device)
                } else if let deviceIndex = self?.house?.rooms[favoriteRoomIndex].devices.firstIndex(where: { $0.id == device.id }) {
                    self?.house?.rooms[favoriteRoomIndex].devices[deviceIndex].values = device.values
                }
            }
            completion()
        }
    }
}

enum DataManagerResult {
    case notFoundId
    case error
    case success
}

extension String {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return  String((0..<length).map{ _ in letters.randomElement()! })
    }
}
