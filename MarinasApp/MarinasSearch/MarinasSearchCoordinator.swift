//
//  MarinasSearchCoordinator.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import UIKit
import SafariServices

class MarinasSearchCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    var rootViewController: UINavigationController

    init() {
        rootViewController = UINavigationController()
    }

    private func navigateToMarinaSearch() {
        if rootViewController.children.contains(where: { $0 is MarinasSearchViewController }) {
            rootViewController.popToRootViewController(animated: true)
        } else {
            let marinasSearchViewController = MarinasSearchViewController()
            let networkService = NetworkService(urlSession: .shared)
            let marinasFetcher = MarinasFetcher(networkService: networkService)
            let viewModel = MarinasSearchViewModel(marinasFetcher: marinasFetcher)
            viewModel.coordinatorDelegate = self
            marinasSearchViewController.viewModel = viewModel

            rootViewController.pushViewController(marinasSearchViewController, animated: true)
        }
    }

    private func navigateToPoint(for details: PointDetails) {
        let pointDetailsViewController = PointDetailsViewController()
        let networkService = NetworkService(urlSession: .shared)
        let marinasFetcher = MarinasFetcher(networkService: networkService)
        pointDetailsViewController.viewModel = PointDetailsViewModel(marinasFetcher: marinasFetcher, point: details)
        rootViewController.pushViewController(pointDetailsViewController, animated: true)
    }

    private func navigateToWeb(via url: URL) {
        let safariVC = SFSafariViewController(url: url)
        rootViewController.present(safariVC, animated: true)
    }
}

extension MarinasSearchCoordinator: MarinasSearchCoordinatorDelegate {
    func navigate(to route: Route) {
        switch route {
        case .rootTabBar(.searchMarinas(.main)):
            navigateToMarinaSearch()
        case .rootTabBar(.searchMarinas(.point(let details))):
            navigateToPoint(for: details)
        case .rootTabBar(.searchMarinas(.pointURL(via: let url))):
            navigateToWeb(via: url)
        }
    }
}