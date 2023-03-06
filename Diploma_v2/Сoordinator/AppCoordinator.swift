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
    var dataManager = DataManager()
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var viewController: UIViewController
    var navigationController: UINavigationController? {
        viewController as? UINavigationController
    }

    private(set) lazy var onGoToMainPageScreen = PassthroughSubject<Void, Never>()
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

        onGoToMainPageScreen
            .sink { [weak self] _ in
                self?.goToMainPageScreen()
            }
            .store(in: &subscriptions)

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
                model: AuthorizationModel(
                    authManager: AuthManager(),
                    dataManager: dataManager,
                    onGoToRootTabView: onGoToRootTabView
                )
            )
        )

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
                    dataManager: dataManager,
                    onGoToScannerScreen: onGoToScannerScreen
                )
            )
        )

        let coordinator = MainMenuCoordinator(viewController: viewController, parentCoordinator: self)
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
                mainMenuViewModel:  MainMenuViewModel(
                    model: MainMenuDomainModel(
                        authManager: AuthManager(),
                        dataManager: dataManager,
                        onGoToScannerScreen: onGoToScannerScreen
                    )
                ), settingsViewModel: SettingsViewModel(
                    model: SettingsModel()
                )
            )
        )

        let coordinator = RootTabCoordinator(viewController: viewController, parentCoordinator: self)
        children.append(coordinator)
        navigationController?.viewControllers.append(viewController)
    }
}
