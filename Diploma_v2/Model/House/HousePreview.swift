//
//  HousePreview.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 08.04.2023.
//

import Foundation

struct HousePreview: Equatable, Hashable {
    let id: String
    var name: String
    var rooms: [RoomPreview] = []
}
