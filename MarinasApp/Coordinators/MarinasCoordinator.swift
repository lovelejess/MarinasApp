//
//  MarinasCoordinator.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/24/22.
//

import Foundation
import UIKit
import SafariServices

class MarinasCoordinator: Coordinatable {
    var parentCoordinator: Coordinatable?
    var childCoordinators: [Coordinatable] = []
    var rootViewController: UIViewController {
        return self.navigationController
    }

    var navigationController = UINavigationController()

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

    func navigateBack(data: Any?) {
        // N/A
    }

    private func navigateToMarinaSearch() {
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

    private func navigateToPoint(for details: PointDetails) {
        if rootViewController.children.contains(where: { $0 is PointDetailsViewController }) {
            navigationController.popToRootViewController(animated: true)
        } else {
            let pointDetailsViewController = PointDetailsViewController()
            let networkService = NetworkService(urlSession: .shared)
            let marinasFetcher = MarinasFetcher(networkService: networkService)
            pointDetailsViewController.viewModel = PointDetailsViewModel(marinasFetcher: marinasFetcher, point: details, coordinator: self)
            navigationController.pushViewController(pointDetailsViewController, animated: true)
        }
    }

    private func navigateToWeb(via url: URL) {
        let safariVC = SFSafariViewController(url: url)
        navigationController.present(safariVC, animated: true)
//        if let _ = rootViewController as? PointDetailsViewController {
//            navigationController.present(safariVC, animated: true)
//        }
    }
}
