//
//  DeviceDetailsCoordinator.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 07.02.2023.
//

import UIKit

class DeviceDetailsCoordinator: Coordinator {
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
