//
//  Device.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import Foundation

struct Device: Hashable {
    let id: String
    let name: String
    let image: String
    let room: String
    var values: [Value]
    var isFavorite: Bool
}
