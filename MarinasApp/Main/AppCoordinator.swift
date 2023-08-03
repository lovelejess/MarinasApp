//
//  AppCoordinator.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import UIKit

class AppCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
        window.rootViewController = tabBarCoordinator.rootViewController
    }

//    func navigate(to route: Route) {
//        switch route {
//        case .rootTabBar: // .rootTabBar(.searchMarinas(.main))
//            handleRoot(route)
//        }
//    }

//    fileprivate func handleRoot(_ route: Route) {
//        let tabBarCoordinator = TabBarCoordinator()
//        tabBarCoordinator.navigate(to: route)
//        childCoordinators.append(tabBarCoordinator)
//        window.rootViewController = tabBarCoordinator.rootViewController
//    }
}
