//
//  DataManager.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 24.01.2023.
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import Combine

class DataManager {
    private var subscriptions = Set<AnyCancellable>()
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private var firebaseObservers: [DatabaseReference] = []
    private var previewValuesObservers: [DatabaseReference] = []

    @Published var house: House? = nil
    @Published var houses: [String] = []
    @Published var choosenHouse = ""

    private(set) lazy var onGetHouseFromDocument = PassthroughSubject<QueryDocumentSnapshot, Never>()
    private(set) lazy var onChangeHouse = PassthroughSubject<String, Never>()

    var choosenHousePublisher: AnyPublisher<String, Never> {
        $choosenHouse
            .eraseToAnyPublisher()
    }

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
            .sink { id in
                self.getHouse(with: id)
            }
            .store(in: &self.subscriptions)

        choosenHousePublisher
            .sink { id in
                self.getHouse(with: id)
            }
            .store(in: &self.subscriptions)

        onGetHouseFromDocument
            .sink { houseDocument in
                guard let housename = houseDocument.data()["name"] as? String else { return }
                self.house = House(name: housename, rooms: [])
                houseDocument.reference.collection("rooms").getDocuments { (querySnapshot, err) in
                    guard let roomDocuments = querySnapshot?.documents else { return }
                    roomDocuments.forEach { roomDocument in
                        roomDocument.reference.getDocument { (querySnapshot, err) in
                            guard let data = querySnapshot?.data() else { return }

                            let room = House.Room(
                                name: data["name"] as? String ?? data[" name"] as? String ?? "",
                                devicesId: data["devices"] as? [String] ?? [],
                                type: data["type"] as? String ?? ""
                            )

                            self.house?.rooms.append(room)

                            if self.house?.rooms.count == roomDocuments.count {
                                self.setPreviewValues()
                            }
                        }
                    }
                }
            }
            .store(in: &self.subscriptions)
    }

    private func getHousesId() {
        collection?.getDocuments { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents,
                  let firstDoc = querySnapshot?.documents.first else {
                return
            }
            documents.forEach { document in
                self.houses.append(document.documentID)
            }
            self.choosenHouse = firstDoc.documentID
        }
    }
    
    private func getHouse(with id: String) {
        collection?.getDocuments { (querySnapshot, err) in
            if let document = querySnapshot?.documents.first(where: { $0.documentID == id }) {
                self.onGetHouseFromDocument.send(document)
                self.removePreviewObservers()
            } else {
                print("Error getting documents: \(String(describing: err))")
            }
        }
    }
}

// MARK: - Database
extension DataManager {
    
}

// MARK: - Realtime Database
extension DataManager {

    private func setPreviewValues() {
        guard let databasePath = databasePath else { return }
        self.house?.rooms.forEach { room in
            room.devicesId.forEach { id in
                if id.contains("atmospheric") {
                    previewValuesObservers.append(databasePath.child(id).child("atmospheric"))
                    databasePath.child(id).child("atmospheric")
                        .observe(.value) { [weak self] snapshot, arg  in
                            guard let roomId = self?.house?.rooms.firstIndex(where: { $0.name == room.name })
                            else {
                                return
                            }
                            self?.parseDevice(snapshot, isPreviewValue: true, roomId: roomId)
                        }
                }
            }
        }
    }

    func setDevices(for roomId: String) {
        guard let databasePath = databasePath,
              let room = self.house?.rooms.first(where: { $0.name == roomId })
        else {
            return
        }
        self.removeObservers()
        room.devicesId.forEach { id in
            self.firebaseObservers.append(databasePath.child(id))
            databasePath.child(id)
                .observe(.value) { [weak self] snapshot, arg  in
                    guard let roomId = self?.house?.rooms.firstIndex(where: { $0.name == room.name })
                    else {
                        return
                    }
                    self?.parseDevice(snapshot, isPreviewValue: false, roomId: roomId)
                }
        }
    }

    private func parseDevice(_ snapshot: DataSnapshot, isPreviewValue: Bool, roomId: Int) {
        guard let json = snapshot.value as? [String: Any] else {
            return
        }
        var deviceName = ""
        let room = self.house?.rooms[roomId]

        if !isPreviewValue,
            let jsonDeviceName = json["name"] as? String,
            let image = json["image"] as? String,
           room?.devices.firstIndex(where: { $0.name == jsonDeviceName }) == nil {

            let device = House.Device(
                name: jsonDeviceName,
                image: image,
                room: self.house?.rooms[roomId].name ?? "",
                values: []
            )
            deviceName = jsonDeviceName
            self.house?.rooms[roomId].devices.append(device)
        }

        json.forEach { key, value in
            guard let parsedDictionary = value as? [String: Any],
                  let name = parsedDictionary["name"] as? String,
                  let value = parsedDictionary["value"] as? String
            else {
                return
            }

            if isPreviewValue {
                self.addToPreviewValues(
                    name: name,
                    value: value,
                    roomId: roomId
                )
            } else {
                self.addToDevices(
                    name: name,
                    value: value,
                    roomId: roomId,
                    deviceName: deviceName
                )
            }
        }
    }

    func addToDevices(name: String, value: String, roomId: Int, deviceName: String) {
        let room = self.house?.rooms[roomId]

        guard let deviceIndex = room?.devices.firstIndex(where: { $0.name == deviceName }) else {
            return
        }
        let deviceValues = room?.devices[deviceIndex].values

        if let valueIndex = deviceValues?.firstIndex(where: { $0.name == name }) {
            self.house?.rooms[roomId].devices[deviceIndex].values[valueIndex].value = value
        } else {
            self.house?.rooms[roomId].devices[deviceIndex].values.append(House.Value(name: name, value: value))
        }
    }

    func addToPreviewValues(name: String, value: String, roomId: Int) {
        if let previewValueIndex = self.house?.rooms[roomId].previewValues.firstIndex(where: { $0.name == name }) {
            self.house?.rooms[roomId].previewValues[previewValueIndex].value = value
        } else {
            let previewValue = House.Value(name: name, value: value)
            self.house?.rooms[roomId].previewValues.append(previewValue)
        }
    }

    func removeObservers() {
        self.firebaseObservers.forEach { databaseReference in
            databaseReference.removeAllObservers()
        }
        self.firebaseObservers = []
    }

    func removePreviewObservers() {
        self.previewValuesObservers.forEach { databaseReference in
            databaseReference.removeAllObservers()
        }
        self.previewValuesObservers = []
    }
}
