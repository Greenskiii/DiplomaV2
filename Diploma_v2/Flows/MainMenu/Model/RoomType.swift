//
//  RoomType.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 27.01.2023.
//

import Foundation

enum RoomType: CaseIterable, Codable {
    case bathroom
    case bedroom
    case kitchen
    case diningroom
    case livingroom
    case corridor
    case wardrobe
    case laundry
    case attic
    case balcony
    
    var image : String {
        switch self {
        case .bathroom:
            return "bathroom"
        case .bedroom:
            return "bedroom"
        case .kitchen:
            return "kitchen"
        case .diningroom:
            return "diningroom"
        case .livingroom:
            return "livingroom"
        case .corridor:
            return "corridor"
        case .wardrobe:
            return "wardrobe"
        case .laundry:
            return "laundry"
        case .attic:
            return "attic"
        case .balcony:
            return "balcony"
        }
    }
    
    static func byName(name: String) -> RoomType {
        return RoomType.allCases.first(where: {$0.image.elementsEqual(name)}) ?? .bedroom
        }
}
