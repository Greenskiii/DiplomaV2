//
//  House.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 28.03.2023.
//

import Foundation
import FirebaseFirestore

struct House: FirestoreModel, Hashable {
    let id: String
    var name: String
    var roomsLinkPath: [String]
    var rooms: [Room]
    
    init(id: String,
         name: String,
         roomsLinkPath: [String] = [],
         rooms: [Room] = []
    ) {
        self.id = id
        self.name = name
        self.roomsLinkPath = roomsLinkPath
        self.rooms = rooms
    }
    
    init?(id: String,
          snapshot: DocumentSnapshot
    ) {
        guard let name = snapshot.data()?["name"] as? String,
              let roomsLinkPath = snapshot.data()?["rooms"] as? [String] else {
            return nil
        }
        self.init(id: id, name: name, roomsLinkPath: roomsLinkPath)
    }
}
