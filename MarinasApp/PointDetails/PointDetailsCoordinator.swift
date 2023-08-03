//
//  PointDetailsCoordinator.swift
//  MarinasApp
//
//  Created by Jess Lê on 8/3/23.
//

import Foundation
import SafariServices
import UIKit

class PointDetailsCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    var rootViewController: UINavigationController

    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start(for point: PointDetails) {
        let pointDetailsViewController = PointDetailsViewController()
        let networkService = NetworkService(urlSession: .shared)
        let marinasFetcher = MarinasFetcher(networkService: networkService)
        let viewModel = PointDetailsViewModel(marinasFetcher: marinasFetcher, point: point)
        viewModel.coordinatorDelegate = self
        pointDetailsViewController.viewModel = viewModel
        rootViewController.pushViewController(pointDetailsViewController, animated: true)
    }

    private func navigateToWeb(via url: URL) {
        let safariVC = SFSafariViewController(url: url)
        rootViewController.present(safariVC, animated: true)
    }
}

extension PointDetailsCoordinator: PointDetailsCoordinatorDelegate {
    func navigate(to route: Route.PointDetailsRoute) {
        switch route {
        case .webView(via: let url):
            navigateToWeb(via: url)
        }
    }
}
