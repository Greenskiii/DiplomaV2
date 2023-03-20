//
//  RootTabViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.03.2023.
//

import SwiftUI
import Combine

class RootTabViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    let model: RootTabModel

    @Published var selectedTab = TabType.main
    @Published var selection = 0
    @Published var isDeviceMeuOpen: Bool = false
    @Published var house: House? = nil
    @Published var addDeviceViewIsOpen: Bool = false
    @Published var newDeviceId = ""
    @Published var showErrorView: Bool = false
    @Published var errorText: String = ""
    @Published var choosenDevice: Device?
    @Published var deviceDetailIsOpen = false

    private(set) lazy var onSaveNewDeviceId = PassthroughSubject<Void, Never>()

    var mainMenuViewModel: MainMenuViewModel? {
        model.mainMenuViewModel
    }

    var settingsViewModel: SettingsViewModel? {
        model.settingsViewModel
    }

    var deviceDetailsViewModel: DeviceDetailsViewModel? {
        model.deviceDetailsViewModel
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

    init(model: RootTabModel) {
        self.model = model

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
