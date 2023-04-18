//
//  MainMenuViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 24.01.2023.
//

//import SwiftUI
import Combine
import FirebaseDatabase

class MainMenuViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    let dataManager: DataManager
    let authManager: AuthManager
    
    @Published var user: User? = nil
    @Published var house: House? = nil
    @Published var showErrorView: Bool = false
    @Published var housePreview: [HousePreview] = []
    @Published var choosenRoomId = "Favorite"
    @Published var isMenuShown = false

    var onTapDevice: PassthroughSubject<Device?, Never>
    var onPressAddDevice: PassthroughSubject<Void, Never>
    private(set) lazy var onChooseRoom = PassthroughSubject<String, Never>()
    private(set) lazy var onChangeHouse = PassthroughSubject<String, Never>()

    var shownRoom: Room? {
        guard let house = house else { return nil }
        return house.rooms.first(where: { $0.id == choosenRoomId })
    }
    
    init(
        dataManager: DataManager,
        authManager: AuthManager,
        onPressAddDevice: PassthroughSubject<Void, Never>,
        onTapDevice: PassthroughSubject<Device?, Never>
    ) {
        self.dataManager = dataManager
        self.authManager = authManager
        self.onTapDevice = onTapDevice
        self.onPressAddDevice = onPressAddDevice
        
        authManager.$user
            .assign(to: \.user, on: self)
            .store(in: &subscriptions)
        
        dataManager.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)
        
        dataManager.$housePreview
            .assign(to: \.housePreview, on: self)
            .store(in: &subscriptions)
        
        dataManager.$choosenRoomId
            .assign(to: \.choosenRoomId, on: self)
            .store(in: &subscriptions)
        
        onChooseRoom
            .sink { [weak self] id in
                if self?.choosenRoomId == id {
                    self?.choosenRoomId = ""
                } else {
                    self?.dataManager.choosenRoomId = id
                }
            }
            .store(in: &subscriptions)
        
        onChangeHouse
            .sink { [weak self] houseId in
                self?.dataManager.choosenRoomId = "Favorite"
                self?.dataManager.onChangeHouse.send(houseId)
            }
            .store(in: &subscriptions)
    }
}
