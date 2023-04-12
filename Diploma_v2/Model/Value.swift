//
//  Value.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 06.03.2023.
//

import Foundation
import FirebaseDatabase

struct Value: Codable, Hashable {
    var name: String
    var value: String
    let imageSystemName: String
    
    init(name: String,
         value: String,
         imageSystemName: String
    ) {
        self.name = name
        self.value = value
        self.imageSystemName = imageSystemName
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let value = dictionary["value"] as? String,
              let imageSystemName = dictionary["imageSystemName"] as? String
        else {
            return nil
        }
        
        self.name = name
        self.value = value
        self.imageSystemName = imageSystemName
    }
}
