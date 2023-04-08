//
//  RootTabCoordinator.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 03.03.2023.
//

import UIKit

final class RootTabCoordinator: Coordinator {
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
