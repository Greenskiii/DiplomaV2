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
    var subscriptions = Set<AnyCancellable>()

    @Published var house: House? = nil

    @Published var housePreview: [HousePreview] = []
    
    private(set) lazy var onChangeHouse = PassthroughSubject<String, Never>()

    init(
        dataManager: DataManager
    ) {
        self.dataManager = dataManager
        dataManager.$housePreview
            .assign(to: \.housePreview, on: self)
            .store(in: &subscriptions)
        dataManager.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)
        
        onChangeHouse
            .sink { [weak self] houseId in
                self?.dataManager.onChangeHouse.send(houseId)
            }
            .store(in: &subscriptions)
    }
}
