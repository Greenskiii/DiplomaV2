//
//  AppCoordinator.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.01.2023.
//

import UIKit
import SwiftUI

class AppCoordinator: Coordinator {
    @AppStorage("log_status") var logStatus = false

    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var viewController: UIViewController
    var navigationController: UINavigationController? {
        viewController as? UINavigationController
    }
    
    required init(viewController: UIViewController, parentCoordinator: Coordinator) {
        self.parentCoordinator = parentCoordinator
        self.viewController = viewController
    }
    
    init(navCon: UINavigationController) {
        self.viewController = navCon
    }
    
    func start() {
        withAnimation {
            if logStatus {
                goToMainPageScreen()
            } else {
                goToAuthScreen()
            }
        }
    }
    
    func goToAuthScreen() {
        children.removeAll()
        
        let viewController = AuthorizationViewController(viewModel: AuthorizationViewModel(model: AuthorizationModel(authManager: AuthManager(), goToMainMenu: {
            self.goToMainPageScreen()
        })))
        
        let coordinator = AuthorizationCoordinator(viewController: viewController, parentCoordinator: self)
        children.append(coordinator)
        navigationController?.viewControllers = [viewController]
    }
    
    func goToMainPageScreen() {
        children.removeAll()
        
        let viewController = MainMenuViewController(
            viewModel: MainMenuViewModel(
                model: MainMenuDomainModel(
                    authManager: AuthManager(),
                    dataManager: DataManager())))
        let coordinator = MainMenuCoordinator(viewController: viewController, parentCoordinator: self)
        children.append(coordinator)
        navigationController?.viewControllers = [viewController]
    }
}
