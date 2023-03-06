//
//  MainMenuViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 22.01.2023.
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import SwiftUI
import Combine

class MainMenuViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    let model: MainMenuDomainModel

    @Published var choosenRoom = ""
    @Published var selection = 0
    @Published var user: User?
    @Published var housesId: [String] = []
    @Published var isDeviceMeuOpen: Bool = false
    @Published var house: House? = nil
    @Published var addDeviceViewIsOpen: Bool = false
    @Published var newDeviceId = ""
    @Published var showErrorView: Bool = false
    @Published var errorText: String = ""
    @Published var choosenDevice: Device?
    @Published var deviceDetailIsOpen = false

    private(set) lazy var onSaveNewDeviceId = PassthroughSubject<Void, Never>()

    var deviceDetailsViewModel: DeviceDetailsViewModel? {
        model.deviceDetailsViewModel
    }

    var onChooseRoom: PassthroughSubject<String, Never> {
        return model.onChooseRoom
    }

    var onGoToScannerScreen: PassthroughSubject<Void, Never> {
        return model.onGoToScannerScreen
    }

    var onTapDevice: PassthroughSubject<Device?, Never> {
        return model.onTapDevice
    }

    var onPressAdddevice: PassthroughSubject<Void, Never> {
        return model.onPressAdddevice
    }

    var onTapFavorite: PassthroughSubject<Device, Never> {
        return model.onTapFavorite
    }

    var onChangeHouse: PassthroughSubject<String, Never> {
        return model.onChangeHouse
    }

    var shownRoom: House.Room? {
        model.shownRoom
    }
    
    init(model: MainMenuDomainModel) {
        self.model = model

        model.$housesId
            .assign(to: \.housesId, on: self)
            .store(in: &subscriptions)

        model.$choosenDevice
            .assign(to: \.choosenDevice, on: self)
            .store(in: &subscriptions)

        model.$showErrorView
            .assign(to: \.showErrorView, on: self)
            .store(in: &subscriptions)

        model.$errorText
            .assign(to: \.errorText, on: self)
            .store(in: &subscriptions)

        model.$newDeviceId
            .assign(to: \.newDeviceId, on: self)
            .store(in: &subscriptions)

        model.$choosenRoomId
            .assign(to: \.choosenRoom, on: self)
            .store(in: &subscriptions)

        model.$user
            .assign(to: \.user, on: self)
            .store(in: &subscriptions)

        model.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)

        model.$addDeviceViewIsOpen
            .assign(to: \.addDeviceViewIsOpen, on: self)
            .store(in: &subscriptions)

        model.$deviceDetailIsOpen
            .assign(to: \.deviceDetailIsOpen, on: self)
            .store(in: &subscriptions)

        onSaveNewDeviceId
            .sink { [weak self] _ in
                guard let self = self else { return }
                model.onSaveNewDeviceId.send(self.newDeviceId)
            }
            .store(in: &subscriptions)
    }
}
