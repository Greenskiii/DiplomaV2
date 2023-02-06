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

    let authManager: AuthManager
    let dataManager: DataManager
    @Published var user: User?
    @Published var house: House? = nil
    @Published var choosenRoom = ""
    @Published var choosenHouse = ""
    @Published var houses: [String] = []

    let onChooseRoom = PassthroughSubject<String, Never>()
    
    var onChangeHouse: PassthroughSubject<String, Never> {
        return dataManager.onChangeHouse
    }
    
    var shownRoom: House.Room? {
        guard let house = house else { return nil }
        return house.rooms.first(where: { $0.name == choosenRoom })
    }

    init(
        authManager: AuthManager,
        dataManager : DataManager
    ) {
        self.authManager = authManager
        self.dataManager = dataManager
        
        self.user = authManager.getUserInfo()
        
        dataManager.$houses
            .assign(to: \.houses, on: self)
            .store(in: &subscriptions)
        
        dataManager.$choosenHouse
            .assign(to: \.choosenHouse, on: self)
            .store(in: &subscriptions)
        
        dataManager.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)
        
        dataManager.$house
            .assign(to: \.house, on: self)
            .store(in: &subscriptions)
        
        onChooseRoom
            .sink { name in
                if self.choosenRoom == name {
                    self.choosenRoom = ""
                    dataManager.removeObservers()
                } else if let roomIndex = self.house?.rooms.firstIndex(where: { $0.name == name }) {
                    self.choosenRoom = self.house?.rooms[roomIndex].name ?? ""
                    dataManager.setDevices(for: self.choosenRoom)
                }
            }
            .store(in: &subscriptions)

    }
}
