//
//  House.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 27.01.2023.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct House: Equatable, Hashable {
    let id: String
    var name: String
    var rooms: [Room]
    
    init(id: String, name: String, rooms: [Room]) {
        self.id = id
        self.name = name
        self.rooms = rooms
    }
}

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
    
    init?(id: String, from document: [String: Any]) {
        guard let name = document["name"] as? String,
        let devicesId = document["devices"] as? [String] else { return nil }
        self.init(name: name, devicesId: devicesId, id: id)
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
