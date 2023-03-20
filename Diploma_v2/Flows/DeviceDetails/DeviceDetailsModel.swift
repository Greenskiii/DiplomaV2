//
//  DeviceDetailsModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 07.02.2023.
//

import SwiftUI
import Combine

class DeviceDetailsModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()

    @Published var selectedHouseId: String
    @Published var selectedRoomId: String
    @Published var rooms: [RoomPreview] = []

    let dataManager: DataManager
    let housePreview: [HousePreview]
    let device: Device
    let oldHouse: String
    let oldRoom: String

    private(set) lazy var onChangeHouse = PassthroughSubject<String, Never>()
    private(set) lazy var onChangeRoom = PassthroughSubject<String, Never>()
    private(set) lazy var onCancelChanges = PassthroughSubject<Void, Never>()
    private(set) lazy var onDeleteDevice = PassthroughSubject<Void, Never>()
    private(set) lazy var onSaveChanges = PassthroughSubject<Void, Never>()

    var editViewIsShow: Bool {
        return selectedHouseId != oldHouse || selectedRoomId != oldRoom
    }

    init(
        dataManager: DataManager,
        housePreview: [HousePreview],
        device: Device,
        selectedHouse: House,
        selectedRoomId: String,
        onCloseDeviceDetail: PassthroughSubject<Void, Never>
    ) {
        self.dataManager = dataManager
        self.housePreview = housePreview
        self.device = device
        self.selectedRoomId = selectedRoomId
        self.selectedHouseId = selectedHouse.id
        self.oldHouse = selectedHouse.id
        self.oldRoom = selectedRoomId

        selectedHouse.rooms.forEach { room in
            if room.id != "Favorite" {
                rooms.append(RoomPreview(id: room.id, name: room.name))
            }
        }

        onDeleteDevice
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.dataManager.deleteDevice(with: device.id, house: self.oldHouse, room: self.oldRoom) {
                    self.dataManager.setPreviewValues()
                    onCloseDeviceDetail.send()
            }
        }
        .store(in: &subscriptions)

        onChangeHouse
            .sink { [weak self] houseId in
            self?.dataManager.getRooms(for: houseId) { rooms in
                var rooms = rooms
                if let favoriteRoomIndex = rooms.firstIndex(where: { $0.id == "Favorite" }) {
                    rooms.remove(at: favoriteRoomIndex)
                }
                self?.rooms = rooms
                self?.selectedHouseId = houseId
                self?.selectedRoomId = ""
            }
        }
        .store(in: &subscriptions)

        onChangeRoom
            .sink { [weak self] roomId in
                self?.selectedRoomId = roomId
            }
            .store(in: &subscriptions)

        onCancelChanges
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.selectedHouseId == self.oldHouse {
                    self.selectedRoomId = self.oldRoom
                } else {
                    self.dataManager.getRooms(for: self.oldHouse) { rooms in
                        self.rooms = rooms
                        self.selectedRoomId = self.oldRoom
                        self.selectedHouseId = self.oldHouse
                    }
                }
            }
        .store(in: &subscriptions)

        onSaveChanges
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.dataManager.addDevice(houseId: self.selectedHouseId, roomId: self.selectedRoomId, deviceId: self.device.id) { success in
                    self.dataManager.deleteDevice(with: device.id, house: self.oldHouse, room: self.oldRoom) {
                        self.dataManager.setPreviewValues()
                        onCloseDeviceDetail.send()
                    }
                }
            }
        .store(in: &subscriptions)
    }
}
