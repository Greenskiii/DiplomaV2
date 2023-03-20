//
//  DeviceDetailsViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 07.02.2023.
//

import SwiftUI
import Combine

class DeviceDetailsViewModel: ObservableObject {
    let model: DeviceDetailsModel

    @Published var selectedHouseId: String = ""
    @Published var selectedRoomId: String = ""
    @Published var rooms: [String]
    
    let housePreview: [HousePreview]
    let device: Device
    var subscriptions = Set<AnyCancellable>()

    var editViewIsShow: Bool {
        return model.editViewIsShow
    }

    var onDeleteDevice: PassthroughSubject<Void, Never> {
        return model.onDeleteDevice
    }

    var onChangeHouse: PassthroughSubject<String, Never> {
        return model.onChangeHouse
    }

    var onChangeRoom: PassthroughSubject<String, Never> {
        return model.onChangeRoom
    }

    var onCancelChanges: PassthroughSubject<Void, Never> {
        return model.onCancelChanges
    }

    var onSaveChanges: PassthroughSubject<Void, Never> {
        return model.onSaveChanges
    }

    init(model: DeviceDetailsModel) {
        self.model = model
        self.rooms = model.rooms
        self.housePreview = model.housePreview
        self.device = model.device

        model.$selectedHouseId
            .assign(to: \.selectedHouseId, on: self)
            .store(in: &subscriptions)

        model.$selectedRoomId
            .assign(to: \.selectedRoomId, on: self)
            .store(in: &subscriptions)

        model.$rooms
            .assign(to: \.rooms, on: self)
            .store(in: &subscriptions)
    }
}
