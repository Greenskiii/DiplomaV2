//
//  RootTabModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import SwiftUI
import Combine

enum TabType: CaseIterable {
    case main
    case settings
    
    var icon: String {
        switch self {
        case .main:
            return "house.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .main:
            return 0
        case .settings:
            return 1
        }
    }
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
    @Published var newDeviceId = ""
    @Published var addDeviceViewIsOpen: Bool = false
    @Published var showErrorView: Bool = false
    @Published var loadViewShown: Bool = false
    @Published var deviceDetailIsOpen = false
    @Published var errorText: String = ""
    @Published var choosenDevice: Device?
    @Published var housePreview: [HousePreview] = []
    @Published var user: User? = nil
    
    private(set) var onGoToScannerScreen: PassthroughSubject<Void, Never>
    private(set) var onTapDevice = PassthroughSubject<Device?, Never>()
    private(set) var onSaveNewDeviceId = PassthroughSubject<String, Never>()
    private(set) var onPressAddDevice = PassthroughSubject<Void, Never>()
    private(set) var onCloseDeviceDetail = PassthroughSubject<Void, Never>()
    
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
            onPressAddDevice: self.onPressAddDevice,
            onTapDevice: self.onTapDevice
        )
        
        self.settingsViewModel = SettingsViewModel(
            authManager: self.authManager,
            dataManager: self.dataManager,
            onGoToAuthScreen: onGoToAuthScreen
        )
        
        authManager.$user
            .assign(to: \.user, on: self)
            .store(in: &subscriptions)
        
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
                            withAnimation {
                                self?.showErrorView = true
                            }
                            self?.startTimerForError()
                        case .error:
                            self?.errorText = NSLocalizedString("BASE_ERROR", comment: "Error")
                            withAnimation {
                                self?.showErrorView = true
                            }
                            self?.startTimerForError()
                        case .success:
                            withAnimation {
                                self?.addDeviceViewIsOpen = false
                            }
                        }
                    }
                } else {
                    self?.errorText = NSLocalizedString("EMPTY_ID_ERROR", comment: "Error")
                    withAnimation {
                        self?.showErrorView = true
                    }
                    self?.startTimerForError()
                }
            }
            .store(in: &subscriptions)
        
        onPressAddDevice
            .sink { [weak self] _ in
                withAnimation {
                    self?.addDeviceViewIsOpen.toggle()
                }
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
                    withAnimation {
                        self.showErrorView = false
                    }
                }
            }
        }
    }
}
