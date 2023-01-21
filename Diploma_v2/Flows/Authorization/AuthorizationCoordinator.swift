//
//  AuthorizationCoordinator.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.01.2023.
//

import UIKit

class AuthorizationCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var viewController: UIViewController
    
    required init(viewController: UIViewController, parentCoordinator: Coordinator) {
        self.parentCoordinator = parentCoordinator
        self.viewController = viewController
    }
    
    func start() {
        
    }
}
