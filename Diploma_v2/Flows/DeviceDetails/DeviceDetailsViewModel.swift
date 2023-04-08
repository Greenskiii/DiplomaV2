//
//  DeviceDetailsModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 07.02.2023.
//

import SwiftUI
import Combine

class DeviceDetailsViewModel: ObservableObject {
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
                self.dataManager.deleteDevice(with: device.id, houseId: self.oldHouse, roomId: self.oldRoom) {
                    onCloseDeviceDetail.send()
                }
            }
            .store(in: &subscriptions)
        
        onChangeHouse
            .sink { [weak self] houseId in
                self?.selectedHouseId = houseId
                self?.rooms = self?.housePreview.first(where: { $0.id == houseId })?.rooms ?? []
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
                self.selectedHouseId = self.oldHouse
                self.selectedRoomId = self.oldRoom
            }
            .store(in: &subscriptions)
        
        onSaveChanges
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.dataManager.deleteDevice(with: device.id, houseId: self.oldHouse, roomId: self.oldRoom) {
                    self.dataManager.addDevice(roomId: self.selectedRoomId, deviceId: self.device.id) { success in
                        onCloseDeviceDetail.send()
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
