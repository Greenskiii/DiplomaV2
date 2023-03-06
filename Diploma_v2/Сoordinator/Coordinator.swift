//
//  Coordinator.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import Foundation
import UIKit.UIViewController

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var viewController: UIViewController { get set }

    init(viewController: UIViewController, parentCoordinator: Coordinator)
    func start()
}
