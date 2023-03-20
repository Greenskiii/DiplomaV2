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
    let dataManager: DataManager
    let authManager: AuthManager

    @Published var user: User?
    @Published var house: House? = nil
    @Published var choosenRoomId = "Favorite"
    @Published var showErrorView: Bool = false
    @Published var housePreview: [HousePreview] = []

    var onTapDevice: PassthroughSubject<Device?, Never>
    var onPressAdddevice: PassthroughSubject<Void, Never>
    private(set) lazy var onChooseRoom = PassthroughSubject<String, Never>()
    private(set) lazy var onTapFavorite = PassthroughSubject<Device, Never>()
    private(set) lazy var onChangeHouse = PassthroughSubject<String, Never>()

    var shownRoom: House.Room? {
        guard let house = house else { return nil }
        return house.rooms.first(where: { $0.id == choosenRoomId })
    }

    init(
        dataManager: DataManager,
        authManager: AuthManager,
        onPressAdddevice: PassthroughSubject<Void, Never>,
        onTapDevice: PassthroughSubject<Device?, Never>
    ) {
        self.dataManager = dataManager
        self.authManager = authManager
        self.onTapDevice = onTapDevice
        self.onPressAdddevice = onPressAdddevice
        self.user = authManager.getUserInfo()

        dataManager.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)

        dataManager.$housePreview
            .assign(to: \.housePreview, on: self)
            .store(in: &subscriptions)

        onTapFavorite
            .sink { [weak self] device in
                self?.addToFavorite(device: device)
            }
            .store(in: &subscriptions)

        onChangeHouse
            .sink { [weak self] houseId in
                self?.choosenRoomId = "Favorite"
                self?.dataManager.onChangeHouse.send(houseId)
            }
            .store(in: &subscriptions)
        
        onChooseRoom
            .sink { [weak self] id in
                if self?.choosenRoomId == id {
                    self?.choosenRoomId = ""
                    dataManager.removeDeviceObservers()
                } else {
                    dataManager.setDevices(for: id) {
                        self?.choosenRoomId = id
                    }
                }
            }
            .store(in: &subscriptions)
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
