//
//  UserHouses.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 08.04.2023.
//

import Foundation
import FirebaseFirestore

struct UserHouses: FirestoreModel {
    let id: String
    var houses: [House]
    var housesLinkPath: [String]
    
    init(id: String,
         houses: [House] = [],
         housesLinkPath: [String] = []
    ) {
        self.id = id
        self.houses = houses
        self.housesLinkPath = housesLinkPath
    }
    
    init?(id: String,
          snapshot: DocumentSnapshot
    ) {
        guard let housesLinkPath = snapshot.data()?["houses"] as? [String] else {
            return nil
        }
        self.init(id: id, housesLinkPath: housesLinkPath)
    }
}
