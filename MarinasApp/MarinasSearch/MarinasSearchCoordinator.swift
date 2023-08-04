//
//  MarinasSearchCoordinator.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import UIKit

class MarinasSearchCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    var rootViewController: UINavigationController
    var viewModel: MarinasSearchViewModel
    var marinasSearchViewController: MarinasSearchViewController

    init() {
        rootViewController = UINavigationController()
        let networkService = NetworkService(urlSession: .shared)
        let marinasFetcher = MarinasFetcher(networkService: networkService)
        viewModel = MarinasSearchViewModel(marinasFetcher: marinasFetcher)
        marinasSearchViewController = MarinasSearchViewController()
        marinasSearchViewController.viewModel = viewModel
        viewModel.coordinatorDelegate = self
        marinasSearchViewController.viewModel = viewModel
    }

    func start() {
        rootViewController.setViewControllers([marinasSearchViewController], animated: false)
    }

    private func navigateToPoint(for details: PointDetails) {
        let pointDetailsCoordinator = PointDetailsCoordinator(rootViewController: rootViewController)
        pointDetailsCoordinator.start(for: details)
        childCoordinators.append(pointDetailsCoordinator)
    }
}

extension MarinasSearchCoordinator: MarinasSearchCoordinatorDelegate {
    func navigate(to route: Route.MarinasSearchRoute) {
        switch route {
        case .details(let details):
            navigateToPoint(for: details)
        }
    }
}
