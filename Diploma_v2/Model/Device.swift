//
//  Device.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import Foundation
import FirebaseDatabase

struct Device: Hashable {
    let id: String
    let name: String
    let image: String
    let room: String
    var values: [Value]
    var previewValues: [Value] = []
    var isFavorite: Bool
    
    init(id: String,
         name: String,
         image: String,
         room: String,
         values: [Value] = [],
         isFavorite: Bool = false
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.room = room
        self.values = values
        self.isFavorite = isFavorite
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dictionary = snapshot.value as? [String: Any],
              let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let image = dictionary["image"] as? String,
              let room = dictionary["room"] as? String
        else {
            return nil
        }
        var values: [Value] = []
        var previewValues: [Value] = []
        
        if let preview = dictionary["previewValues"] as? [String: Any] {
            preview.forEach { (key, value) in
                if let data = value as? [String: Any],
                   let deviceValue = Value(dictionary: data) {
                    values.append(deviceValue)
                    previewValues.append(deviceValue)
                }
            }
        }
        if let valuesData = dictionary["values"] as? [String: Any] {
            valuesData.forEach { (key, value) in
                if let data = value as? [String: Any],
                   let deviceValue = Value(dictionary: data) {
                    values.append(deviceValue)
                }
            }
        }
        
        self.id = id
        self.name = name
        self.image = image
        self.room = room
        self.values = values
        self.previewValues = previewValues
        self.isFavorite = dictionary["isFavorite"] as? Bool ?? false
    }
}
