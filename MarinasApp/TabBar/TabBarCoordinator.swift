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
        rootViewController.tabBar.tintColor = .label
    }

    func start() {
        if childCoordinators.count == 0 {
            setupTabBar()
            return
        }
    }

    private func setupTabBar() {
        let marinasSearchCoordinator = MarinasSearchCoordinator()
        marinasSearchCoordinator.start()
        childCoordinators.append(marinasSearchCoordinator)

        let marinasSearchViewController = marinasSearchCoordinator.rootViewController
        setup(vc: marinasSearchViewController, title: "Home", imageName: "house", selectedImageName: "house.fill")

        rootViewController.viewControllers = [marinasSearchViewController]
    }

    private func setup(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        let defaultImage = UIImage(systemName: imageName)
        let selectedImage = UIImage(systemName: selectedImageName)
        let tabBarItem = UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)
        vc.tabBarItem = tabBarItem
    }
}
