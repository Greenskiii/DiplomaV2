//
//  SettingsModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import SwiftUI
import Combine

final class SettingsModel: ObservableObject {
    let dataManager: DataManager
    let authManager: AuthManager
    var subscriptions = Set<AnyCancellable>()

    var user: User? {
        authManager.getUserInfo()
    }
    
    var logout = PassthroughSubject<Void, Never>()
    
    init(
        authManager: AuthManager,
        dataManager: DataManager,
        onGoToAuthScreen: PassthroughSubject<Void, Never>
    ) {
        self.dataManager = dataManager
        self.authManager = authManager
        
        self.logout
            .sink { [weak self]_ in
                self?.dataManager.removeFCMToken()
                self?.authManager.logOut()
                onGoToAuthScreen.send()
            }
            .store(in: &self.subscriptions)
    }
}
