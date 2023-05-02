//
//  AppCoordinator.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 18.01.2023.
//

import UIKit
import SwiftUI
import Combine

class AppCoordinator: Coordinator {
    @AppStorage("log_status") var logStatus = false
    
    var subscriptions = Set<AnyCancellable>()
    let dataManager = DataManager()
    let authManager = AuthManager()

    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var viewController: UIViewController
    var navigationController: UINavigationController? {
        viewController as? UINavigationController
    }
    
    private(set) lazy var onGoToAuthScreen = PassthroughSubject<Void, Never>()
    private(set) lazy var onGoToScannerScreen = PassthroughSubject<Void, Never>()
    private(set) lazy var onGoBack = PassthroughSubject<Void, Never>()
    private(set) lazy var onGoToRootTabView = PassthroughSubject<Void, Never>()
    
    required init(viewController: UIViewController, parentCoordinator: Coordinator) {
        self.parentCoordinator = parentCoordinator
        self.viewController = viewController
    }
    
    init(navCon: UINavigationController) {
        self.viewController = navCon
        
        onGoToScannerScreen
            .sink { [weak self] _ in
                self?.goToScannerScreen()
            }
            .store(in: &subscriptions)
        
        onGoToAuthScreen
            .sink { [weak self] _ in
                self?.goToAuthScreen()
            }
            .store(in: &subscriptions)
        
        onGoToRootTabView
            .sink { [weak self] _ in
                self?.goToRootTabView()
            }
            .store(in: &subscriptions)
        
        onGoBack
            .sink { [weak self] _ in
                self?.children.removeLast()
                self?.navigationController?.viewControllers.removeLast()
            }
            .store(in: &subscriptions)
    }
    
    func start() {
        if logStatus {
            goToRootTabView()
        } else {
            goToAuthScreen()
        }
    }
    
    func goToAuthScreen() {
        children.removeAll()
        
        let viewController = AuthorizationViewController(
            viewModel: AuthorizationViewModel(
                authManager: authManager,
                dataManager: dataManager,
                onGoToRootTabView: onGoToRootTabView
            )
        )
        
        let coordinator = AuthorizationCoordinator(viewController: viewController, parentCoordinator: self)
        children.append(coordinator)
        navigationController?.viewControllers = [viewController]
    }
    
    func goToScannerScreen() {
        
        let viewController = ScannerViewController(
            viewModel: ScannerViewModel(
                onGoBack: onGoBack,
                onChangeNewDeviceId: dataManager.onChangeNewDeviceId
            )
        )
        
        let coordinator = MainMenuCoordinator(viewController: viewController, parentCoordinator: self)
        children.append(coordinator)
        navigationController?.viewControllers.append(viewController)
    }
    
    func goToRootTabView() {
        let viewController = RootTabViewController(
            viewModel: RootTabViewModel(
                authManager: authManager,
                dataManager: dataManager,
                onGoToScannerScreen: onGoToScannerScreen,
                onGoToAuthScreen: onGoToAuthScreen
            )
        )
        
        let coordinator = RootTabCoordinator(viewController: viewController, parentCoordinator: self)
        children.append(coordinator)
        navigationController?.viewControllers.append(viewController)
    }
}
