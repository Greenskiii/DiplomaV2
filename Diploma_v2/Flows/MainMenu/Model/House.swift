//
//  House.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 27.01.2023.
//

import Foundation

struct House: Equatable {
    
    var name: String
    var rooms: [Room]
    
    struct Room: Hashable{
        var name: String
        var devicesId: [String]
        var type: RoomType
        var previewValues: [Value] = []
        var devices: [Device] = []

        init(name: String, devicesId: [String], type: String) {
           self.name = name
           self.devicesId = devicesId
           self.type = RoomType.byName(name: type)
        }
    }
    
    struct Device: Hashable {
        let name: String
        let image: String
        let room: String
        var values: [Value]
    }
    
    struct Value: Codable, Hashable {
        var name: String
        var value: String
    }
    
}
