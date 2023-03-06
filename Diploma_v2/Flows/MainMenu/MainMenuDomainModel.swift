//
//  MainMenuDomainModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 24.01.2023.
//

//import SwiftUI
import Combine
import FirebaseDatabase

class MainMenuDomainModel {
    var subscriptions = Set<AnyCancellable>()
    let authManager: AuthManager
    let dataManager: DataManager
    var timer = Timer()

    @Published var user: User?
    @Published var house: House? = nil
    @Published var choosenRoomId = "Favorite"
    @Published var housesId: [String] = []
    @Published var addDeviceViewIsOpen: Bool = false
    @Published var newDeviceId = ""
    @Published var showErrorView: Bool = false
    @Published var errorText: String = ""
    @Published var choosenDevice: Device?
    @Published var deviceDetailIsOpen = false

    var onGoToScannerScreen: PassthroughSubject<Void, Never>
    private(set) lazy var onTapDevice = PassthroughSubject<Device?, Never>()
    private(set) lazy var onSaveNewDeviceId = PassthroughSubject<String, Never>()
    private(set) lazy var onPressAdddevice = PassthroughSubject<Void, Never>()
    private(set) lazy var onChooseRoom = PassthroughSubject<String, Never>()
    private(set) lazy var onCloseDeviceDetail = PassthroughSubject<Void, Never>()
    private(set) lazy var onTapFavorite = PassthroughSubject<Device, Never>()

    var onChangeHouse: PassthroughSubject<String, Never> {
        return dataManager.onChangeHouse
    }

    var deviceDetailsViewModel: DeviceDetailsViewModel? {
        if let device = self.choosenDevice,
           let house = self.house {
            return DeviceDetailsViewModel(
                model: DeviceDetailsModel(
                    dataManager: self.dataManager,
                    housesId: housesId,
                    device: device,
                    selectedHouse: house,
                    selectedRoomId: self.choosenRoomId,
                    onCloseDeviceDetail: self.onCloseDeviceDetail
                )
            )
        } else {
            return nil
        }
    }

    var shownRoom: House.Room? {
        guard let house = house else { return nil }
        return house.rooms.first(where: { $0.id == choosenRoomId })
    }

    init(
        authManager: AuthManager,
        dataManager : DataManager,
        onGoToScannerScreen: PassthroughSubject<Void, Never>
    ) {
        self.authManager = authManager
        self.dataManager = dataManager
        self.onGoToScannerScreen = onGoToScannerScreen
        self.user = authManager.getUserInfo()

        dataManager.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)

        dataManager.$housesId
            .assign(to: \.housesId, on: self)
            .store(in: &subscriptions)

        dataManager.$newDeviceId
            .assign(to: \.newDeviceId, on: self)
            .store(in: &subscriptions)

        onSaveNewDeviceId
            .sink { [weak self] deviceId in
                if !deviceId.isEmpty,
                   deviceId.rangeOfCharacter(from: [".", "#", "$", "[", "]"]) == nil,
                   let houseId = self?.house?.id,
                   let roomId = self?.choosenRoomId {
                    dataManager.addDevice(houseId: houseId, roomId: roomId, deviceId: deviceId) { completion in
                        switch completion {
                        case .notFoundId:
                            self?.errorText = "Please check the spelling of the device id"
                            self?.showErrorView = true
                            self?.startTimerForError()
                        case .error:
                            self?.errorText = "Something went wrong, please try again"
                            self?.showErrorView = true
                            self?.startTimerForError()
                        case .success:
                            self?.addDeviceViewIsOpen = false
                        }
                    }
                } else {
                    self?.errorText = "To add a device You must enter its ID"
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
        
        onTapFavorite
            .sink { [weak self] device in
                self?.addToFavorite(device: device)
            }
            .store(in: &subscriptions)

        onChooseRoom
            .sink { [weak self] id in
                if self?.choosenRoomId == id {
                    self?.choosenRoomId = ""
                    dataManager.removeDeviceObservers()
                } else if let roomIndex = self?.house?.rooms.firstIndex(where: { $0.id == id }) {
                    dataManager.setDevices(for: id) {
                        self?.choosenRoomId = self?.house?.rooms[roomIndex].name ?? ""
                    }
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
