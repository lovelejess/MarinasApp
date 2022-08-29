//
//  MarinasCoordinator.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import UIKit

class MarinasCoordinator: Coordinatable {
    var parentCoordinator: Coordinatable?
    var childCoordinators: [Coordinatable] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }

    var navigationController = UINavigationController()

    func navigate(to route: Route) {
        switch route {
        case .rootTabBar(.marinas(.home)):
            navigateToPoints()
        default: parentCoordinator?.navigate(to: route)
        }
    }

    func navigateBack(data: Any?) {
        // N/A
    }

    private func navigateToPoints() {
        if rootViewController.children.contains(where: { $0 is MarinaPointsViewController }) {
            navigationController.popToRootViewController(animated: true)
        } else {
            let marinaPointsViewController = MarinaPointsViewController()
            let networkService = NetworkService(urlSession: .shared)
            let marinasFetcher = MarinasFetcher(networkService: networkService)
            marinaPointsViewController.viewModel = MarinasPointViewModel(marinasFetcher: marinasFetcher)
            marinaPointsViewController.coordinator = self
            navigationController.pushViewController(marinaPointsViewController, animated: true)
        }
    }
}
