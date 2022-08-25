//
//  AppCoordinator.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import UIKit

class AppCoordinator: Coordinatable {
    var parentCoordinator: Coordinatable?
    var childCoordinators: [Coordinatable] = []
    var rootViewController = UIViewController()
    var window: UIWindow?

    convenience init(window: UIWindow, windowScene: UIWindowScene) {
        self.init()
        self.window = window
        self.window?.makeKeyAndVisible()
        self.window?.windowScene = windowScene
    }

    func navigate(to route: Route) {
        switch route {
        case .rootTabBar:
            handleRoot(route)
        }
    }

    func navigateBack(data: Any?) {
        // N/A
    }

    fileprivate func handleRoot(_ route: Route) {
        if let tabBarCoordinator = childCoordinators.first(where: { $0 is TabBarCoordinator }) as? TabBarCoordinator, let window = self.window {
            tabBarCoordinator.navigate(to: route)
            window.rootViewController = tabBarCoordinator.rootViewController
        } else {
            if let window = window {
                let tabBarCoordinator = TabBarCoordinator()
                tabBarCoordinator.parentCoordinator = self
                childCoordinators.append(tabBarCoordinator)
                tabBarCoordinator.navigate(to: route)
                window.rootViewController = tabBarCoordinator.rootViewController
                if let rootViewController = window.rootViewController {
                    self.rootViewController = rootViewController
                }
            }
        }
    }
}
