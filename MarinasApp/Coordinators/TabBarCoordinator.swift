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
    var rootViewController: UITabBarController

    init() {
        rootViewController = UITabBarController()
        rootViewController.view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        rootViewController.tabBar.tintColor = .label
    }

    func navigate(to route: Route) {
        if childCoordinators.count == 0 {
            setupTabBar(route)
            return
        }

//        if case Route.rootTabBar(let tabBarRoute) = route {
//            switch tabBarRoute {
//            case .searchMarinas(.main):
//                let marinasCoordinator = childCoordinators.first(where: { $0 is MarinasCoordinator })
//                marinasCoordinator?.navigate(to: route)
//            case .searchMarinas(.point(point: _)):
//                return
//            case .searchMarinas(.pointURL(via: _)):
//                return
//            }
//        }
    }

    private func setupTabBar(_ route: Route) {
        if case Route.rootTabBar = route {
            let marinasCoordinator = MarinasCoordinator()
            marinasCoordinator.navigate(to: .rootTabBar(.searchMarinas(.main)))
            childCoordinators.append(marinasCoordinator)

            let marinasViewController = marinasCoordinator.rootViewController
            setup(vc: marinasViewController, title: "Home", imageName: "house", selectedImageName: "house.fill")

            rootViewController.viewControllers = [marinasViewController]
        }
    }

    private func setup(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        let defaultImage = UIImage(systemName: imageName)
        let selectedImage = UIImage(systemName: selectedImageName)
        let tabBarItem = UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)
        vc.tabBarItem = tabBarItem
    }
}
