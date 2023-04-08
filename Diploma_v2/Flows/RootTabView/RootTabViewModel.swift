//
//  RootTabModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import SwiftUI
import Combine

enum TabType {
    case main
    case settings
}

class RootTabViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    let authManager: AuthManager
    let dataManager: DataManager
    var timer = Timer()
    var mainMenuViewModel: MainMenuViewModel?
    var settingsViewModel: SettingsViewModel?
    
    @Published var selectedTab = TabType.main
    @Published var house: House? = nil
    @Published var addDeviceViewIsOpen: Bool = false
    @Published var newDeviceId = ""
    @Published var showErrorView: Bool = false
    @Published var errorText: String = ""
    @Published var choosenDevice: Device?
    @Published var deviceDetailIsOpen = false
    @Published var housePreview: [HousePreview] = []
    
    var onGoToScannerScreen: PassthroughSubject<Void, Never>
    private(set) lazy var onTapDevice = PassthroughSubject<Device?, Never>()
    private(set) lazy var onSaveNewDeviceId = PassthroughSubject<String, Never>()
    private(set) lazy var onPressAdddevice = PassthroughSubject<Void, Never>()
    private(set) lazy var onCloseDeviceDetail = PassthroughSubject<Void, Never>()
    private(set) lazy var onChangeHouse = PassthroughSubject<String, Never>()
    
    var user: User? {
        authManager.getUserInfo()
    }
    
    var deviceDetailsViewModel: DeviceDetailsViewModel? {
        if let device = self.choosenDevice,
           let house = self.house,
           let choosenRoomId = self.mainMenuViewModel?.choosenRoomId {
            return DeviceDetailsViewModel(
                dataManager: self.dataManager,
                housePreview: housePreview,
                device: device,
                selectedHouse: house,
                selectedRoomId: choosenRoomId,
                onCloseDeviceDetail: self.onCloseDeviceDetail
            )
        } else {
            return nil
        }
    }
    
    init(
        authManager: AuthManager,
        dataManager : DataManager,
        onGoToScannerScreen: PassthroughSubject<Void, Never>,
        onGoToAuthScreen: PassthroughSubject<Void, Never>
    ) {
        self.authManager = authManager
        self.dataManager = dataManager
        self.onGoToScannerScreen = onGoToScannerScreen
        
        self.mainMenuViewModel = MainMenuViewModel(
            dataManager: self.dataManager,
            authManager: self.authManager,
            onPressAdddevice: self.onPressAdddevice,
            onTapDevice: self.onTapDevice
        )
        
        self.settingsViewModel = SettingsViewModel(
            authManager: authManager,
            dataManager: dataManager,
            onGoToAuthScreen: onGoToAuthScreen
        )
        
        dataManager.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)
        
        dataManager.$housePreview
            .assign(to: \.housePreview, on: self)
            .store(in: &subscriptions)
        
        dataManager.$newDeviceId
            .assign(to: \.newDeviceId, on: self)
            .store(in: &subscriptions)
        
        onSaveNewDeviceId
            .sink { [weak self] deviceId in
                if !deviceId.isEmpty,
                   deviceId.rangeOfCharacter(from: [".", "#", "$", "[", "]"]) == nil,
                   let roomId = self?.mainMenuViewModel?.choosenRoomId {
                    dataManager.addDevice(roomId: roomId, deviceId: deviceId) { completion in
                        switch completion {
                        case .notFoundId:
                            self?.errorText = NSLocalizedString("ID_ERROR", comment: "Error")
                            self?.showErrorView = true
                            self?.startTimerForError()
                        case .error:
                            self?.errorText = NSLocalizedString("BASE_ERROR", comment: "Error")
                            self?.showErrorView = true
                            self?.startTimerForError()
                        case .success:
                            self?.addDeviceViewIsOpen = false
                        }
                    }
                } else {
                    self?.errorText = NSLocalizedString("EMPTY_ID_ERROR", comment: "Error")
                    self?.showErrorView = true
                    self?.startTimerForError()
                }
            }
            .store(in: &subscriptions)
        
        onPressAdddevice
            .sink { [weak self] _ in
                self?.addDeviceViewIsOpen.toggle()
            }
            .store(in: &subscriptions)
        
        onTapDevice
            .sink { [weak self] device in
                if device != nil {
                    self?.deviceDetailIsOpen = true
                } else {
                    self?.deviceDetailIsOpen = false
                }
                self?.choosenDevice = device
            }
            .store(in: &subscriptions)
        
        onCloseDeviceDetail
            .sink { [weak self] _ in
                self?.deviceDetailIsOpen = false
            }
            .store(in: &subscriptions)
        
        onChangeHouse
            .sink { [weak self] houseId in
                self?.dataManager.choosenRoomId = "Favorite"
                self?.dataManager.onChangeHouse.send(houseId)
            }
            .store(in: &subscriptions)
    }
    
    func startTimerForError() {
        var seconds: Double = 0.0
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            seconds += 1.0
            if seconds == 2.0 {
                self.timer.invalidate()
                DispatchQueue.main.async() {
                    [weak self] in
                    guard let self = self else { return }
                    self.showErrorView = false
                }
            }
        }
    }
    
    func addToFavorite(device: Device) {
        guard let favoriteRoomIndex = house?.rooms.firstIndex(where: { $0.id == "Favorite" }),
              let house = house
        else {
            return
        }
        if let deviceIndex = house.rooms[favoriteRoomIndex].devices.firstIndex(where: { $0.id == device.id }) {
            self.house?.rooms[favoriteRoomIndex].devices.remove(at: deviceIndex)
        }
        self.dataManager.addToFavorite(deviceId: device.id)
    }
}
