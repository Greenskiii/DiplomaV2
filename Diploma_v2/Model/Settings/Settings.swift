//
//  Settings.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 12.04.2023.
//

import Foundation

enum Settings: CaseIterable, SettingProtocol {
    case account
    case houses
    case notifications
    case logout
    
    var title: String {
        switch self {
        case .account:
            return NSLocalizedString("ACCOUNT", comment: "Settings")
        case .notifications:
            return NSLocalizedString("NOTIFICATIONS", comment: "Settings")
        case .houses:
            return NSLocalizedString("HOUSES", comment: "Settings")
        case .logout:
            return NSLocalizedString("LOGOUT", comment: "Settings")
        }
    }
    
    var hasNextPage: Bool {
        switch self {
        case .account, .houses:
            return true
        case .notifications, .logout:
            return false
        }
    }
    
    var imageName: String? {
        nil
    }
}
