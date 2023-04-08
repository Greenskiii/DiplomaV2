//
//  SceneDelegate.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 16.01.2023.
//

import SwiftUI

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true

        appCoordinator = AppCoordinator(navCon: navigationController)
        appCoordinator!.start()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
