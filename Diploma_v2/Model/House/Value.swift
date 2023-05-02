//
//  Value.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import Foundation
import FirebaseDatabase
import SwiftUI

struct Value: Hashable {
    var name: String
    var value: String
    let imageSystemName: String
    let valueState: ValueState
    let deviceId: String
    
    init(name: String,
         value: String,
         imageSystemName: String,
         deviceId: String,
         valueState: ValueState
    ) {
        self.name = name
        self.value = value
        self.imageSystemName = imageSystemName
        self.deviceId = deviceId
        self.valueState = valueState
    }
    
    init?(deviceId: String,
          dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let value = dictionary["value"] as? String,
              let imageSystemName = dictionary["imageSystemName"] as? String
        else {
            return nil
        }
        self.deviceId = deviceId
        self.name = name
        self.value = value
        self.imageSystemName = imageSystemName
        if let valueState = dictionary["valueState"] as? String {
            self.valueState = ValueState.allCases.first(where: { $0.rawValue == valueState }) ?? .clear
        } else {
            self.valueState = .clear
        }
    }
}

enum ValueState: String, CaseIterable {
    case good = "good"
    case normal = "normal"
    case bad = "bad"
    case clear = "clear"
    
    var color: Color {
        switch self {
        case .good:
            return Color.green
        case .normal:
            return Color.orange
        case .bad:
            return Color.red
        case .clear:
            return Color.clear
        }
    }
}
