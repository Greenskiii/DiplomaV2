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
    @Published var choosenHouse = ""
    @Published var choosenRoom = ""
    @Published var selection = 0
    @Published var user: User?
    @Published var house: House?
    @Published var houses: [String] = []
    var onChooseRoom: PassthroughSubject<String, Never> {
        return model.onChooseRoom
    }
    
    var onChangeHouse: PassthroughSubject<String, Never> {
        return model.onChangeHouse
    }

    var shownRoom: House.Room? {
        model.shownRoom
    }
    
    init(model: MainMenuDomainModel) {
        self.model = model
        
        model.$houses
            .assign(to: \.houses, on: self)
            .store(in: &subscriptions)
        
        model.$choosenRoom
            .assign(to: \.choosenRoom, on: self)
            .store(in: &subscriptions)
        
        model.$choosenHouse
            .assign(to: \.choosenHouse, on: self)
            .store(in: &subscriptions)
        
        model.$user
            .assign(to: \.user, on: self)
            .store(in: &subscriptions)
        model.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)
    }
    
    
}
