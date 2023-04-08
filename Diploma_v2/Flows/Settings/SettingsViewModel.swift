//
//  SettingsViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    let dataManager: DataManager
    let authManager: AuthManager
    var subscriptions = Set<AnyCancellable>()
    @Published var house: House? = nil
    @Published var housePreview: [HousePreview] = []
    @Published var name = ""
    @Published var email = ""
    @Published var editMode = false
    @Published var settingView = SettingViews.main
    @Published var showingLogoutAlert = false
    @Published var deleteHouse = false
    @Published var choosenHouseId = ""
    @Published var addHouse = false
    @Published var addRoom = false
    @Published var deleteRoom = false
    
    var user: User? {
        authManager.getUserInfo()
    }
    
    var logout = PassthroughSubject<Void, Never>()
    var onAddHouse = PassthroughSubject<String, Never>()
    var onDeleteHouse = PassthroughSubject<String, Never>()
    var onDeleteRoom = PassthroughSubject<String, Never>()
    var onAddRoom = PassthroughSubject<String, Never>()
    var onGoToRoomsSettings = PassthroughSubject<String, Never>()
    
    init(
        authManager: AuthManager,
        dataManager: DataManager,
        onGoToAuthScreen: PassthroughSubject<Void, Never>
    ) {
        self.dataManager = dataManager
        self.authManager = authManager
        
        dataManager.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)
        
        dataManager.$housePreview
            .assign(to: \.housePreview, on: self)
            .store(in: &subscriptions)
        
        self.onGoToRoomsSettings
            .sink { [weak self] houseId in
                self?.dataManager.setHouse(with: houseId) {
                    withAnimation {
                        self?.settingView = .rooms
                    }
                }
            }
            .store(in: &self.subscriptions)
        
        self.onAddHouse
            .sink { [weak self] house in
                self?.dataManager.addHouse(house)
            }
            .store(in: &self.subscriptions)

        self.onDeleteHouse
            .sink { [weak self] houseId in
                self?.dataManager.deleteHouse(id: houseId)
            }
            .store(in: &self.subscriptions)
        
        self.onDeleteRoom
            .sink { [weak self] roomId in
                self?.dataManager.deleteRoom(id: roomId)
            }
            .store(in: &self.subscriptions)
        
        self.onAddRoom
            .sink { [weak self] room in
                self?.dataManager.addRoom(name: room)
            }
            .store(in: &self.subscriptions)
        
        self.logout
            .sink { [weak self]_ in
//                self?.dataManager.removeFCMToken()
                self?.authManager.logOut()
                onGoToAuthScreen.send()
            }
            .store(in: &self.subscriptions)
    }
}
