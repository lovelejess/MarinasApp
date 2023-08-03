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

    init() {
        rootViewController = UINavigationController()
    }

    func start() {
        let marinasSearchViewController = MarinasSearchViewController()
        let networkService = NetworkService(urlSession: .shared)
        let marinasFetcher = MarinasFetcher(networkService: networkService)
        let viewModel = MarinasSearchViewModel(marinasFetcher: marinasFetcher)
        viewModel.coordinatorDelegate = self
        marinasSearchViewController.viewModel = viewModel

        rootViewController.setViewControllers([marinasSearchViewController], animated: false)
    }

//    private func navigateToMarinaSearch() {
//        if rootViewController.children.contains(where: { $0 is MarinasSearchViewController }) {
//            rootViewController.popToRootViewController(animated: true)
//        } else {
//            let marinasSearchViewController = MarinasSearchViewController()
//            let networkService = NetworkService(urlSession: .shared)
//            let marinasFetcher = MarinasFetcher(networkService: networkService)
//            let viewModel = MarinasSearchViewModel(marinasFetcher: marinasFetcher)
//            viewModel.coordinatorDelegate = self
//            marinasSearchViewController.viewModel = viewModel
//
//            rootViewController.setViewControllers([marinasSearchViewController], animated: false)
//        }
//    }

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
