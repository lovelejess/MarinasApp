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
            navigateToMarinaSearch()
        case .rootTabBar(.marinas(.point(let value))):
            navigateToPoint(for: value)
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

    private func navigateToPoint(for value: String) {
        if rootViewController.children.contains(where: { $0 is PointDetailsViewController }) {
            navigationController.popToRootViewController(animated: true)
        } else {
            let pointDetailsViewController = PointDetailsViewController()
            let networkService = NetworkService(urlSession: .shared)
            let marinasFetcher = MarinasFetcher(networkService: networkService)
            let images = PointImages(data: [PointImage(resource: "Resource", thumbnailUrl: "Thumnail URL", smallUrl: "Small")])
            let point = Point(id: "1234", name: value, kind: .harbor, iconURL: "iconURL", images: images)
            pointDetailsViewController.viewModel = PointDetailsViewModel(marinasFetcher: marinasFetcher, point: point)
            pointDetailsViewController.coordinator = self
            navigationController.pushViewController(pointDetailsViewController, animated: true)
        }
    }
}
