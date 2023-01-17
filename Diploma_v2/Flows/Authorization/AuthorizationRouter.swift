//
//  AuthorizationRouter.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI

public enum AuthorizationRouter: NavigationRouter {
    
    case authorization
    case mainMenu
    
    public var transition: NavigationTranisitionStyle {
        switch self {
        case .authorization:
            return .push
        case .mainMenu:
            return .push
        }
    }
    
    @ViewBuilder
    public func view() -> some View {
        switch self {
        case .authorization:
            AuthorizationView()
        case .mainMenu:
            MainMenuView()
        }
    }
}
