//
//  House.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 27.01.2023.
//

import Foundation

struct House: Equatable, Hashable {
    let id: String
    var name: String
    var rooms: [Room]
    
    struct Room: Hashable {
        let id: String
        var name: String
        var devicesId: [String]
        var previewValues: [Value] = []
        var devices: [Device] = []

        init(name: String, devicesId: [String], id: String) {
           self.name = name
           self.devicesId = devicesId
           self.id = id
        }
    }
}

struct HousePreview: Equatable, Hashable {
    let id: String
    var name: String
}

struct RoomPreview: Equatable, Hashable {
    let id: String
    var name: String
}
