//
//  Room.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 28.03.2023.
//

import Foundation
import FirebaseFirestore

struct Room: FirestoreModel, Hashable {
    let id: String
    var name: String
    var devicesId: [String]
    var previewDeviceId: String?
    var devices: [Device]
    var values: [Value]
    var previewValues: [Value]
    
    init(id: String,
         name: String,
         previewDeviceId: String? = nil,
         devicesId: [String] = [],
         devices: [Device] = [],
         values: [Value] = [],
         previewValues: [Value] = []
    ) {
        self.id = id
        self.name = name
        self.devicesId = devicesId
        self.devices = devices
        self.values = values
        self.previewValues = previewValues
        self.previewDeviceId = previewDeviceId
    }
    
    init?(id: String,
          snapshot: DocumentSnapshot
    ) {
        guard let name = snapshot.data()?["name"] as? String else {
            return nil
        }
        self.init(id: id, name: name, devicesId: snapshot.data()?["devices"] as? [String] ?? [])
    }
}
