//
//  SettingsViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    let model: SettingsModel
    var subscriptions = Set<AnyCancellable>()
    @Published var name = ""
    @Published var email = ""
    var user: User? {
        model.user
    }
    
    var logout: PassthroughSubject<Void, Never> {
        model.logout
    }

    init(model: SettingsModel) {
        self.model = model
        
        if let user = model.user {
            self.name = user.name
            self.email = user.email
        }
    }
}
