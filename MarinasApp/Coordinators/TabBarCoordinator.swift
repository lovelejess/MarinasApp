//
//  TabBarCoordinator.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import UIKit

class TabBarCoordinator: Coordinatable {
    var parentCoordinator: Coordinatable?
    var childCoordinators: [Coordinatable] = []
    var rootViewController = UIViewController()

    func navigate(to route: Route) {
        if childCoordinators.count == 0 {
            setupTabBar(route)
            return
        }

        guard let tabBarController = rootViewController as? UITabBarController else { return }

        if case Route.rootTabBar(let tabBarRoute) = route {
            switch tabBarRoute {
            case .marinas(_):
                let marinasCoordinator = childCoordinators.first(where: { $0 is MarinasCoordinator })
                tabBarController.selectedViewController = marinasCoordinator?.rootViewController
                marinasCoordinator?.navigate(to: route)
            }
        }
    }

    func navigateBack(data: Any?) {
        // N/A
    }

    private func setupTabBar(_ route: Route) {
        if case Route.rootTabBar = route {
            let tabBarViewController = TabBarController()
            tabBarViewController.coordinator = self

            tabBarViewController.view.backgroundColor = .systemBackground
            UITabBar.appearance().barTintColor = .systemBackground
            tabBarViewController.tabBar.tintColor = .label

            let marinasCoordinator = MarinasCoordinator()
            marinasCoordinator.parentCoordinator = self
            marinasCoordinator.navigate(to: .rootTabBar(.marinas(.home)))

            childCoordinators = [marinasCoordinator]

            let homeNavController = marinasCoordinator.navigationController
            homeNavController.tabBarItem.title = "Home"
            homeNavController.tabBarItem.image = UIImage(systemName: "house")!

            tabBarViewController.viewControllers = [homeNavController]

            rootViewController = tabBarViewController

            switch route {
            case .rootTabBar(.marinas(_)):
                tabBarViewController.selectedViewController = marinasCoordinator.rootViewController
            default:
                parentCoordinator?.navigate(to: route)
            }
        }
    }
}