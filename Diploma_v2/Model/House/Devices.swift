//
//  Devices.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 15.05.2023.
//

import Foundation
import FirebaseFirestore

struct Devices: FirestoreModel {
    var ids: [String]
    init?(id: String, snapshot: DocumentSnapshot) {
        self.ids = snapshot.data()?["ids"] as? [String] ?? []
    }
}
