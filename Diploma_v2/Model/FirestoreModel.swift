//
//  FirestoreModel.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 28.03.2023.
//

import FirebaseFirestore

protocol FirestoreModel {
    init?(id: String, snapshot: DocumentSnapshot)
}

struct Devices: FirestoreModel {
    var ids: [String]
    init?(id: String, snapshot: DocumentSnapshot) {
        self.ids = snapshot.data()?["ids"] as? [String] ?? []
    }
}
