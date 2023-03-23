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

class DataManager {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private var firebaseDeviceObservers: [DatabaseReference] = []
    private var previewValuesObservers: [DatabaseReference] = []
    private var subscriptions = Set<AnyCancellable>()

    @Published public var house: House? = nil
    @Published public var housePreview: [HousePreview] = []
    @Published public var newDeviceId: String = ""
    @Published var choosenRoomId = "Favorite"

    private(set) lazy var onChangeHouse = PassthroughSubject<String, Never>()
    private(set) lazy var onChangeNewDeviceId = PassthroughSubject<String, Never>()

    private var collection: CollectionReference? {
        guard let id = auth.currentUser?.uid else { return nil }
        return db.collection(id)
    }

    private lazy var databasePath: DatabaseReference? = {
        let ref = Database.database().reference().child("devices")
        return ref
    }()

    init() {
        getHousesId()

        onChangeHouse
            .sink { [weak self] id in
                self?.getHouse(with: id)
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
    // MARK: - FCMToken
    public func removeFCMToken() {
        collection?.document("devicesId").getDocument { (document, error) in
            if var devicesId = document?.data()?["ids"] as? [String],
               let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"),
               let index = devicesId.firstIndex(where: { $0 == fcmToken }) {

                devicesId.remove(at: index)
                self.collection?.document("devicesId").updateData(["ids": devicesId]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    public func checkFCMToken() {
        collection?.document("devicesId").getDocument { (document, error) in
            if var devicesId = document?.data()?["ids"] as? [String],
               let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"),
               !devicesId.contains(fcmToken) {

                devicesId.append(fcmToken)
                self.collection?.document("devicesId").updateData(["ids": devicesId]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    // MARK: - Get Request
    public func getHousesId() {
        self.housePreview = []
        collection?.getDocuments { (querySnapshot, err) in
            querySnapshot?.documents.forEach { document in
                guard let name = document.data()["name"] as? String else { return }
                self.housePreview.append(HousePreview(id: document.documentID, name: name))

                if self.housePreview.count == 1,
                   self.house == nil {
                    self.getHouseFromDocument(document)
                }
            }
        }
    }

    public func getHouseFromDocument(
        _ houseDocument: QueryDocumentSnapshot
    ) {
        houseDocument.reference.collection("rooms").getDocuments { (querySnapshot, err) in
            guard let roomDocuments = querySnapshot?.documents,
                  let houseName = houseDocument.data()["name"] as? String else {
                return
            }
            var newHouse = House(id: houseDocument.documentID, name: houseName, rooms: [])

            roomDocuments.forEach { roomDocument in
                roomDocument.reference.getDocument { (querySnapshot, err) in
                    guard let data = querySnapshot?.data(),
                    let room = Room(id: roomDocument.documentID, from: data) else {
                        return
                    }
                    
                    if room.name == "Favorite" {
                        newHouse.rooms.insert(room, at: 0)
                    } else {
                        newHouse.rooms.append(room)
                    }
                    
                    if newHouse.rooms.count == roomDocuments.count {
                        self.house = newHouse
                        self.setPreviewValues()
                    }
                }
            }
        }
    }

    public func getHouse(
        with id: String
    ) {
        collection?.getDocuments { (querySnapshot, err) in
            if let document = querySnapshot?.documents.first(where: { $0.documentID == id }) {
                self.getHouseFromDocument(document)
            } else {
                print("Error getting documents: \(String(describing: err))")
            }
        }
    }

    public func getRooms(
        for house: String,
        completion: @escaping ([RoomPreview]) -> Void
    ) {
        var rooms: [RoomPreview] = []
        collection?.document(house).collection("rooms").getDocuments() { querySnapshot, err in
            querySnapshot?.documents.forEach { document in
                guard let name = document.data()["name"] as? String
                else { return }
                rooms.append(RoomPreview(id: document.documentID, name: name))
            }
            completion(rooms)
        }
    }

    // MARK: - Post Request
    public func addHouse(
        with name: String
    ) {
        if housePreview.first(where: { $0.name == name }) == nil {
            collection?.document().setData(["name": name])
        } else {
            print("дом с таким названием уже сществует")
        }
    }

    public func addRoom(
        with houseId: String,
        name: String
    ) {
        let roomsCollection = collection?.document(houseId).collection("rooms")
        roomsCollection?.document(name)
            .setData(["name": name, "devices": []])
    }

    public func addDevice(
        houseId: String,
        roomId: String,
        deviceId: String,
        completion: @escaping (_ success: DataManagerResult) -> Void
    ) {
        guard !deviceId.isEmpty,
              let roomDocument = collection?.document(houseId).collection("rooms").document(roomId)
        else {
            completion(.error)
            return
        }

        databasePath?.child(deviceId).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                roomDocument.getDocument { snapshotData, error in
                    guard var devices = snapshotData?.data()?["devices"] as? [String],
                          let roomIndex = self.house?.rooms.firstIndex(where: { $0.id == roomId })
                    else {
                        completion(.error)
                        return
                    }
                    devices.append(deviceId)
                    roomDocument.updateData(["devices": devices]) { error in
                        if error == nil,
                           let roomName = self.house?.rooms.first(where: { $0.id == roomId })?.name {
                            self.house?.rooms[roomIndex].devicesId = devices
                            self.setRoomToDevice(roomName: roomName, deviceId: deviceId) {
                                self.setDevices(for: roomId) {
                                    self.newDeviceId = ""
                                    self.setPreviewValues()
                                    completion(.success)
                                }
                            }
                        }
                    }
                }
            } else {
                completion(.notFoundId)
            }
        }
    }

    public func addToFavorite(
        deviceId: String
    ) {
        guard let houseId = house?.id,
              let roomDocument = collection?.document(houseId).collection("rooms").document("Favorite"),
              let favoriteRoomIndex = house?.rooms.firstIndex(where: { $0.id == "Favorite" })
        else {
            return
        }

        roomDocument.getDocument { snapshotData, error in
            guard var devices = snapshotData?.data()?["devices"] as? [String] else {
                return
            }
            if let deviceIdIndex = devices.firstIndex(where: { $0 == deviceId }) {
                devices.remove(at: deviceIdIndex)
                roomDocument.setData(["devices": devices], merge: true)
                self.removeDeviceObserver(with: deviceId)
            } else {
                devices.append(deviceId)
                roomDocument.updateData(["devices": devices])
            }

            self.house?.rooms[favoriteRoomIndex].devicesId = devices
            self.changeIsFavoriteValue(deviceId: deviceId, isFavorite: devices.contains(deviceId))

            if !devices.contains(deviceId),
               let deviceIndex = self.house?.rooms[favoriteRoomIndex].devices.firstIndex(where: { $0.id == deviceId }) {
                self.house?.rooms[favoriteRoomIndex].devices.remove(at: deviceIndex)
            }
        }
    }

    public func deleteDevice(
        with id: String,
        house: String,
        room: String,
        completion: @escaping () -> Void
    ) {
        guard let roomDocument = collection?.document(house).collection("rooms").document(room) else {
            return
        }

        roomDocument.getDocument { snapshotData, error in
            guard var devices = snapshotData?.data()?["devices"] as? [String],
                  let deviceIndex = devices.firstIndex(where: { $0 == id })
            else {
                return
            }
            devices.remove(at: deviceIndex)
            roomDocument.setData(["devices": devices], merge: true)
            self.removeDeviceObserver(with: id)

            if self.house?.id ?? "" == house,
               let roomIndex = self.house?.rooms.firstIndex(where: { $0.id == room }),
               let deviceIdIndex = self.house?.rooms[roomIndex].devicesId.firstIndex(where: { $0 == id }),
               let deviceIndex = self.house?.rooms[roomIndex].devices.firstIndex(where: { $0.id == id }) {
                self.house?.rooms[roomIndex].devicesId.remove(at: deviceIdIndex)
                self.house?.rooms[roomIndex].devices.remove(at: deviceIndex)
            }
            completion()
        }
    }
}

// MARK: - Realtime Database
extension DataManager {
    // MARK: - Get Request
    public func setPreviewValues() {
        guard let databasePath = databasePath else {
            return
        }
        self.removePreviewObservers()
        self.house?.rooms.forEach { room in
            if let roomIndex = self.house?.rooms.firstIndex(where: { $0.id == room.id }) {
                self.house?.rooms[roomIndex].previewValues = []
            }

            room.devicesId.forEach { id in
                if id.contains("preview") {
                    previewValuesObservers.append(databasePath.child(id).child("previewValues"))
                    databasePath.child(id).child("previewValues")
                        .observe(.value) { [weak self] snapshot, arg  in
                            guard let roomId = self?.house?.rooms.firstIndex(where: { $0.name == room.name }),
                                  let json = snapshot.value as? [String: Any]
                            else {
                                return
                            }
                            self?.house?.rooms[roomId].previewValues = self?.parsePreviewValues(json) ?? []
                        }
                }
            }
        }
    }

    public func setDevices(
        for roomId: String,
        completion: @escaping () -> Void
    ) {
        guard let databasePath = databasePath,
              let roomIndex = self.house?.rooms.firstIndex(where: { $0.id == roomId }),
              let room = self.house?.rooms[roomIndex]
        else {
            return
        }
        self.removeDeviceObservers()
        self.house?.rooms[roomIndex].devices = []

        if room.devicesId.isEmpty {
            completion()
        }

        room.devicesId.forEach { id in
            self.firebaseDeviceObservers.append(databasePath.child(id))
            databasePath.child(id)
                .observe(.value) { [weak self] snapshot, arg  in
                    if let roomId = self?.house?.rooms.firstIndex(where: { $0.name == room.name }),
                       let device = self?.parseDevice(snapshot) {

                        if self?.house?.rooms[roomId].devices.first(where: { $0.id == device.id }) == nil {
                            self?.house?.rooms[roomId].devices.append(device)
                        } else if let deviceIndex = self?.house?.rooms[roomId].devices.firstIndex(where: { $0.id == device.id }) {
                            self?.house?.rooms[roomId].devices[deviceIndex].values = device.values
                        }
                    }
                    if self?.house?.rooms[roomIndex].devices.count == self?.house?.rooms[roomIndex].devicesId.count {
                        completion()
                    }
                }
        }
    }

    private func parsePreviewValues(
        _ previewJson: [String: Any]
    ) -> [Value] {
        var parsedPreviewValues: [Value] = []
        previewJson.forEach { key, value in
            guard let parsedDictionary = value as? [String: Any],
                  let name = parsedDictionary["name"] as? String,
                  let value = parsedDictionary["value"] as? String,
                  let imageSystemName = parsedDictionary["imageSystemName"] as? String
             else {
                return
            }
            parsedPreviewValues.append(Value(name: name, value: value, imageSystemName: imageSystemName))
        }
        return parsedPreviewValues
    }

    private func parseDevice(
        _ snapshot: DataSnapshot
    ) -> Device? {
        guard let json = snapshot.value as? [String: Any],
              let previewJson = json["previewValues"] as? [String: Any]
        else {
            return nil
        }
        var values = parsePreviewValues(previewJson)

        guard let image = json["image"] as? String,
              let id = json["id"] as? String,
              let name = json["name"] as? String,
              let room = json["room"] as? String
        else {
            return nil
        }
        let jsonValues = json["values"] as? [String: Any] ?? [:]
        jsonValues.forEach { key, value in
            guard let parsedDictionary = value as? [String: Any],
                  let name = parsedDictionary["name"] as? String,
                  let value = parsedDictionary["value"] as? String,
                  let imageSystemName = parsedDictionary["imageSystemName"] as? String
            else {
                return
            }
            values.append(Value(name: name, value: value, imageSystemName: imageSystemName))
        }
        return Device(
            id: id,
            name: name,
            image: image,
            room: room,
            values: values,
            isFavorite: json["isFavorite"] as? Bool ?? false
        )
    }
    // MARK: - Post Request
    public func changeIsFavoriteValue(
        deviceId: String,
        isFavorite: Bool
    ) {
        databasePath?.child(deviceId).updateChildValues(["isFavorite": isFavorite])
    }

    public func setRoomToDevice(
        roomName: String,
        deviceId: String,
        completion: @escaping () -> Void
    ) {
        databasePath?.child(deviceId).updateChildValues(["room": roomName]) { error,_ in
            if error == nil {
                completion()
            }
        }
    }

    public func setDefaultValues(
        for device: String
    ) {
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

    private func removePreviewObservers() {
        self.previewValuesObservers.forEach { databaseReference in
            databaseReference.removeAllObservers()
        }
        self.previewValuesObservers = []
    }

    private func removeDeviceObserver(
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

enum DataManagerResult {
    case notFoundId
    case error
    case success
}
