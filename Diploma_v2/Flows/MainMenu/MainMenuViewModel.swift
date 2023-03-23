//
//  MainMenuViewModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 22.01.2023.
//

import Foundation
import FirebaseDatabase
import FirebaseCore
import SwiftUI
import Combine

class MainMenuViewModel: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    let model: MainMenuDomainModel

    @Published var choosenRoom = ""
    @Published var selection = 0
    @Published var isDeviceMeuOpen: Bool = false
    @Published var house: House? = nil
    @Published var showErrorView: Bool = false
    @Published var user: User?

    var onChooseRoom: PassthroughSubject<String, Never> {
        return model.onChooseRoom
    }

    var onTapDevice: PassthroughSubject<Device?, Never> {
        return model.onTapDevice
    }

    var onPressAdddevice: PassthroughSubject<Void, Never> {
        return model.onPressAdddevice
    }

    var onTapFavorite: PassthroughSubject<Device, Never> {
        return model.onTapFavorite
    }

    var shownRoom: Room? {
        model.shownRoom
    }
    
    init(model: MainMenuDomainModel) {
        self.model = model

        model.$showErrorView
            .assign(to: \.showErrorView, on: self)
            .store(in: &subscriptions)

        model.$user
            .assign(to: \.user, on: self)
            .store(in: &subscriptions)

        model.$choosenRoomId
            .assign(to: \.choosenRoom, on: self)
            .store(in: &subscriptions)

        model.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)
    }
}
