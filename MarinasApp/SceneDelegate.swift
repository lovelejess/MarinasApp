//
//  SceneDelegate.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let coordinator = AppCoordinator(window: window)
            coordinator.navigate(to: .rootTabBar(.searchMarinas(.main)))
            self.appCoordinator = coordinator
            window.makeKeyAndVisible()
        }
    }
}
