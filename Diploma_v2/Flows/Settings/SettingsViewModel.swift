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
    
    var oldName = ""
    var oldEmail = ""
    
    @Published var house: House? = nil
    @Published var housePreview: [HousePreview] = []
    @Published var name = ""
    @Published var email = ""
    @Published var choosenHouseId = ""
    @Published var newPassword = ""
    @Published var settingView = SettingViews.main
    @Published var editMode = false
    @Published var showingLogoutAlert = false
    @Published var deleteHouse = false
    @Published var addHouse = false
    @Published var addRoom = false
    @Published var deleteRoom = false
    @Published var loadViewShown = false
    @Published var passwordAlertIsShown = false
    
    var settingViewPublisher: AnyPublisher<SettingViews, Never> {
        $settingView.eraseToAnyPublisher()
    }
    
    var logout = PassthroughSubject<Void, Never>()
    var onAddHouse = PassthroughSubject<String, Never>()
    var onDeleteHouse = PassthroughSubject<String, Never>()
    var onDeleteRoom = PassthroughSubject<String, Never>()
    var onAddRoom = PassthroughSubject<String, Never>()
    var onGoToRoomsSettings = PassthroughSubject<String, Never>()
    var onSaveUserInfo = PassthroughSubject<Void, Never>()
    var onCancelUserInfoChanges = PassthroughSubject<Void, Never>()
    var onChangePassword = PassthroughSubject<Void, Never>()
    
    init(
        authManager: AuthManager,
        dataManager: DataManager,
        onGoToAuthScreen: PassthroughSubject<Void, Never>
    ) {
        self.dataManager = dataManager
        self.authManager = authManager
        
        self.settingViewPublisher
            .sink { [weak self] settingView in
                guard let self = self,
                      settingView == .account else { return }
                self.name = self.oldName
                self.email = self.oldEmail
                self.newPassword = ""
            }
            .store(in: &subscriptions)
        
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
        
        self.onCancelUserInfoChanges
            .sink { [weak self]_ in
                guard let self = self else { return }
                self.name = self.oldName
                self.email = self.oldEmail
            }
            .store(in: &self.subscriptions)
        
        self.onChangePassword
            .sink { [weak self] _ in
                guard let password = self?.newPassword else { return }
                self?.loadViewShown = true
                self?.authManager.changePassword(newPassword: password) { completion in
                    switch completion {
                    case .error:
                        print("error")
                        self?.loadViewShown = false
                    case .success:
                        self?.loadViewShown = true
                    }
                }
            }
            .store(in: &self.subscriptions)
        
        self.onSaveUserInfo
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.loadViewShown = true
                self.authManager.changeName(name: self.name) { completion in
                    switch completion {
                    case .error:
                        print("error")
                        self.loadViewShown = false
                    case .success:
                        self.oldName = self.name
                        self.authManager.changeEmail(email: self.email) { completion in
                            switch completion {
                            case .error:
                                print("error")
                            case .success:
                                print("Success")
                                self.oldEmail = self.email
                            }
                            self.loadViewShown = false
                        }
                    }
                }
            }
            .store(in: &self.subscriptions)
        
        if let user = authManager.getUserInfo() {
            self.oldName = user.name
            self.oldEmail = user.email
        }
    }
}
