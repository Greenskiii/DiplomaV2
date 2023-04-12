//
//  AccountSettings.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 12.04.2023.
//

import Foundation

enum AccountSettings: CaseIterable, SettingProtocol {
    case name
    case email
    case changePassword
    
    var title: String {
        switch self {
        case .name:
            return ""
        case .email:
            return ""
        case .changePassword:
            return NSLocalizedString("CHANGE_PASSWORD", comment: "Account Settings")
        }
    }
    
    var imageName: String? {
        switch self {
        case .name:
            return "person"
        case .email:
            return "envelope"
        case .changePassword:
            return "lock"
        }
    }
    
    var hasNextPage: Bool {
        return false
    }
}
