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

    @Published var housePreview: [HousePreview] = []
    @Published var house: House? = nil
    var onChangeHouse: PassthroughSubject<String, Never> {
        return model.onChangeHouse
    }
    
    init(model: SettingsModel) {
        self.model = model
        model.$housePreview
            .assign(to: \.housePreview, on: self)
            .store(in: &subscriptions)
        model.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)
    }
}
